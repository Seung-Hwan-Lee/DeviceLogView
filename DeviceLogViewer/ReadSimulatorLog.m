//
//  ReadSimulatorLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "ReadSimulatorLog.h"

@implementation ReadSimulatorLog

static void fsEventsCallback(ConstFSEventStreamRef streamRef,
                      void *info,
                      size_t numEvents,
                      void *eventPaths,
                      const FSEventStreamEventFlags eventFlags[],
                             const FSEventStreamEventId eventIds[]);


-(void)startLogging
{
    NSArray *documentsDirectory  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_cacheForderPaths = [[documentsDirectory objectAtIndex:0] stringByAppendingString:@"/MyDeviceLog/"];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY_MM_dd_HH"];
    NSString *fileName = [[outputFormatter stringFromDate:now] stringByAppendingString:@"_LogData.txt"];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", _cacheForderPaths, fileName];
    
    NSLog(@"%@",filePath);

    FileChangingNotifier *test = [FileChangingNotifier notifierWithCallback:fsEventsCallback path:filePath];
    [test start];
}

@end


static void fsEventsCallback(ConstFSEventStreamRef streamRef,
                             void *info,
                             size_t numEvents,
                             void *eventPaths,
                             const FSEventStreamEventFlags eventFlags[],
                             const FSEventStreamEventId eventIds[])
{
    NSLog(@"Simulator");
}