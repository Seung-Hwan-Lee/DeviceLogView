//
//  AppDelegate.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "AppDelegate.h"
#import "ILogFilterGUI.h"


@implementation AppDelegate
{
    ILogFilterGUI *_gui;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _gui = [[ILogFilterGUI alloc] initWithWindow:_window];
   
}

@end