//
//  iLogFilterGUI.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 11..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILogFilterGUI : NSObject <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>

-(id)initWithWindow:(NSWindow *)aWindow;
-(void)LogArrayController:(NSArrayController *)aLogArrayController;

@end
