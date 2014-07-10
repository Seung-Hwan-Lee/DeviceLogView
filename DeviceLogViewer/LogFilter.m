//
//  LogFilter.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "LogFilter.h"


@interface LogFilter()

-(void)makeLogPredicate;

@end

@implementation LogFilter

-(id)init
{
    self = [super init];
    if(self) {
        notice = true;
        error = true;
        warning = true;
        debug = true;
        [self makeLogPredicate];
    }
    return self;
}

-(void)makeLogPredicate
{
    //make Predicate for Array filtering
    
    
    
}

-(NSPredicate *)getLogPredicate
{
    return LogPredicate;
}


- (bool) notice
{
    return notice;
}
- (void) setNotice: (bool)x
{
    notice = x;
    [self makeLogPredicate];
}

- (bool) error
{
    return error;
}
- (void) setError: (bool)x
{
    error = x;
    [self makeLogPredicate];
}

- (bool) warning
{
    return warning;
}
- (void) setWarning: (bool)x
{
    warning = x;
    [self makeLogPredicate];
}

- (bool) debug
{
    return debug;
}
- (void) setDebug: (bool)x
{
    debug = x;
    [self makeLogPredicate];
}

- (NSString*) device
{
    return device;
}
- (void) setDevice: (NSString*)x
{
    device = x;
    [self makeLogPredicate];
}

- (NSString*) process
{
    return process;
}
- (void) setProcess: (NSString*)x
{
    process = x;
    [self makeLogPredicate];
}

- (NSString*) sentence
{
    return sentence;
}
- (void) setSentence: (NSString*)x
{
    sentence = x;
    [self makeLogPredicate];
}

@end
