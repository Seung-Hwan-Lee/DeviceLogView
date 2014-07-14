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

@interface AnalyzeDeviceLog : ReadDeviceLog

@property id<AnalyzeDeviceLogDelegate> delegate;

-(id)initWithLogDataArrayController:(NSArrayController *)aLogDataArrayController
             processArrayController:(NSArrayController *)aProcessArrayController
              deviceArrayController:(NSArrayController *)aDeviceArrayController;

@end

@protocol AnalyzeDeviceLogDelegate<NSObject>;

@required

-(void) ModifiedArrayControllerWithLogDataArrayController:(NSArrayController *)aLogDataArrayController
                                   processArrayController:(NSArrayController *)aProcessArrayController
                                    deviceArrayController:(NSArrayController *)aDeviceArrayController;


@end