//
//  ReadSimulatorLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "ReadSimulatorLog.h"

@implementation ReadSimulatorLog


-(void)startLogging
{
    NSArray *labraryDirectory  = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *simulatorForderPaths = [[labraryDirectory objectAtIndex:0] stringByAppendingString:@"/Logs/CoreSimulator/"];
    NSArray *simulatorFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:simulatorForderPaths error:nil];
    
    if (simulatorFolder.count == 0) {
        simulatorForderPaths = [[labraryDirectory objectAtIndex:0] stringByAppendingString:@"/Logs/iOS Simulator/"];
        simulatorFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:simulatorForderPaths error:nil];
    }
    
    //_fileHandler = [NSFileHandle fileHandleForReadingAtPath:_path];

    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(0, 0);
    
    
    for( int i = 0 ; i < simulatorFolder.count ; i++)
    {
        FileWatch *fileWatch = [[FileWatch alloc] init];
        [fileWatch setDelegate:self];
        [fileWatch startFileWatch:[NSString stringWithFormat:@"%@%@%@", simulatorForderPaths, [simulatorFolder objectAtIndex:i], @"/system.log"] targetQueue:backgroundQueue];
    }
}


- (void)modifiedString:(const char *)aBuffer length:(NSInteger)aLength filePath:(NSString *)aFilePath
{
    if([_delegate respondsToSelector:@selector(analizeWithLogBuffer:length:deviceID:source:)])
    {
        [_delegate analizeWithLogBuffer:aBuffer length:aLength deviceID:aFilePath source:2];
    }
}



@end
