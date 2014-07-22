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
        _logLevel = [aDataInfo objectForKey:@"logLevel"];
        _deviceID = [aDataInfo objectForKey:@"deviceID"];
        

        if (_logLevel)
        {
            if ([_logLevel rangeOfString:@"Notice"].location != NSNotFound) {
                _textColor = [NSColor colorWithRed:(float)0/255 green:(float)204/255 blue:(float)0/255 alpha:1.0f];
            } else if([_logLevel rangeOfString:@"Debug"].location != NSNotFound || [_logLevel rangeOfString:@"Info"].location != NSNotFound) {
                _textColor = [NSColor colorWithRed:(float)51/255 green:(float)51/255 blue:(float)204/255 alpha:1.0f];
            } else if([_logLevel rangeOfString:@"Warning"].location != NSNotFound) {
                _textColor = [NSColor colorWithRed:(float)204/255 green:(float)204/255 blue:(float)0/255 alpha:1.0f];
            } else {
                _textColor = [NSColor colorWithRed:(float)204/255 green:(float)0/255 blue:(float)0/255 alpha:1.0f];
            }
        }
    }
    
    return self;
}


@end
