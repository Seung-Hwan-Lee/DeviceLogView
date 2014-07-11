//
//  LogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogData : NSObject

@property (strong) NSString *date;
@property (strong) NSString *device;
@property (strong) NSString *process;
@property (strong) NSString *logLevel;
@property (strong) NSString *log;
@property (strong) NSColor *textColor;

-(id)initWithDate:(NSString *)date Device:(NSString *)device Process:(NSString *)process LogLevel:(NSString *)logLevel Log:(NSString *)log;

@end
