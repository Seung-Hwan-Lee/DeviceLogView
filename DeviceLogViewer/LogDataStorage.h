//
//  SaveLogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 17..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzeDeviceLog.h"

@protocol LogDataStorageDelegate;
@interface LogDataStorage : NSObject <AnalyzeDeviceLogDelegate>
@property id<LogDataStorageDelegate> delegate;
- (NSArrayController *) LogDataArrayController;
- (NSArrayController *) ProcessArrayController;
- (NSArrayController *) DeviceArrayController;
- (void)fileOpen;
@end

@protocol LogDataStorageDelegate <NSObject>
@required
- (void)dataUpdate;
@end
