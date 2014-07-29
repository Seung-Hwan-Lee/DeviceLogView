//
//  FileChangingNotifier.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "FileWatch.h"


@implementation FileWatch
{
    __block dispatch_source_t _source;
    NSString *_path;
    NSFileHandle *_fileHandler;
}

- (void)startFileWatch:(NSString *)aPath targetQueue:(dispatch_queue_t)aQueue
{
        _path = aPath;
        int descriptor = open([aPath fileSystemRepresentation], O_RDONLY);
        if (descriptor < 0) {
            NSLog(@"failed file open");
        }
        
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_path];
        [_fileHandler seekToEndOfFile];
        
        unsigned long mask = DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE ;
        void (^eventHandler)(void);
        eventHandler = ^{
            unsigned long l = dispatch_source_get_data(_source);
            if (l & DISPATCH_VNODE_DELETE) {
                NSLog(@"delete file");
                dispatch_source_cancel(_source);
            }
            else {
                NSString *sendText = [[NSString alloc] initWithData:[_fileHandler readDataToEndOfFile] encoding:NSUTF8StringEncoding];

                const char* utf8String = [sendText UTF8String];
                size_t len = strlen(utf8String);
                if ([_delegate respondsToSelector:@selector(modifiedString:length:filePath:)]) {
                    [_delegate modifiedString:utf8String length:len filePath:_path];
                }
            }
        };
        
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, descriptor, mask, aQueue);
        dispatch_source_set_event_handler(_source, eventHandler);
        dispatch_source_set_cancel_handler(_source, ^{
            close(descriptor);
        });
        
        dispatch_resume(_source);
    
}



@end