//
//  AppDelegate.h
//  DeviceLogView
//
//  Created by LINEPLUS on 2014. 7. 8..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    bool fixed;
}

- (bool) fixed;
- (void) setFixed: (bool)x;

- (void)addRowData:(NSString*)device :(NSString*)process :(NSString*)status :(NSString*)log :(NSColor*)color;
- (IBAction)ClearButton:(NSButton*)sender;


@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTableView *logTable;


@end
