//
//  AnalyzeDevceLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "AnalyzeDevceLog.h"


@interface AnalyzeDevceLog()
{
    NSMutableSet *processSet;
    NSMutableSet *deviceSet;
}

-(int)findSpaceOffsetWithBuffer:(const char*)buffer AndLength:(size_t)length AndSpaceOffsetOut:(size_t *)space_offsets_out;
-(void)analizeWithLogBuffer:(const char *)buffer andSize:(NSInteger)length;
-(void) addLogDataToArr:(LogData *)logData;
-(void) addProcessNameToSet:(NSString *)processName;
-(void) addDeviceNameToSet:(NSString *)deviceName;



@end


@implementation AnalyzeDevceLog


-(id)initWithLogDataArray:(NSArrayController *)inLogDataArr
               ProcessArr:(NSArrayController *)inProcessArr DeviceArr:(NSArrayController *)inDeviceArr LogFilter:(LogFilter *)inLogFilter;
{
    self = [super init];
    if(self)
    {
        logDataArr = inLogDataArr;
        processArr = inProcessArr;
        deviceArr = inDeviceArr;
        logFilter = inLogFilter;
        processSet = [[NSMutableSet alloc] init];
        deviceSet = [[NSMutableSet alloc] init];
        //[processSet addObject:[NSDictionary dictionaryWithObjectsAndKeys: @" All Process",@"process",nil]];
        //[deviceSet addObject:[NSDictionary dictionaryWithObjectsAndKeys: @" All Device",@"device",nil]];
    }
    return self;

}


-(void) addLogDataToArr:(LogData *)logData
{
    [logDataArr addObject:logData];
   // NSLog(@"%d", (int)[[logDataArr arrangedObjects] count]);
}


-(void) addProcessNameToSet:(NSString *)processName
{
    if(processName != nil)
        [processSet addObject:[NSDictionary dictionaryWithObjectsAndKeys: processName,@"process",nil]];
    [processArr setContent:processSet];
    //NSLog(@"%d", (int)[arr count]);
    //NSLog(@"%@", processSet);
}


-(void) addDeviceNameToSet:(NSString *)deviceName
{
    if(deviceName != nil)
        [deviceSet addObject:[NSDictionary dictionaryWithObjectsAndKeys: deviceName,@"device",nil]];
    [deviceArr setContent:deviceSet];
    
    
}


//Overriding Method
//buffer: DeviceLog
-(void)analizeWithLogBuffer:(const char *)buffer andSize:(NSInteger)length{
    NSString *date;
    NSString *device;
    NSString *process;
    NSString *logLevel;
    NSString *log;
   
    
    LogData *analizedLogData;
    
    if (length < 16 || buffer[15] == '=') {
        return;
    }
    size_t space_offsets[3];
    int o = [self findSpaceOffsetWithBuffer:buffer AndLength:length AndSpaceOffsetOut:space_offsets];
    
    if (o == 3) {
        
        
        // date and device name
        date = [[NSString alloc] initWithBytes:buffer
                                          length:16 encoding:NSUTF8StringEncoding];
        
        if( space_offsets[0] != 16)
            device = [[NSString alloc] initWithBytes:buffer + 16
                                        length:space_offsets[0] - 16 encoding:NSUTF8StringEncoding];
        
        //insert processName to Set
        [self addDeviceNameToSet:device];

        
        
        process = [[NSString alloc] initWithBytes:buffer+space_offsets[0]
                                               length:space_offsets[1]-space_offsets[0] encoding:NSUTF8StringEncoding];
       
        
        // Log level
        size_t levelLength = space_offsets[2] - space_offsets[1];
        NSString* s = [[NSString alloc] initWithBytes:buffer+space_offsets[1]
                                               length:levelLength encoding:NSUTF8StringEncoding];
        
        logLevel = [NSString stringWithFormat:@"%@", s];
        
        
        //Log
        log = [[NSString alloc] initWithBytes:buffer+space_offsets[2]
                                       length:length-space_offsets[2] encoding:NSUTF8StringEncoding];
        
    } else {
        log = [[NSString alloc] initWithBytes:buffer
                                       length:length encoding:NSUTF8StringEncoding];
        
    }
    
    analizedLogData = [[LogData alloc]initWithDate:date Device:device Process:process LogLevel:logLevel Log:log];
    
    
    [self addDeviceNameToSet:device];
    [self addProcessNameToSet:process];
    [self addLogDataToArr:analizedLogData];
    
}

-(int)findSpaceOffsetWithBuffer:(const char *)buffer AndLength:(size_t)length AndSpaceOffsetOut:(size_t*)space_offsets_out;

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


@end


