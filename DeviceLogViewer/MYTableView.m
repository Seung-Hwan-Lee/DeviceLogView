//
//  MYTableView.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 31..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "MYTableView.h"

@implementation MYTableView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (NSMenu *)menuForEvent:(NSEvent *)event
{
    
    NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:mousePoint];
    
    NSIndexSet *selectedIndex = [self selectedRowIndexes];
    
    if(![selectedIndex containsIndex:row])
    {
        [self mouseDown:event];
    }
    
    return self.menu;
}
- (void)mouseDragged:(NSEvent *)theEvent
{
    NSLog(@"mouse drag");
}

@end
