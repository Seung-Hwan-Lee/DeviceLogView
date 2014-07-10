//
//  AnalyzeDevceLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "AnalyzeDevceLog.h"


@interface AnalyzeDevceLog()

-(int)findSpaceOffsetWithBuffer:(const char*)buffer AndLength:(size_t)length AndSpaceOffsetOut:(size_t*)space_offsets_out;
-(void)analizeWithLogBuffer:(const char*)buffer andSize:(int)length;
-(void) addLogDataToArr:(LogData*)logData;
-(void) addProcessNameToSet:(NSString*)processName;
-(void) addDeviceNameToSet:(NSString*)deviceName;



@end


@implementation AnalyzeDevceLog

-(id)init
{
    self = [super init];
    if(self)
    {
        //logDataArr = [[NSArrayController alloc] init];
        processSet = [[NSMutableSet alloc] init];
        deviceSet = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void) setLogDataArr: (NSArrayController*)inLogDataArr
{
    logDataArr = inLogDataArr;
}
-(NSArrayController*) getLogDataArr
{
    return logDataArr;
}
-(NSMutableSet*) getProcessSet
{
    return processSet;
}
-(NSMutableSet*) getDeviceSet
{
    return deviceSet;
}


-(void) addLogDataToArr:(LogData*)logData
{
    [logDataArr addObject:logData];
   // NSLog(@"%d", (int)[[logDataArr arrangedObjects] count]);
}


-(void) addProcessNameToSet:(NSString*)processName
{
    [processSet addObject:processName];
    //NSArray* arr = [processSet allObjects];
    //NSLog(@"%d", (int)[arr count]);
    
}


-(void) addDeviceNameToSet:(NSString*)deviceName
{
    [deviceSet addObject:deviceName];
}

-(void) removeAllData
{
    [[logDataArr content] removeAllObjects];
    [processSet removeAllObjects];
    [deviceSet removeAllObjects];
}


//Overriding Method
//buffer: DeviceLog
-(void)analizeWithLogBuffer:(const char *)buffer andSize:(int)length{
    NSString *date;
    NSString *device;
    NSString *process;
    NSString *logLevel;
    NSString *log;
   
    
    LogData* analizedLogData;
    
    if (length < 16) {
        log = [[NSString alloc] initWithBytes:buffer
                                       length:length encoding:NSUTF8StringEncoding];
        
        //[sampleClass addRowData:@"" :@"":@"" :log :color];
        
        return;
    }
    size_t space_offsets[3];
    int o = [self findSpaceOffsetWithBuffer:buffer AndLength:length AndSpaceOffsetOut:space_offsets];
    
    if (o == 3) {
        
        
        // date and device name
        date = [[NSString alloc] initWithBytes:buffer
                                          length:16 encoding:NSUTF8StringEncoding];
        
        device = [[NSString alloc] initWithBytes:buffer + 16
                                        length:space_offsets[0] - 16 encoding:NSUTF8StringEncoding];
        
        //insert processName to Set
        [self addDeviceNameToSet:device];

        
        // process
        int pos = 0;
        for (int i = (int)space_offsets[0]; i < space_offsets[0]; i++) {
            if (buffer[i] == '[') {
                pos = i;
                break;
            }
        }
        
        /*if (pos && buffer[space_offsets[1]-1] == ']') {
            NSString* p1 = [[NSString alloc] initWithBytes:buffer+space_offsets[0]
                                                    length:pos-space_offsets[0] encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", p1);
            
            NSString* p2 = [[NSString alloc] initWithBytes:buffer+pos
                                                    length:space_offsets[1]-pos encoding:NSUTF8StringEncoding];
            NSLog(@"%@", p2);
            
            process = [NSString stringWithFormat:@"%@%@", p1, p2];
            
            
            
        } else {*/
        process = [[NSString alloc] initWithBytes:buffer+space_offsets[0]
                                               length:space_offsets[1]-space_offsets[0] encoding:NSUTF8StringEncoding];
       
        //}
        
        
        //insert processName to Set
        [self addProcessNameToSet:process];
        
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
    
    analizedLogData = [[LogData alloc]initWithDate:date andDevice:device andProcess:process andLogLevel:logLevel andLog:log];
    [self addLogDataToArr:analizedLogData];
    
}

-(int)findSpaceOffsetWithBuffer:(const char*)buffer AndLength:(size_t)length AndSpaceOffsetOut:(size_t*)space_offsets_out;

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


