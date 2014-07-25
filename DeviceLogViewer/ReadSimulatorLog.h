//
//  ReadSimulatorLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 25..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileChangingNotifier.h"

@protocol ReadSimulatorLogDelegate;



@interface ReadSimulatorLog : NSObject

@property id<ReadSimulatorLogDelegate> delegate;


- (void)startLogging;

@end




@protocol ReadSimulatorLogDelegate <NSObject>

@required

- (void)analizeWithLogBuffer:(const char *)aBuffer length:(NSInteger)aLength deviceID:(NSString *)aDeviceID isDevice:(BOOL)isDevice;

@end
