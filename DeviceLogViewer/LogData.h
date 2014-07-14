//
//  LogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface LogData : NSObject


@property NSString *date;
@property NSString *device;
@property NSString *process;
@property NSString *logLevel;
@property NSString *log;
@property NSColor *textColor;
@property NSString *deviceID;


- (id)initWithLogDataInfo:(NSDictionary *)aDataInfo;

@end
