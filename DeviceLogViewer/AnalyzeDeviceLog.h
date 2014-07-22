//
//  AnalyzeDeviceLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ReadDeviceLog.h"
#import "ReadFileLog.h"
#import "LogData.h"
#import "LogFilter.h"


@protocol AnalyzeDeviceLogDelegate;


@interface AnalyzeDeviceLog:NSObject <ReadDeviceLogDelegate, ReadFileLogDelegate>


@property id<AnalyzeDeviceLogDelegate> delegate;


- (void)readLogFromDevice;
- (void)readLogFromFile;


@end


@protocol AnalyzeDeviceLogDelegate<NSObject>;


@required
- (void)analyzedLog:(NSDictionary *)aAnalyzedLog isDevice:(BOOL)isDevice;
- (void)deviceConnected;
- (void)deviceDisConnectedWithDeviceID:(NSString *)aDeviceID;


@end