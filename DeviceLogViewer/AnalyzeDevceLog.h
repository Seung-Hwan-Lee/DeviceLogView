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
{
    NSArrayController *logDataArr;
    NSArrayController *processArr;
    NSArrayController *deviceArr;
    LogFilter *logFilter;
}

-(id)initWithLogDataArray:(NSArrayController *)inLogDataArr
               ProcessArr:(NSArrayController *)inProcessArr DeviceArr:(NSArrayController *)inDeviceArr LogFilter:(LogFilter *)inLogFilter;

@end
