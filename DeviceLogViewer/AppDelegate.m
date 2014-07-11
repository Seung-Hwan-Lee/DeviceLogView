//
//  AppDelegate.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AppDelegate.h"
#import "AnalyzeDevceLog.h"


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    AnalyzeDevceLog *analyzeDeviceLog = [[AnalyzeDevceLog alloc] initWithLogDataArrayController:_logArrayController
                                                                         processArrayController:_processArrayController
                                                                          deviceArrayController:_deviceArrayController
                                                                                      logFilter:_logFilter];
    [analyzeDeviceLog startLogging];
    
}


- (void)removeAllData
{
    [[_logArrayController content] removeAllObjects];
    [[_processArrayController content] removeAllObjects];
    [[_deviceArrayController content] removeAllObjects];
}


@end