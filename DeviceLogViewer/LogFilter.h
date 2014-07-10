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
{
    bool notice;
    bool error;
    bool warning;
    bool debug;
    NSString* process;
    NSString* device;
    NSString* sentence;
    NSPredicate* LogPredicate;
}

@property bool notice;
@property bool error;
@property bool warning;
@property bool debug;
@property NSString* process;
@property NSString* device;
@property NSString* sentence;


-(NSPredicate*)getLogPredicate; 

@end
