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


@protocol ILogFilterGUIDelegate;


@interface ILogFilterGUI : NSObject <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate, NSTextFieldDelegate>


- (id)initWithWindow:(NSWindow *)aWindow;
- (void)makeLogTableWithLogArrayController:(NSArrayController *)aLogArrayController;
- (void)makeDeviceTableWithDeviceArrayController:(NSArrayController *)aDeviceArrayController;
- (void)makeProcessTable:(NSArrayController *)aProcessArrayController;
- (void)updateTable;


@property id<ILogFilterGUIDelegate> delegate;


@end


@protocol ILogFilterGUIDelegate <NSObject>

#warning comment
// 메소드 이름은 소문자로 시작.
- (void)fileLoading;


@end
