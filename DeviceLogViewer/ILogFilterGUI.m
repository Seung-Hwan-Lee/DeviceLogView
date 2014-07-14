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
    LogFilter *_logFilter;
    NSWindow *_window;
    NSTableView *_logTableView;
    NSTableView *_deviceTableView;
    NSTableView *_processTableView;
    NSButton *_fixedButton;
    NSButton *_debugButton, *_errorButton, *_warningButton, *_noticeButton;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;
    NSArrayController *_logArrayController;
    
    BOOL _fixed, _debug, _error, _warning, _notice;
}




#pragma mark - initialize

-(id)initWithWindow:(NSWindow *)aWindow
{
    self = [super init];
    if (self) {
        _window = aWindow;
        _logFilter = [[LogFilter alloc]init];
    }
    
    [_window setDelegate:self];
    [self CreateUI];
   
    
    return self;
}


#pragma mark - Update TableView


- (void)updateTable{
    
    NSInteger numberOfRows = [_logTableView numberOfRows];
    if(numberOfRows > 0 && !_fixed)
    {
        [_logTableView scrollRowToVisible:numberOfRows - 1];
    }
    
    //NSLog(@"%@", [_logFilter logPredicate]);
    _processArrayController.filterPredicate = [_logFilter processPredicate];
    _logArrayController.filterPredicate = [_logFilter logPredicate];

}


#pragma mark - make GUI

- (void)CreateUI{
    
    NSSize windowSize = _window.frame.size;
    
    _fixedButton = [[NSButton alloc] initWithFrame:NSMakeRect(330, windowSize.height - 90, 80, 50)];
    [_fixedButton setButtonType:NSSwitchButton];
    [_fixedButton setIdentifier:@"fixedButton"];
    [_fixedButton setTitle:@"Fixed"];
    
    
    [_fixedButton setTarget:self];
    [_fixedButton setAction:@selector(buttonClicked:)];
    
    
    _fixed = NO;
    
    [_window.contentView addSubview:_fixedButton];
    
    _debugButton = [[NSButton alloc] initWithFrame:NSMakeRect(430, windowSize.height - 90, 80, 50)];
    [_debugButton setButtonType:NSSwitchButton];
    [_debugButton setIdentifier:@"debugButton"];
    [_debugButton setTitle:@"Debug"];
    
    
    [_debugButton setTarget:self];
    [_debugButton setAction:@selector(buttonClicked:)];
    
    
    _debug = NO;
    
    [_window.contentView addSubview:_debugButton];
    
    _errorButton = [[NSButton alloc] initWithFrame:NSMakeRect(500, windowSize.height - 90, 80, 50)];
    [_errorButton setButtonType:NSSwitchButton];
    [_errorButton setIdentifier:@"errorButton"];
    [_errorButton setTitle:@"Error"];
    
    
    [_errorButton setTarget:self];
    [_errorButton setAction:@selector(buttonClicked:)];
    
    
    _error = NO;
    
    [_window.contentView addSubview:_errorButton];
    
    _warningButton = [[NSButton alloc] initWithFrame:NSMakeRect(430, windowSize.height - 140, 80, 50)];
    [_warningButton setButtonType:NSSwitchButton];
    [_warningButton setIdentifier:@"warningButton"];
    [_warningButton setTitle:@"Warning"];
    
    
    [_warningButton setTarget:self];
    [_warningButton setAction:@selector(buttonClicked:)];
    
    
    _warning = NO;
    
    [_window.contentView addSubview:_warningButton];
    
    _noticeButton = [[NSButton alloc] initWithFrame:NSMakeRect(500, windowSize.height - 140, 80, 50)];
    [_noticeButton setButtonType:NSSwitchButton];
    [_noticeButton setIdentifier:@"noticeButton"];
    [_noticeButton setTitle:@"Notice"];
    
    
    [_noticeButton setTarget:self];
    [_noticeButton setAction:@selector(buttonClicked:)];
    
    
    _notice = NO;
    
    [_window.contentView addSubview:_noticeButton];
    
    
}


- (void)makeLogTableWithLogArrayController:(NSArrayController *)aLogArrayController

{
    _logArrayController = aLogArrayController;
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




- (void)makeDeviceTableWithDeviceArrayController:(NSArrayController *)aDeviceArrayController
{
    _deviceArrayController = aDeviceArrayController;
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




- (void)makeProcessTable:(NSArrayController *)aProcessArrayController
{
    
    _processArrayController = aProcessArrayController;
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



#pragma mark - Table Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [tableView numberOfRows];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //NSLog(@"%@",[[tableColumn dataCellForRow:0] objectAtIndex:0]);
    
    return nil;
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    if([notification object] == _processTableView){
        NSInteger row = [_processTableView selectedRow];
        if(row == 0){
            [_logFilter setProcess:nil];
            
        } else {
            NSDictionary *processData = [[_processArrayController arrangedObjects] objectAtIndex:row];
            [_logFilter setDeviceID: [processData objectForKey:@"deviceID"]];
            [_logFilter setProcess: [processData objectForKey:@"process"]];
        }
    } else if([notification object] == _deviceTableView) {
        NSInteger row = [_deviceTableView selectedRow];
        if(row == 0){
            [_logFilter setProcess:nil];
            [_logFilter setDeviceID:nil];
            return;
        } else {
            NSDictionary *deviceData = [[_deviceArrayController arrangedObjects] objectAtIndex:row];
            [_logFilter setDeviceID: [deviceData objectForKey:@"deviceID"]];
         }
    }
    [self updateTable];
}

/*- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if([aTableColumn.identifier isEqualToString:@"log"])
    {
        NSLog(@"%@", aCell);
    }
}
*/

#pragma mark - Window Delegate

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    //NSLog(@"resizing");
    [self resizingLogTable:frameSize];
    [self resizingDeviceTable:frameSize];
    [self resizingProcessTable:frameSize];

    return frameSize;
}



#pragma mark - GUI resize function

- (void)resizingLogTable:(NSSize)frameSize
{
    NSSize frame = frameSize;
    frame.height-= 200;
    frame.width -= 20;
    
    [[_logTableView enclosingScrollView] setFrameSize: frame];
    [[_logTableView enclosingScrollView] setNeedsDisplay: YES];
    
    //[[_deviceTableView enclosingScrollView] setFrameSize: frameSize];
    //[[_deviceTableView enclosingScrollView] setNeedsDisplay: YES];

}

- (void)resizingDeviceTable:(NSSize)frameSize
{
    CGRect frame = _deviceTableView.frame;
    frame.origin.y = frameSize.height - 180;
    
    [[_deviceTableView enclosingScrollView] setFrame: frame];
    [[_deviceTableView enclosingScrollView] setNeedsDisplay: YES];
}

- (void)resizingProcessTable:(NSSize)frameSize
{
    CGRect frame = _processTableView.frame;
    frame.origin.y = frameSize.height - 180;
    
    [[_processTableView enclosingScrollView] setFrame: frame];
    [[_processTableView enclosingScrollView] setNeedsDisplay: YES];
}


#pragma mrak - Button Event Function

- (void)buttonClicked: (NSButton *)button {
    NSString *buttonIdentifier = [button identifier];
    
    if([buttonIdentifier isEqualToString:@"fixedButton"]){
        _fixed = !_fixed;
    }
}



@end
