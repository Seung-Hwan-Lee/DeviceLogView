//
//  SaveLogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 17..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AnalyzeDeviceLog.h"
#import "MYArrayController.h"


@protocol LogDataStorageDelegate;


@interface LogDataStorage : NSObject <AnalyzeDeviceLogDelegate>


@property id<LogDataStorageDelegate> delegate;


@property MYArrayController *logDataArrayController;
@property NSArrayController *processArrayController;
@property NSArrayController *deviceArrayController;


- (void)fileOpenWithType:(NSInteger) aFileType;
- (void)saveFile:(NSArray *)logData;
- (NSString *)currentFilePath;


@end


@protocol LogDataStorageDelegate <NSObject>


@required

- (void)dataUpdate;


@end
