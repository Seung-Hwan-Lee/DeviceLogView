//
//  LogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface LogData : NSManagedObject


@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *device;
@property (nonatomic, retain) NSString *process;
@property (nonatomic, retain) NSString *logLevel;
@property (nonatomic, retain) NSString *log;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, retain) NSString *deviceID;

@end
