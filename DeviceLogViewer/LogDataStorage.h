//
//  SaveLogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 17..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AnalyzeDeviceLog.h"
#import "MyLogDataController.h"


@protocol LogDataStorageDelegate;


@interface LogDataStorage : NSObject <AnalyzeDeviceLogDelegate>


@property id<LogDataStorageDelegate> delegate;


@property MyLogDataController *logDataArrayController;
@property MyLogDataController *processArrayController;
@property MyLogDataController *deviceArrayController;


- (void)fileOpen;
- (void)saveFile:(BOOL)isSavingEveryLog;


@end


@protocol LogDataStorageDelegate <NSObject>


@required
- (void)dataUpdate;


@end
