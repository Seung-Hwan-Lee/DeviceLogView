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
    //NSString* Format;
    LogPredicate = [NSPredicate predicateWithFormat:
                    @"logLevel contains %@ or logLevel contains %@ or logLevel contains %@ or logLevel contains %@ or log contain %@ or process contain %@ or device contain %@"
                    , notice?@"Notice":@""
                    , error?@"Error":@""
                    , warning?@"Warning":@""
                    , debug?@"Debug":@""
                    , sentence, process, device];
    
    
}

-(NSPredicate *)getLogPredicate
{
    return LogPredicate;
}


- (Boolean) notice
{
    return notice;
}
- (void) setNotice: (Boolean)x
{
    notice = x;
    [self makeLogPredicate];
}

- (Boolean) error
{
    return error;
}
- (void) setError: (Boolean)x
{
    error = x;
    [self makeLogPredicate];
}

- (Boolean) warning
{
    return warning;
}
- (void) setWarning: (Boolean)x
{
    warning = x;
    [self makeLogPredicate];
}

- (Boolean) debug
{
    return debug;
}
- (void) setDebug: (Boolean)x
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
