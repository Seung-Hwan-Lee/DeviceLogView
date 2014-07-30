//
//  LogFilter.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//
//  This class make NSPredicate Object for Array Filtering, using user's input value of GUI
//


#import <Foundation/Foundation.h>


@interface LogFilter : NSObject


@property NSString *process;
@property NSString *deviceID;
@property NSString *sentence;
@property NSString *deviceName;



- (BOOL *)logLevel;
- (NSPredicate *)processPredicate;
- (NSPredicate *)logPredicate;


@end
