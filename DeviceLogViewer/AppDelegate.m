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

@synthesize logFilter;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    AnalyzeDevceLog* start = [[AnalyzeDevceLog alloc] initWithLogDataArray:_logArrayController ProcessArr:_processArrayController DeviceArr:_deviceArrayController LogFilter:logFilter];
    [start startLogging];
    
}

-(void) removeAllData
{
    
    [[_logArrayController content] removeAllObjects];
    [[_processArrayController content] removeAllObjects];
    [[_deviceArrayController content] removeAllObjects];
}

@end