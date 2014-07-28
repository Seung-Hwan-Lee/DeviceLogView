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
    

    FileChangingNotifier *test = [FileChangingNotifier notifierWithCallback:fsEventsCallback path:_cacheForderPaths];
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
    int i;
    
    // printf("Callback called\n");
    for (i=0; i<numEvents; i++) {
        /* flags are unsigned long, IDs are uint64_t */
        NSLog(@"Change %llu in %@, flags %u\n", eventIds[0], eventPaths, (unsigned int)eventFlags[0]);
    }
}