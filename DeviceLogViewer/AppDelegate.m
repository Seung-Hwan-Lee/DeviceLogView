//
//  AppDelegate.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AppDelegate.h"



@implementation AppDelegate
{
    LogDataStorage *_logDataStorage;
    ILogFilterGUI *_gui;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    _logDataStorage = [[LogDataStorage alloc] init];
    _logDataStorage.delegate = self;
    _gui = [[ILogFilterGUI alloc] initWithWindow:_window];
    [_gui makeLogTableWithLogArrayController:[_logDataStorage LogDataArrayController]];
    [_gui makeDeviceTableWithDeviceArrayController:[_logDataStorage DeviceArrayController]];
    [_gui makeProcessTable:[_logDataStorage ProcessArrayController]];
    _gui.delegate =self;
    
}

- (void)dataUpdate
{
    [_gui updateTable];
}

- (void)FileLoading
{
    // Read File Test
    [_logDataStorage fileOpen];
}

@end
