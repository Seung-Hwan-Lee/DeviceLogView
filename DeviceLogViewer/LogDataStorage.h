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


#warning comment
// 메소드 이름은 소문자로
// 그리고 property 로 생성하는게 더 나을듯.
@property NSArrayController *logDataArrayController;
@property NSArrayController *processArrayController;
@property NSArrayController *deviceArrayController;


- (void)fileOpen;


@end


@protocol LogDataStorageDelegate <NSObject>


@required
- (void)dataUpdate;


@end
