//
//  LogData.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "LogData.h"

@implementation LogData

-(id)initWithDate:(NSString *)date Device:(NSString *)device Process:(NSString *)process LogLevel:(NSString *)logLevel Log:(NSString *)log;
{

    self = [super init];
    if(self) {
        _date = date;
        _device = device;
        _process = process;
        _logLevel = logLevel;
        _log = log;
    }
    
    if(nil != logLevel)
    {
        if([logLevel rangeOfString:@"Notice"].location != NSNotFound)
            _textColor = [NSColor greenColor];
        else  if([logLevel rangeOfString:@"Debug"].location != NSNotFound)
            _textColor = [NSColor blueColor];
        else if([logLevel rangeOfString:@"Error"].location != NSNotFound)
            _textColor = [NSColor redColor];
        else  if([logLevel rangeOfString:@"Warning"].location != NSNotFound)
            _textColor = [NSColor yellowColor];
        else
            _textColor = [NSColor blackColor];
    }
    
    return self;
}



@end
