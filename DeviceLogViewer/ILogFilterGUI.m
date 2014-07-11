//
//  iLogFilterGUI.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 11..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "ILogFilterGUI.h"


@implementation ILogFilterGUI
{
    NSWindow *_window;
    NSTableView *_logTableView;
    NSArrayController *_logArrayController;
    NSArrayController *_deviceArrayController;
    NSArrayController *_processArrayController;
}


#pragma mark -


-(id)initWithWindow:(NSWindow *)aWindow
{
    self = [super init];
    if (self) {
        
        _window = aWindow;
    }
    
    [_window setDelegate:self];
   
    
    return self;
}

#pragma mark -

-(void)LogArrayController:(NSArrayController *)aLogArrayController
{
    _logArrayController = aLogArrayController;
     
     [self makeLogTable];
}


#pragma mark -

- (void)makeLogTable
{
    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, windowSize.width - 20, windowSize.height - 200)];
    _logTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, windowSize.width - 20, windowSize.height - 200)];
    // create columns for our table
    NSTableColumn *dateColumn = [[NSTableColumn alloc] initWithIdentifier:@"date"];
    NSTableColumn *deviceColumn = [[NSTableColumn alloc] initWithIdentifier:@"device"];
    NSTableColumn *processColumn = [[NSTableColumn alloc] initWithIdentifier:@"process"];
    NSTableColumn *logLevelColumn = [[NSTableColumn alloc] initWithIdentifier:@"logLevel"];
    NSTableColumn *logColumn = [[NSTableColumn alloc] initWithIdentifier:@"log"];
    
    [dateColumn.headerCell setTitle:@"Date"];
    [deviceColumn.headerCell setTitle:@"Device"];
    [processColumn.headerCell setTitle:@"Process"];
    [logLevelColumn.headerCell setTitle:@"LogLevel"];
    [logColumn.headerCell setTitle:@"Log"];
    
    [dateColumn setWidth:100];
    [deviceColumn setWidth:100];
    [processColumn setWidth:100];
    [logLevelColumn setWidth:100];
    [logColumn setWidth:198];
    
    
        
    [dateColumn bind:NSValueBinding toObject:_logArrayController.arrangedObjects withKeyPath:@"date" options:nil];
    
        
    // add column
    [_logTableView addTableColumn:dateColumn];
    [_logTableView addTableColumn:deviceColumn];
    [_logTableView addTableColumn:processColumn];
    [_logTableView addTableColumn:logLevelColumn];
    [_logTableView addTableColumn:logColumn];
    
    
    [_logTableView setDelegate:self ];
    [_logTableView setDataSource:self];
    [_logTableView reloadData];
    
    
    [tableContainer setDocumentView:_logTableView];
    [tableContainer setHasVerticalScroller:YES];
    
    [_window.contentView addSubview:tableContainer];
    
    
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [tableView numberOfRows];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return tableView;
}


#pragma mark -

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    //NSLog(@"resizing");
    [self resizingLogTable:frameSize];
    
    return frameSize;
}

#pragma mark -

- (void)resizingLogTable:(NSSize)frameSize
{
    frameSize.height-= 200;
    frameSize.width -= 20;
    
    [[_logTableView enclosingScrollView] setFrameSize: frameSize];
    [[_logTableView enclosingScrollView] setNeedsDisplay: YES];

}


@end
