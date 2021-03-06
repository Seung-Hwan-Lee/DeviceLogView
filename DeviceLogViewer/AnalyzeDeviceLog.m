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
    ReadDeviceLog *_readDeviceLog;
    ReadFileLog *_readFileLog;
    ReadSimulatorLog *_readSimulatorLog;
}


#pragma mark -

- (id)init
{
    self = [super init];
    if(self)
    {
        _readDeviceLog = [[ReadDeviceLog alloc] init];
        _readDeviceLog.delegate = self;
        _readFileLog = [[ReadFileLog alloc] init];
        _readFileLog.delegate = self;
        _readSimulatorLog = [[ReadSimulatorLog alloc] init];
        _readSimulatorLog.delegate = self;
    }
    return self;

}

- (void)readLogFromDevice
{
    [_readDeviceLog startLogging];
}

- (void)readLogFromConsoleFile
{
    [_readFileLog readConsoleLogFile];
}

- (void)readLogFromDeviceFile
{
    [_readFileLog readDeviceLogFile];
}

- (void)readLogFromSimulator
{
    [_readSimulatorLog startLogging];
}



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


#pragma mark - ReadDeviceLog, ReadFileLog Delegate


- (void)analizeWithLogBuffer:(const char *)aBuffer length:(NSInteger)aLength deviceID:(NSString *)aDeviceID source:(NSInteger)aSource
{
    NSString *date = nil;
    NSString *device = nil;
    NSString *process = nil;
    NSString *logLevel = nil;
    NSString *log = nil;
    
    if( aSource != 3)
    {
        if (aLength < 16 || aBuffer[15] == '=') {
            return;
        }
        size_t space_offsets[3];
        NSInteger o = [self findSpaceOffsetWithBuffer:aBuffer length:aLength spaceOffsetOut:space_offsets];
        
        if (o == 3) {
            // date and device name
            date = [[NSString alloc] initWithBytes:aBuffer length:16 encoding:NSUTF8StringEncoding];
            
            if( space_offsets[0] != 16) {
                device = [[NSString alloc] initWithBytes:aBuffer + 16 length:space_offsets[0] - 16 encoding:NSUTF8StringEncoding];
            }
            if (aBuffer[space_offsets[1]-1] == ']') {
                process = [[NSString alloc] initWithBytes:aBuffer+space_offsets[0]
                                                   length:space_offsets[1]-space_offsets[0] encoding:NSUTF8StringEncoding];
            }
            // Log level
            size_t levelLength = space_offsets[2] - space_offsets[1];
            NSString* s = [[NSString alloc] initWithBytes:aBuffer+space_offsets[1] length:levelLength encoding:NSUTF8StringEncoding];
            logLevel = [NSString stringWithFormat:@"%@", s];
            
            //Log
            log = [[NSString alloc] initWithBytes:aBuffer+space_offsets[2]
                                           length:aLength-space_offsets[2] encoding:NSUTF8StringEncoding];
        } else {
            log = [[NSString alloc] initWithBytes:aBuffer
                                           length:aLength encoding:NSUTF8StringEncoding];
        }
    
    }
    else
    {
        if (aLength < 24 || aBuffer[15] == '=') {
            return;
        }
        // date and device name
        date = [[NSString alloc] initWithBytes:aBuffer length:24 encoding:NSUTF8StringEncoding];
        device = @"device ";
        process = @" process";
        logLevel = @" <Notice>:";
        log = [[NSString alloc] initWithBytes:aBuffer+24
                                       length:aLength - 24 encoding:NSUTF8StringEncoding];
        
    }
    
    
    
    if (date != nil && device != nil && process != nil && logLevel != nil && log != nil){
        NSMutableDictionary *logDataInfo = [NSMutableDictionary dictionary];
        [logDataInfo setObject:date forKey:@"date"];
        [logDataInfo setObject:device forKey:@"device"];
        [logDataInfo setObject:process forKey:@"process"];
        [logDataInfo setObject:logLevel forKey:@"logLevel"];
        [logDataInfo setObject:log forKey:@"log"];
        [logDataInfo setObject:aDeviceID forKey:@"deviceID"];
        
        LogData *logData = [[LogData alloc] initWithLogDataInfo:logDataInfo];
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           
                           if ([_delegate respondsToSelector:@selector(analyzedLog:source:)]) {
                               [self.delegate analyzedLog:logData source:aSource];
                           }
                       });
        
        
    }
}

- (void)deviceConnected
{
    if ([_delegate respondsToSelector:@selector(deviceConnected)]) {
        [_delegate deviceConnected];
    }
}

- (void)deviceDisConnectedWithDeviceID:(NSString *)aDeviceID
{
    if ([_delegate respondsToSelector:@selector(deviceDisConnectedWithDeviceID:)]) {
        [_delegate deviceDisConnectedWithDeviceID:aDeviceID];
    }
}

@end


