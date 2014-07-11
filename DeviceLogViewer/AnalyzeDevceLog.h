//
//  AnalyzeDevceLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ReadDeviceLog.h"
#import "LogData.h"
#import "LogFilter.h"


@interface AnalyzeDevceLog : ReadDeviceLog


-(id)initWithLogDataArrayController:(NSArrayController *)aLogDataArrayController
             processArrayController:(NSArrayController *)aProcessArrayController
              deviceArrayController:(NSArrayController *)aDeviceArrayController
                          logFilter:(LogFilter *)aLogFilter;


@end
