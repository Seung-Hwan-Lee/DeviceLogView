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
#import "MyLogDataController.h"


@protocol ILogFilterGUIDelegate;


@interface ILogFilterGUI : NSObject <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate, NSTextFieldDelegate>


- (id)initWithWindow:(NSWindow *)aWindow;
- (void)makeLogTableWithLogArrayController:(MyLogDataController *)aLogArrayController;
- (void)makeDeviceTableWithDeviceArrayController:(MyLogDataController *)aDeviceArrayController;
- (void)makeProcessTable:(MyLogDataController *)aProcessArrayController;
- (void)updateTable;


@property id<ILogFilterGUIDelegate> delegate;


@end


@protocol ILogFilterGUIDelegate <NSObject>


- (void)fileLoading;
- (void)fileSaving:(BOOL)isSavingEveryLog;

@end
