//
//  ReadDeviceLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "ReadDeviceLog.h"
#include "MobileDevice.h"
#include <stdio.h>
#include <unistd.h>

@interface ReadDeviceLog()
-(void)analizeWithLogBuffer:(const char*)buffer andSize:(int)length;
@end

@implementation ReadDeviceLog

typedef struct {
    service_conn_t connection;
    CFSocketRef socket;
    CFRunLoopSourceRef source;
} DeviceConsoleConnection;



static CFMutableDictionaryRef liveConnections;
static int debug2;
static CFStringRef requiredDeviceId;
static void DeviceNotificationCallback(am_device_notification_callback_info *info, void *unknown);

ReadDeviceLog* this;

-(id)init{
    
    if ([self class] == [ReadDeviceLog class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    self = [super init];
    if(self) {
        this = self;
    }
    return self;
}

-(void)startLogging{
    
    liveConnections = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
    am_device_notification *notification;
    AMDeviceNotificationSubscribe(DeviceNotificationCallback, 0, 0, NULL, &notification);
    
    CFRunLoopRun();
}

-(void)analizeWithLogBuffer:(const char *)buffer andSize:(int)length{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


@end

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
        
            //Override method
        [this analizeWithLogBuffer:buffer andSize:(int)extentLength];

        length -= extentLength;
        buffer += extentLength;
    }
}

static void DeviceNotificationCallback(am_device_notification_callback_info *info, void *unknown)
{
    
    struct am_device *device = info->dev;
    switch (info->msg) {
        case ADNCI_MSG_CONNECTED: {
            if (debug2) {
                CFStringRef deviceId = AMDeviceCopyDeviceIdentifier(device);
                CFStringRef str = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("deviceconsole connected: %@"), deviceId);
                CFRelease(deviceId);
                CFShow(str);
                CFRelease(str);
            }
            if (requiredDeviceId) {
                CFStringRef deviceId = AMDeviceCopyDeviceIdentifier(device);
                Boolean isRequiredDevice = CFEqual(deviceId, requiredDeviceId);
                CFRelease(deviceId);
                if (!isRequiredDevice)
                    break;
            }
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
            if (debug2) {
                CFStringRef deviceId = AMDeviceCopyDeviceIdentifier(device);
                CFStringRef str = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("deviceconsole disconnected: %@"), deviceId);
                CFRelease(deviceId);
                CFShow(str);
                CFRelease(str);
            }
            DeviceConsoleConnection *data = (DeviceConsoleConnection *)CFDictionaryGetValue(liveConnections, device);
            if (data) {
                CFDictionaryRemoveValue(liveConnections, device);
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
