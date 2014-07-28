//
//  FileChangingNotifier.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "FileChangingNotifier.h"


@implementation FileChangingNotifier

+ (id) notifierWithCallback:(FSEventStreamCallback)newCallback path:(NSString *)newPath {
    
    return [[self alloc] initWithCallback:newCallback path:newPath];
    
}

- (id) initWithCallback:(FSEventStreamCallback)newCallback path:(NSString *)newPath {
    if((self = [super init])) {
        paths = [NSArray arrayWithObject:newPath];
        context.version = 0L;
        context.info = (__bridge void *)(newPath);
        context.retain = (CFAllocatorRetainCallBack)CFRetain;
        context.release = (CFAllocatorReleaseCallBack)CFRelease;
        context.copyDescription = (CFAllocatorCopyDescriptionCallBack)CFCopyDescription;
                
        stream = FSEventStreamCreate(kCFAllocatorDefault, newCallback, &context, (__bridge CFArrayRef)paths, kFSEventStreamEventIdSinceNow, /*latency*/ 1.0, kFSEventStreamCreateFlagUseCFTypes);
        if (!stream) {
            NSLog(@"Could not create event stream for path %@", newPath);
            return nil;
        }
        
        
        FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    return self;
}

- (void) stopNotification {
    [self stop];
    FSEventStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    CFRelease(stream);
}

- (void) start {
    FSEventStreamStart(stream);
}
- (void) stop {
    FSEventStreamStop(stream);
}




@end
