//
//  AnalyzeDeviceLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ReadDeviceLog.h"
#import "LogData.h"
#import "LogFilter.h"

@protocol AnalyzeDeviceLogDelegate;

@interface AnalyzeDeviceLog:NSObject <ReadDeviceLogDelegate>

@property id<AnalyzeDeviceLogDelegate> delegate;

- (id)initWithLogDataArrayController:(NSArrayController *)aLogDataArrayController
             processArrayController:(NSArrayController *)aProcessArrayController
              deviceArrayController:(NSArrayController *)aDeviceArrayController;

- (void)startLogging;

@end


@protocol AnalyzeDeviceLogDelegate<NSObject>;
@required

-(void) ModifiedCallBack;
@end