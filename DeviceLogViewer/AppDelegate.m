//
//  AppDelegate.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AppDelegate.h"
#import "ILogFilterGUI.h"
#import "AnalyzeDeviceLog.h"


@implementation AppDelegate
{
    ILogFilterGUI *_gui;
    NSArrayController *_logArrayController;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;

}



#pragma mark - 

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    _logArrayController = [[NSArrayController alloc] init];
    _processArrayController = [[NSArrayController alloc] init];
    _deviceArrayController = [[NSArrayController alloc] init];
    
    
    _gui = [[ILogFilterGUI alloc] initWithWindow:_window];
    [_gui makeLogTableWithLogArrayController:_logArrayController];
    [_gui makeDeviceTableWithDeviceArrayController:_deviceArrayController];
    [_gui makeProcessTable:_processArrayController];
    
   
    AnalyzeDeviceLog *test =[[AnalyzeDeviceLog alloc] initWithLogDataArrayController:_logArrayController processArrayController:_processArrayController deviceArrayController:_deviceArrayController];
    
    test.delegate = self;
    
    [test startLogging];
    
}



#pragma mark -

-(void) ModifiedArrayControllerWithLogDataArrayController:(NSArrayController *)aLogDataArrayController
                                   processArrayController:(NSArrayController *)aProcessArrayController
                                    deviceArrayController:(NSArrayController *)aDeviceArrayController
{
    //NSLog(@"%@", _logArrayController.arrangedObjects);
    
}




@end