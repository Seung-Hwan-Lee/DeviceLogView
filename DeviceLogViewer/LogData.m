//
//  LogData.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "LogData.h"


@implementation LogData


- (id)initWithLogDataInfo:(NSDictionary *)aDataInfo
{
    self = [super init];
    if (self) {
        
        _date = [aDataInfo objectForKey:@"date"];
        _device = [aDataInfo objectForKey:@"device"];
        _process = [aDataInfo objectForKey:@"process"];
        _log = [aDataInfo objectForKey:@"log"];

        NSString *logLevel = [aDataInfo objectForKey:@"loglevel"];
        if (logLevel)
        {
            if ([logLevel rangeOfString:@"Notice"].location != NSNotFound) {
                _logLevel = kLogLevelNotice;
                _textColor = [NSColor greenColor];
            } else if([logLevel rangeOfString:@"Debug"].location != NSNotFound) {
                _logLevel = kLogLevelDebug;
                _textColor = [NSColor blueColor];
            } else if([logLevel rangeOfString:@"Error"].location != NSNotFound) {
                _logLevel = kLogLevelError;
                _textColor = [NSColor redColor];
            } else if([logLevel rangeOfString:@"Warning"].location != NSNotFound) {
                _logLevel = kLogLevelWarning;
                _textColor = [NSColor yellowColor];
            } else {
                _logLevel = kLogLevelNormal;
                _textColor = [NSColor blackColor];
            }
        }
    }
    
    return self;
}


@end
