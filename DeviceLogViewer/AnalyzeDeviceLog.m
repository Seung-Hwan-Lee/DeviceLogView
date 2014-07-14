//
//  AnalyzeDeviceLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AnalyzeDeviceLog.h"


@implementation AnalyzeDeviceLog
{
    NSArrayController *_logDataArrayController;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;
    NSMutableSet *_processSet;
    NSMutableSet *_deviceSet;
}


#pragma mark -


- (id)initWithLogDataArrayController:(NSArrayController *)aLogDataArrayController
             processArrayController:(NSArrayController *)aProcessArrayController
              deviceArrayController:(NSArrayController *)aDeviceArrayController
{
    self = [super init];
    if(self)
    {
        _logDataArrayController = aLogDataArrayController;
        _processArrayController = aProcessArrayController;
        _deviceArrayController = aDeviceArrayController;
        _processSet = [[NSMutableSet alloc] init];
        _deviceSet = [[NSMutableSet alloc] init];

    }
    return self;

}


#pragma mark -


- (void)addLogDataToArrayController:(LogData *)aLogData
{
    
    [_logDataArrayController addObject:aLogData];

    
}


- (void)addProcessNameToSet:(NSString *)aProcessName
{
    if(aProcessName) {
        [_processSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:aProcessName, @"process", nil]];
    }
    
    [_processArrayController setContent:_processSet];
    //NSLog(@"%d", (int)[arr count]);
    //NSLog(@"%@", _processSet);
}


-(void)addDeviceNameToSet:(NSString *)aDeviceName
{
    if(aDeviceName) {
        [_deviceSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:aDeviceName, @"device", nil]];
    }
    
    [_deviceArrayController setContent:_deviceSet];
}


//Overriding Method
//buffer: DeviceLog
- (void)analizeWithLogBuffer:(const char *)aBuffer length:(NSInteger)aLength
{
    NSString *date = nil;
    NSString *device = nil;
    NSString *process = nil;
    NSString *logLevel = nil;
    NSString *log = nil;
    
    //LogData *analizedLogData;
    
    if (aLength < 16 || aBuffer[15] == '=') {
        return;
    }
    size_t space_offsets[3];
    NSInteger o = [self findSpaceOffsetWithBuffer:aBuffer length:aLength spaceOffsetOut:space_offsets];
    
    if (o == 3) {
        
        
        // date and device name
        date = [[NSString alloc] initWithBytes:aBuffer
                                          length:16 encoding:NSUTF8StringEncoding];
        
        if( space_offsets[0] != 16)
            device = [[NSString alloc] initWithBytes:aBuffer + 16
                                        length:space_offsets[0] - 16 encoding:NSUTF8StringEncoding];
        
        //insert processName to Set
        [self addDeviceNameToSet:device];

        if (aBuffer[space_offsets[1]-1] == ']')
            process = [[NSString alloc] initWithBytes:aBuffer+space_offsets[0]
                                               length:space_offsets[1]-space_offsets[0] encoding:NSUTF8StringEncoding];
       
        
        // Log level
        size_t levelLength = space_offsets[2] - space_offsets[1];
        NSString* s = [[NSString alloc] initWithBytes:aBuffer+space_offsets[1]
                                               length:levelLength encoding:NSUTF8StringEncoding];
        
        logLevel = [NSString stringWithFormat:@"%@", s];
        
        
        //Log
        log = [[NSString alloc] initWithBytes:aBuffer+space_offsets[2]
                                       length:aLength-space_offsets[2] encoding:NSUTF8StringEncoding];
        
    } else {
        log = [[NSString alloc] initWithBytes:aBuffer
                                       length:aLength encoding:NSUTF8StringEncoding];
        
    }
    
    
    
    if (date != nil && device != nil && process != nil && logLevel != nil && log != nil){
        NSMutableDictionary *logDataInfo = [NSMutableDictionary dictionary];
        [logDataInfo setObject:date forKey:@"date"];
        [logDataInfo setObject:device forKey:@"device"];
        [logDataInfo setObject:process forKey:@"process"];
        [logDataInfo setObject:logLevel forKey:@"logLevel"];
        [logDataInfo setObject:log forKey:@"log"];
        [self addDeviceNameToSet:device];
        [self addProcessNameToSet:process];
        [self addLogDataToArrayController:[[LogData alloc] initWithLogDataInfo:logDataInfo]];
    }
    
    //analizedLogData = [[LogData alloc] initWithLogDataInfo:logDataInfo];
    
    
    
    [self.delegate ModifiedArrayControllerWithLogDataArrayController:_logDataArrayController processArrayController:_processArrayController deviceArrayController:_deviceArrayController];
    
    
}

#pragma mark -

- (NSInteger)findSpaceOffsetWithBuffer:(const char *)aBuffer length:(size_t)aLength spaceOffsetOut:(size_t *)aSpace_offsets_out;

{
    NSInteger o = 0;
    for (size_t i = 16; i < aLength; i++) {
        if (aBuffer[i] == ' ') {
            aSpace_offsets_out[o++] = i;
            if (o == 3) {
                break;
            }
        }
    }
    
    return o;
}


@end


