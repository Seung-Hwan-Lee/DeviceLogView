//
//  AppDelegate.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogFilter.h"
#import "AnalyzeDeviceLog.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, AnalyzeDeviceLogDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
