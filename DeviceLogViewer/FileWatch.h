//
//  FileChangingNotifier.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol FileWatchDeleate;



@interface FileWatch:NSObject

@property id<FileWatchDeleate> delegate;
- (void)startFileWatch:(NSString *)aPath targetQueue:(dispatch_queue_t)aQueue;


@end



@protocol FileWatchDeleate <NSObject>

@required

- (void)modifiedString:(const char *)aBuffer length:(NSInteger)aLength filePath:(NSString *)aFilePath;

@end
