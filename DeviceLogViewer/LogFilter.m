//
//  LogFilter.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "LogFilter.h"


@interface LogFilter()

//-(void)makeLogPredicate;

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
    }
    return self;
}



- (void) setNotice: (BOOL)x
{
    notice = x;
}

- (void) setError: (BOOL)x
{
    error = x;
}

- (void) setWarning: (BOOL)x
{
    warning = x;
}


- (void) setDebug: (BOOL)x
{
    debug = x;
}
- (void) setDevice: (NSString *)x
{
    device = x;
}

- (void) setProcess: (NSString *)x
{
    process = x;
}

- (void) setSentence: (NSString *)x
{
    sentence = x;
}

@end
