//
//  AppDelegate.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AppDelegate.h"
#import "ILogFilterGUI.h"
#import "AnalyzeDevceLog.h"


@implementation AppDelegate
{
    ILogFilterGUI *_gui;
    NSArrayController *_logArrayController;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;

}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    _logArrayController = [[NSArrayController alloc] init];
    _processArrayController = [[NSArrayController alloc] init];
    _deviceArrayController = [[NSArrayController alloc] init];
    
    
    _gui = [[ILogFilterGUI alloc] initWithWindow:_window];
    [_gui LogArrayController:_logArrayController];
    
   
    AnalyzeDevceLog *test =[[AnalyzeDevceLog alloc] initWithLogDataArrayController:_logArrayController processArrayController:_processArrayController deviceArrayController:_deviceArrayController logFilter:nil];
    [test startLogging];
}

@end