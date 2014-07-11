//
//  LogFilter.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "LogFilter.h"


@implementation LogFilter
{
    BOOL _notice;
    BOOL _error;
    BOOL _warning;
    BOOL _debug;
    NSString *_process;
    NSString *_device;
    NSString *_sentence;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if(self) {
        _notice = TRUE;
        _error = TRUE;
        _warning = TRUE;
        _debug = TRUE;
    }
    
    return self;
}


#pragma mark -


- (void)setNotice:(BOOL)aNotice
{
    _notice = aNotice;
}

- (void)setError:(BOOL)aError
{
    _error = aError;
}

- (void)setWarning:(BOOL)aWarning
{
    _warning = aWarning;
}

- (void)setDebug:(BOOL)aDebug
{
    _debug = aDebug;
}

- (void)setDevice:(NSString *)aDevice
{
    _device = aDevice;
}

- (void)setProcess:(NSString *)aProcess
{
    _process = aProcess;
}

- (void)setSentence:(NSString *)aSentence
{
    _sentence = aSentence;
}


@end
