//
//  ReadDeviceLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "ReadDeviceLog.h"


typedef struct {
    service_conn_t connection;
    CFSocketRef socket;
    CFRunLoopSourceRef source;
} DeviceConsoleConnection;


@implementation ReadDeviceLog


static CFMutableDictionaryRef liveConnections = nil;
static CFMutableDictionaryRef deviceName = nil;


static void DeviceNotificationCallback(am_device_notification_callback_info *info, void *unknown);
ReadDeviceLog *gReadDeviceLogObject = nil;


#pragma mark -


- (id)init
{
    
    self = [super init];
    if(self) {
        gReadDeviceLogObject = self;
    }
    
    return self;
}

- (void)startLogging
{
    
    liveConnections = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
    deviceName = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
    am_device_notification *notification;
    AMDeviceNotificationSubscribe(DeviceNotificationCallback, 0, 0, NULL, &notification);
    CFRunLoopRun();
}


@end


#pragma mark - Socket Callback


static void SocketCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    
    // Skip null bytes
    ssize_t length = CFDataGetLength(data);
    const char *buffer = (const char *)CFDataGetBytePtr(data);
    while (length) {
        while (*buffer == '\0') {
            buffer++;
            length--;
            if (length == 0)
                return;
        }
        size_t extentLength = 0;
        while ((buffer[extentLength] != '\0') && extentLength != length) {
            extentLength++;
        }
        
        NSString *deviceID = [NSString stringWithUTF8String:CFDictionaryGetValue(deviceName, s)];
        if(deviceID)
        {
            [gReadDeviceLogObject.delegate analizeWithLogBuffer:buffer length:(NSInteger)extentLength deviceID:deviceID];
        }

        length -= extentLength;
        buffer += extentLength;
    }
}


#pragma mark - Device Callback
static void DeviceNotificationCallback(am_device_notification_callback_info *info, void *unknown)
{
    
    struct am_device *device = info->dev;
    switch (info->msg) {
        case ADNCI_MSG_CONNECTED: {
                       if (AMDeviceConnect(device) == MDERR_OK) {
                if (AMDeviceIsPaired(device) && (AMDeviceValidatePairing(device) == MDERR_OK)) {
                    if (AMDeviceStartSession(device) == MDERR_OK) {
                        service_conn_t connection;
                        if (AMDeviceStartService(device, AMSVC_SYSLOG_RELAY, &connection, NULL) == MDERR_OK) {
                            CFSocketRef socket = CFSocketCreateWithNative(kCFAllocatorDefault, connection, kCFSocketDataCallBack, SocketCallback, NULL);
                            if (socket) {
                                CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
                                if (source) {
                                    CFRunLoopAddSource(CFRunLoopGetMain(), source, kCFRunLoopCommonModes);
                                    AMDeviceRetain(device);
                                    DeviceConsoleConnection *data = malloc(sizeof *data);
                                    data->connection = connection;
                                    data->socket = socket;
                                    data->source = source;
                                    CFDictionarySetValue(liveConnections, device, data);
                                    
                                    char *buf;
                                    buf = (char *)malloc(sizeof(int)*3 + 2);
                                    snprintf(buf,sizeof(buf), "%d", device->product_id);
                                    
                                    CFDictionarySetValue(deviceName, data->socket, buf);
                                    
                                    [gReadDeviceLogObject.delegate deviceConnected];
                                    
                                    return;
                                }
                                CFRelease(source);
                            }
                        }
                        AMDeviceStopSession(device);
                    }
                }
            }
            AMDeviceDisconnect(device);
            break;
        }
        case ADNCI_MSG_DISCONNECTED: {
            DeviceConsoleConnection *data = (DeviceConsoleConnection *)CFDictionaryGetValue(liveConnections, device);
            if (data) {
                
                NSString *deviceID = [NSString stringWithUTF8String:CFDictionaryGetValue(deviceName, data->socket)];
                if(deviceID)
                {
                    
                    [gReadDeviceLogObject.delegate deviceDisConnectedWithDeviceID:deviceID];

                }

                
                
                CFDictionaryRemoveValue(liveConnections, device);
                CFDictionaryRemoveValue(deviceName, data->socket);
                AMDeviceRelease(device);
                CFRunLoopRemoveSource(CFRunLoopGetMain(), data->source, kCFRunLoopCommonModes);
                CFRelease(data->source);
                CFRelease(data->socket);
                free(data);
                AMDeviceStopSession(device);
                AMDeviceDisconnect(device);
                
            }
            break;
        }
        default:
            break;
    }
}
