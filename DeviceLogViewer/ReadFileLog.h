//
//  ReadFileLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 17..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ReadFileLogDelegate;


@interface ReadFileLog : NSObject


-(void)readFile;


@property id<ReadFileLogDelegate> delegate;


@end


@protocol ReadFileLogDelegate <NSObject>


@required
- (void)analizeWithLogBuffer:(const char *)aBuffer length:(NSInteger)aLength deviceID:(NSString *)aDeviceID;


@end
