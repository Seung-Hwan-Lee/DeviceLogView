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
    Boolean notice;
    Boolean error;
    Boolean warning;
    Boolean debug;
    NSString* process;
    NSString* device;
    NSString* sentence;
    NSPredicate* LogPredicate;
}

@property Boolean notice;
@property Boolean error;
@property Boolean warning;
@property Boolean debug;
@property NSString* process;
@property NSString* device;
@property NSString* sentence;


-(NSPredicate*)getLogPredicate; 

@end
