//
//  AppDelegate.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogFilter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>


- (void)removeAllData;


@property (weak) IBOutlet NSArrayController *deviceArrayController;
@property (weak) IBOutlet NSArrayController *logArrayController;
@property (weak) IBOutlet NSArrayController *processArrayController;
@property (weak) IBOutlet NSTableView *deviceTableView;
@property (assign) IBOutlet NSWindow *window;
@property LogFilter* logFilter;

@end
