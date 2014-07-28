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
#import "MYArrayController.h"

@protocol ILogFilterGUIDelegate;


@interface ILogFilterGUI : NSObject <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate, NSTextFieldDelegate, MYArrayControllerDelegate>


- (id)initWithWindow:(NSWindow *)aWindow;
- (void)makeLogTableWithLogArrayController:(MYArrayController *)aLogArrayController;
- (void)makeDeviceTableWithDeviceArrayController:(NSArrayController *)aDeviceArrayController;
- (void)makeProcessTable:(NSArrayController *)aProcessArrayController;
- (void)updateTable;
- (void)checkingCurrentLog;
- (void)moveNextCheckedLog;
- (void)movePrevCheckedLog;



@property id<ILogFilterGUIDelegate> delegate;


@end


@protocol ILogFilterGUIDelegate <NSObject>


- (void)fileLoading;
- (void)fileSaving:(BOOL)isSavingEveryLog;
- (void)changeWindowTitle;

@end
