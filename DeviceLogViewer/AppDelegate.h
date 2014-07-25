//
//  AppDelegate.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ILogFilterGUI.h"
#import "LogDataStorage.h"
#import "ReadSimulatorLog.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, LogDataStorageDelegate, ILogFilterGUIDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
