//
//  MYArrayController.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 28..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogFilter.h"
#import "LogData.h"


@protocol MYArrayControllerDelegate;

@interface MYArrayController : NSArrayController


@property id<MYArrayControllerDelegate> delegate;

- (void)setLogFilter:(LogFilter *)aLogFilter;
- (void)updatePredicate;
- (void)removeAllLog;



@end



@protocol MYArrayControllerDelegate <NSObject>

@required
- (void)beforChangingData;
- (void)afterChangingData;

@end
