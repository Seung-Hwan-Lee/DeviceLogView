//
//  FileChangingNotifier.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileChangingNotifier : NSObject{
    
    NSArray *paths;
    FSEventStreamRef stream;
    struct FSEventStreamContext context;
    
}


+ (id) notifierWithCallback:(FSEventStreamCallback)newCallback path:(NSString *)newPath;
- (id) initWithCallback:(FSEventStreamCallback)newCallback path:(NSString *)newPath;

- (void) start;
- (void) stop;


@end
