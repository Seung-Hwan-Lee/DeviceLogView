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
    // Insert code here to initialize your application
    
    AnalyzeDevceLog* start = [[AnalyzeDevceLog alloc] init];
    [start startLogging];
    
}

@end
