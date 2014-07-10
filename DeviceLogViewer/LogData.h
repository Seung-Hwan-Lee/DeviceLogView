//
//  LogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogData : NSObject
{
    NSString* date;
    NSString* device;
    NSString* process;
    NSString* logLevel;
    NSString* log;
    NSColor* textColor;
}

@property NSString* date;
@property NSString* device;
@property NSString* process;
@property NSString* logLevel;
@property NSString* log;
@property NSColor* textColor;

-(id)initWithDate:(NSString*)inDate andDevice:(NSString*)inDevice andProcess:(NSString*)inProcess andLogLevel:(NSString*)inLogLevel andLog:(NSString*)inLog;

@end
