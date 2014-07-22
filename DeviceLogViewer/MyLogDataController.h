//
//  MyLogDataController.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 21..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyLogDataController : NSArrayController

@property BOOL isUpdateTable;

- (void) updateArrayController;

@end
