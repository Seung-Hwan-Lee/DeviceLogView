//
//  iLogFilterGUI.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 11..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogFilter.h"
#import "LogData.h"

@interface ILogFilterGUI : NSObject <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>

- (id)initWithWindow:(NSWindow *)aWindow;
- (void)makeLogTableWithLogArrayController:(NSArrayController *)aLogArrayController;
- (void)makeDeviceTableWithDeviceArrayController:(NSArrayController *)aDeviceArrayController;
- (void)makeProcessTable:(NSArrayController *)aProcessArrayController;
- (void)updateTable;


@end
