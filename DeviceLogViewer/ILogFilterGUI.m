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
    NSTableView *_deviceTableView;
    NSTableView *_processTableView;
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

- (void)makeLogTableWithLogArrayController:(NSArrayController *)aLogArrayController

{
    NSSize windowSize = _window.frame.size;
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, windowSize.width - 20, windowSize.height - 200)];
    _logTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, windowSize.width - 20, windowSize.height - 200)];
    [_logTableView setIdentifier:@"LogTable"];
   
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
    [logColumn setWidth:windowSize.width];
    
    

    
    [dateColumn bind:NSValueBinding toObject:aLogArrayController
       withKeyPath:@"arrangedObjects.date" options:nil];
    [dateColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [deviceColumn bind:NSValueBinding toObject:aLogArrayController
         withKeyPath:@"arrangedObjects.device" options:nil];
    [deviceColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];

    [processColumn bind:NSValueBinding toObject:aLogArrayController
            withKeyPath:@"arrangedObjects.process" options:nil];
    [processColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [logLevelColumn bind:NSValueBinding toObject:aLogArrayController
         withKeyPath:@"arrangedObjects.logLevel" options:nil];
    [logLevelColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [logColumn bind:NSValueBinding toObject:aLogArrayController
         withKeyPath:@"arrangedObjects.log" options:nil];
    [logColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];

    
    
        
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





#pragma mark -

- (void)makeDeviceTableWithDeviceArrayController:(NSArrayController *)aDeviceArrayController
{
    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 180, 120, 150)];
    _deviceTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 180, 120, 150)];
    [_deviceTableView setIdentifier:@"deviceSet"];
    [_deviceTableView setHeaderView: nil];
    
    
    NSTableColumn *deviceColumn = [[NSTableColumn alloc] initWithIdentifier:@"device"];
    [deviceColumn setWidth:100];
    [deviceColumn bind:NSValueBinding toObject:aDeviceArrayController
         withKeyPath:@"arrangedObjects.device" options:nil];
    
    
    // add column
    [_deviceTableView addTableColumn:deviceColumn];
    [_deviceTableView setDelegate:self ];
    [_deviceTableView setDataSource:self];
    [_deviceTableView reloadData];
    
    
    [tableContainer setDocumentView:_deviceTableView];
    [tableContainer setHasVerticalScroller:YES];
    
    [_window.contentView addSubview:tableContainer];
    
    
}





#pragma mark -

- (void)makeProcessTable:(NSArrayController *)aProcessArrayController
{
    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(150, windowSize.height - 180, 150, 150)];
    _processTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(150, windowSize.height - 180, 150, 150)];
    [_processTableView setIdentifier:@"processSet"];
    [_processTableView setHeaderView: nil];
    
    
    NSTableColumn *processColumn = [[NSTableColumn alloc] initWithIdentifier:@"process"];
    [processColumn setWidth:150];
    [processColumn bind:NSValueBinding toObject:aProcessArrayController
           withKeyPath:@"arrangedObjects.process" options:nil];
    
    
    // add column
    [_processTableView addTableColumn:processColumn];
    [_processTableView setDelegate:self ];
    [_processTableView setDataSource:self];
    [_processTableView reloadData];
    
    
    [tableContainer setDocumentView:_processTableView];
    [tableContainer setHasVerticalScroller:YES];
    
    [_window.contentView addSubview:tableContainer];
    
    
}



#pragma mark -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [tableView numberOfRows];
}




#pragma mark -

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //NSLog(@"%@",[[tableColumn dataCellForRow:0] objectAtIndex:0]);
    return nil;
}




#pragma mark -

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    //NSLog(@"resizing");
    [self resizingLogTable:frameSize];
    [self resizingDeviceTable:frameSize];
    [self resizingProcessTable:frameSize];

    return frameSize;
}



#pragma mark -

- (void)resizingLogTable:(NSSize)frameSize
{
    frameSize.height-= 200;
    frameSize.width -= 20;
    
    [[_logTableView enclosingScrollView] setFrameSize: frameSize];
    [[_logTableView enclosingScrollView] setNeedsDisplay: YES];
    
    //[[_deviceTableView enclosingScrollView] setFrameSize: frameSize];
    //[[_deviceTableView enclosingScrollView] setNeedsDisplay: YES];

}



#pragma mark -

- (void)resizingDeviceTable:(NSSize)frameSize
{
    CGRect frame = _deviceTableView.frame;
    frame.origin.y = frameSize.height - 180;
    
    [[_deviceTableView enclosingScrollView] setFrame: frame];
    [[_deviceTableView enclosingScrollView] setNeedsDisplay: YES];
}

#pragma mark -

- (void)resizingProcessTable:(NSSize)frameSize
{
    CGRect frame = _processTableView.frame;
    frame.origin.y = frameSize.height - 180;
    
    [[_processTableView enclosingScrollView] setFrame: frame];
    [[_processTableView enclosingScrollView] setNeedsDisplay: YES];
}




@end
