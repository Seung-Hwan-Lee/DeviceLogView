//
//  ReadDeviceLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>
#include "MobileDevice.h"
#include <stdio.h>
#include <unistd.h>

#warning comment
// 각 구문은 들여쓰기를 하셔서 보기 편하게.
@protocol ReadDeviceLogDelegate;


@interface ReadDeviceLog : NSObject


@property id<ReadDeviceLogDelegate> delegate;


-(void)startLogging;


@end


@protocol ReadDeviceLogDelegate <NSObject>


@required
- (void)analizeWithLogBuffer:(const char *)aBuffer length:(NSInteger)aLength deviceID:(NSString *)aDeviceID;
- (void)deviceConnected;
- (void)deviceDisConnectedWithDeviceID:(NSString *)aDeviceID;


@end
