//
//  AppDelegate.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (weak) IBOutlet NSArrayController *logArrayController;

@property (weak) IBOutlet NSMutableSet *deviceSet;

@property (assign) IBOutlet NSWindow *window;

@end
