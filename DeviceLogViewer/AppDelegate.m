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
    [_gui makeLogTableWithLogArrayController:[_logDataStorage logDataArrayController]];
    [_gui makeDeviceTableWithDeviceArrayController:[_logDataStorage deviceArrayController]];
    [_gui makeProcessTable:[_logDataStorage processArrayController]];
    _gui.delegate =self;
    [_window setTitle:@"ILogViewer"];
    
}



# pragma mark - ILogFilterGUI delegate


- (void)dataUpdate
{
    [_gui updateTable];
}

- (void)fileLoading
{
    // Read File Test
    [_logDataStorage fileOpen];
}

- (void)fileSaving:(NSArray *)aLogData
{
    // Read File Test
    [_logDataStorage saveFile:aLogData];
}

- (void)changeWindowTitle
{
    [_window setTitle:[_logDataStorage currentFilePath]];
}


# pragma mark - Key Event

- (IBAction)checkingLog:(id)sender {
    [_gui checkingCurrentLog];
}
- (IBAction)moveNext:(id)sender {
    [_gui moveNextCheckedLog];
}
- (IBAction)movePrev:(id)sender {
    [_gui movePrevCheckedLog];
}




@end
