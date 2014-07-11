//
//  LogData.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef NS_ENUM (NSUInteger, LogLevel) {
    kLogLevelNormal = 0,
    kLogLevelNotice,
    kLogLevelDebug,
    kLogLevelError,
    kLogLevelWarning
};


@interface LogData : NSObject


- (id)initWithLogDataInfo:(NSDictionary *)aDataInfo;


@end
