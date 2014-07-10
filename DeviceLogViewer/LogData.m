//
//  LogData.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "LogData.h"

@implementation LogData

@synthesize date;
@synthesize device;
@synthesize process;
@synthesize logLevel;
@synthesize log;
@synthesize textColor;

-(id)initWithDate:(NSString*)inDate andDevice:(NSString*)inDevice andProcess:(NSString*)inProcess andLogLevel:(NSString*)inLogLevel andLog:(NSString*)inLog;
{

    self = [super init];
    if(self) {
        date = inDate;
        device = inDevice;
        process = inProcess;
        logLevel = inLogLevel;
        log = inLog;
    }
    
    if(nil != logLevel)
    {
        if([logLevel rangeOfString:@"Notice"].location != NSNotFound)
            textColor = [NSColor greenColor];
        else  if([logLevel rangeOfString:@"Debug"].location != NSNotFound)
            textColor = [NSColor blueColor];
        else if([logLevel rangeOfString:@"Error"].location != NSNotFound)
            textColor = [NSColor redColor];
        else  if([logLevel rangeOfString:@"Warning"].location != NSNotFound)
            textColor = [NSColor yellowColor];
        else
            textColor = [NSColor blackColor];
    }
    
    return self;
}



@end
