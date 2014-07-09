//
//  AppDelegate.m
//  DeviceLogView
//
//  Created by LINEPLUS on 2014. 7. 8..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AppDelegate.h"
#include "MobileDevice.h"
#include <stdio.h>
#include <unistd.h>


@implementation AppDelegate


typedef struct {
    service_conn_t connection;
    CFSocketRef socket;
    CFRunLoopSourceRef source;
} DeviceConsoleConnection;



static CFMutableDictionaryRef liveConnections;
static int debug;
static CFStringRef requiredDeviceId;
static char requiredProcessName[256];
static void DeviceNotificationCallback(am_device_notification_callback_info *info, void *unknown);
AppDelegate *sampleClass;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    sampleClass = self;
    
    liveConnections = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
    am_device_notification *notification;
    AMDeviceNotificationSubscribe(DeviceNotificationCallback, 0, 0, NULL, &notification);
    
    
    
    CFRunLoopRun();
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSTextFieldCell *cell = aCell;

        [cell setTextColor:[NSColor greenColor]];
   }


- (void)addRowData:(NSString*)device :(NSString*)process :(NSString*)status :(NSString*)log :(NSColor*) color;{
    
    [_arrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 device,@"device",
                                 process,@"process",
                                 status,@"status",
                                 log,@"log",
                                 color,@"deviceColor",
                                 color,@"processColor",
                                 color,@"statusColor",
                                 color,@"logColor",nil]];
    
    
    NSInteger numberOfRows = [_logTable numberOfRows];
    
    
    if(numberOfRows > 0)
    {
        [_logTable scrollRowToVisible:numberOfRows - 1];
        
      
                
    }
    
}

- (IBAction)ClearButton:(NSButton*)sender
{
    [[self.arrayController mutableArrayValueForKey:@"content"] removeAllObjects];
}



@end

static int find_space_offsets(const char *buffer, size_t length, size_t *space_offsets_out)
{
    int o = 0;
    for (size_t i = 16; i < length; i++) {
        if (buffer[i] == ' ') {
            space_offsets_out[o++] = i;
            if (o == 3) {
                break;
            }
        }
    }
    return o;
}
 
 


static unsigned char should_print_message(const char *buffer, size_t length)
{
    if (length < 3) return 0; // don't want blank lines
    
    size_t space_offsets[3];
    find_space_offsets(buffer, length, space_offsets);
    
    // Check whether process name matches the one passed to -p option and filter if needed
    if (strlen(requiredProcessName)) {
        char processName[256];
        memset(processName, '\0', 256);
        memcpy(processName, buffer + space_offsets[0] + 1, space_offsets[1] - space_offsets[0]);
        for (int i=(int)strlen(processName); i!=0; i--)
            if (processName[i]=='[')
                processName[i]='\0';
        
        if (strcmp(processName, requiredProcessName)!=0)
            return 0;
    }
    
    // More filtering options can be added here and return 0 when they won't meed filter criteria
    
    return 1;
    
}
 




static void write_colored(int fd, const char *buffer, size_t length)
{
    
    NSString *device;
    NSString *process;
    NSString *status;
    NSString *log;
    NSColor *color = [NSColor blackColor];
    
    
    if (length < 16) {
       // write_fully(fd, buffer, length);
        log = [[NSString alloc] initWithBytes:buffer
                                       length:length encoding:NSUTF8StringEncoding];
       
        [sampleClass addRowData:@"" :@"":@"" :log :color];
        
        return;
    }
    size_t space_offsets[3];
    int o = find_space_offsets(buffer, length, space_offsets);
    
    if (o == 3) {
        
        
        
        // date and device name
        device = [[NSString alloc] initWithBytes:buffer
                                       length:space_offsets[0] encoding:NSUTF8StringEncoding];

        
        // process
        int pos = 0;
        for (int i = (int)space_offsets[0]; i < space_offsets[0]; i++) {
            if (buffer[i] == '[') {
                pos = i;
                break;
            }
        }
        
        if (pos && buffer[space_offsets[1]-1] == ']') {
            NSString* p1 = [[NSString alloc] initWithBytes:buffer+space_offsets[0]
                                               length:pos-space_offsets[0] encoding:NSUTF8StringEncoding];
            NSString* p2 = [[NSString alloc] initWithBytes:buffer+pos
                                                    length:space_offsets[1]-pos encoding:NSUTF8StringEncoding];
            
            process = [NSString stringWithFormat:@"%@%@", p1, p2];
            
            
            
        } else {
            process = [[NSString alloc] initWithBytes:buffer+space_offsets[0]
                                                    length:space_offsets[1]-space_offsets[0] encoding:NSUTF8StringEncoding];
        }
        
        
        
        
        // Log level
        size_t levelLength = space_offsets[2] - space_offsets[1];
        if (levelLength > 4) {
            if (levelLength == 9 && memcmp(buffer + space_offsets[1], " <Debug>:", 9) == 0){
                color = [NSColor blueColor];
            } else if (levelLength == 11 && memcmp(buffer + space_offsets[1], " <Warning>:", 11) == 0){
                color = [NSColor yellowColor];
            } else if (levelLength == 9 && memcmp(buffer + space_offsets[1], " <Error>:", 9) == 0){
                color = [NSColor redColor];
            } else if (levelLength == 10 && memcmp(buffer + space_offsets[1], " <Notice>:", 10) == 0) {
                color = [NSColor greenColor];
            } else {
                goto level_unformatted;
            }
            NSString* s1 = [[NSString alloc] initWithBytes:buffer+space_offsets[1]
                                                    length:2 encoding:NSUTF8StringEncoding];
            NSString* s2 = [[NSString alloc] initWithBytes:buffer+space_offsets[1]+2
                                                    length:levelLength-4 encoding:NSUTF8StringEncoding];

            NSString* s3 = [[NSString alloc] initWithBytes:buffer+space_offsets[1]+levelLength-2
                                                    length:1 encoding:NSUTF8StringEncoding];
            NSString* s4 = [[NSString alloc] initWithBytes:buffer+space_offsets[1]+levelLength-1
                                                    length:1 encoding:NSUTF8StringEncoding];
            
            status = [NSString stringWithFormat:@"%@%@%@%@", s1, s2, s3, s4];
            

        } else {

        level_unformatted:
            status = [[NSString alloc] initWithBytes:buffer+space_offsets[1]
                                           length:levelLength encoding:NSUTF8StringEncoding];
        }
        
        //Log
        log = [[NSString alloc] initWithBytes:buffer+space_offsets[2]
                                       length:length-space_offsets[2] encoding:NSUTF8StringEncoding];
    } else {
        log = [[NSString alloc] initWithBytes:buffer
                                       length:length encoding:NSUTF8StringEncoding];

    }
    
    
    [sampleClass addRowData:device:process:status :log :color];
}



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
        
        if (should_print_message(buffer, extentLength)) {
            write_colored(1, buffer, extentLength);
         }
        
        length -= extentLength;
        buffer += extentLength;
    }
}

static void DeviceNotificationCallback(am_device_notification_callback_info *info, void *unknown)
{
    struct am_device *device = info->dev;
    switch (info->msg) {
        case ADNCI_MSG_CONNECTED: {
            if (debug) {
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
            if (debug) {
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
