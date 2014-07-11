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
    BOOL notice;
    BOOL error;
    BOOL warning;
    BOOL debug;
    NSString *process;
    NSString *device;
    NSString *sentence;
}


- (void) setNotice: (BOOL)x;
- (void) setError: (BOOL)x;
- (void) setWarning: (BOOL)x;
- (void) setDebug: (BOOL)x;
- (void) setDevice: (NSString *)x;
- (void) setProcess: (NSString *)x;
- (void) setSentence: (NSString *)x;


@end
