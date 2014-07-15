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
    NSTableView *_logLevelTableView;
    NSButton *_fixedButton;
    NSButton *_debugButton, *_errorButton, *_warningButton, *_noticeButton;
    NSButton *_clearButton;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;
    NSArrayController *_logArrayController;
    NSSearchField *_logSearchField;
    BOOL _fixed;
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
    
    _fixedButton = [[NSButton alloc] initWithFrame:NSMakeRect(340, windowSize.height - 90, 80, 25)];
    [_fixedButton setButtonType:NSSwitchButton];
    [_fixedButton setIdentifier:@"fixedButton"];
    [_fixedButton setTitle:@"Fixed"];
    [_fixedButton setTarget:self];
    [_fixedButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_fixedButton];
    _fixed = NO;
    
    
    _logSearchField = [[NSSearchField alloc] initWithFrame:NSMakeRect(600, windowSize.height - 90, 200, 50)];
    [_logSearchField setDelegate:self];
    [_window.contentView addSubview:_logSearchField];
    
    
    _clearButton = [[NSButton alloc] initWithFrame:NSMakeRect(330, windowSize.height - 130, 80, 25)];
    [_clearButton setIdentifier:@"clearButton"];
    [_clearButton setTitle:@"Clear"];
    [_clearButton setTarget:self];
    [_clearButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_clearButton];
    
    
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(450, windowSize.height - 180, 120, 150)];
    _logLevelTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(450, windowSize.height - 180, 120, 150)];
    [_logLevelTableView setIdentifier:@"logLevelTable"];
    [_logLevelTableView setHeaderView: nil];
    NSTableColumn *logLevelColumn = [[NSTableColumn alloc] initWithIdentifier:@"logLevel"];
    NSArrayController *logLevelArray = [[NSArrayController alloc] init];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Debug", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Notice", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Warning", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Error", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Critical", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Alert", @"logLevel", nil]];
    [logLevelArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Emergency", @"logLevel", nil]];
    [logLevelColumn setWidth:100];
    [logLevelColumn bind:NSValueBinding toObject:logLevelArray
           withKeyPath:@"arrangedObjects.logLevel" options:nil];
    [_logLevelTableView addTableColumn:logLevelColumn];
    [_logLevelTableView setDelegate:self ];
    [_logLevelTableView setDataSource:self];
    [_logLevelTableView reloadData];
    [tableContainer setDocumentView:_logLevelTableView];
    [tableContainer setHasVerticalScroller:YES];
    [_window.contentView addSubview:tableContainer];

    
   /* _debug = NO;
    
    [_window.contentView addSubview:_debugButton];
    
    _errorButton = [[NSButton alloc] initWithFrame:NSMakeRect(500, windowSize.height - 90, 80, 50)];
    [_errorButton setButtonType:NSSwitchButton];
    [_errorButton setIdentifier:@"errorButton"];
    [_errorButton setTitle:@"Error"];
    
    
    [_errorButton setTarget:self];
    [_errorButton setAction:@selector(buttonClicked:)];
    */
    
}


- (void)makeLogTableWithLogArrayController:(NSArrayController *)aLogArrayController

{
    _logArrayController = aLogArrayController;
    _logArrayController.selectsInsertedObjects = NO;
    
    
    
    
    NSSize windowSize = _window.frame.size;
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, windowSize.width - 20, windowSize.height - 200)];
    _logTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, windowSize.width - 20, windowSize.height - 200)];
    [_logTableView setIdentifier:@"LogTable"];
    
    NSTableColumn *dateColumn = [[NSTableColumn alloc] initWithIdentifier:@"date"];
    NSTableColumn *deviceColumn = [[NSTableColumn alloc] initWithIdentifier:@"device"];
    NSTableColumn *processColumn = [[NSTableColumn alloc] initWithIdentifier:@"process"];
    NSTableColumn *logLevelColumn = [[NSTableColumn alloc] initWithIdentifier:@"logLevel"];
    NSTableColumn *logColumn = [[NSTableColumn alloc] initWithIdentifier:@"log"];
    
    
    //[dateColumn setEditable:NO];
    //[deviceColumn setEditable:NO];
    //[processColumn setEditable:NO];
    //[logLevelColumn setEditable:NO];
    //[logColumn setEditable:NO];
    
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
    _deviceArrayController.selectsInsertedObjects = NO;
    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 180, 120, 150)];
    _deviceTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 180, 120, 150)];
    [_deviceTableView setIdentifier:@"deviceSet"];
    [_deviceTableView setHeaderView: nil];
    
    
    NSTableColumn *deviceColumn = [[NSTableColumn alloc] initWithIdentifier:@"device"];
    //[deviceColumn setEditable:NO];
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
    _processArrayController.selectsInsertedObjects = NO;

    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(150, windowSize.height - 180, 150, 150)];
    _processTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(150, windowSize.height - 180, 150, 150)];
    [_processTableView setIdentifier:@"processSet"];
    [_processTableView setHeaderView: nil];
    
    
    NSTableColumn *processColumn = [[NSTableColumn alloc] initWithIdentifier:@"process"];
    //[processColumn setEditable:NO];
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
    NSLog(@"call numberOfRowsInTableView");
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
    [self resizingLogLevelTable:frameSize];

    return frameSize;
}


#pragma mark - TextField Delegate


-(void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *textField = [obj object];
    NSString *text = [textField stringValue];
    if([text isEqualToString: @""]) {
        [_logFilter setSentence:nil];
    } else {
        [_logFilter setSentence:text];
    }
    [self updateTable];
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

- (void)resizingLogLevelTable:(NSSize)frameSize
{
    CGRect frame = _logLevelTableView.frame;
    frame.origin.y = frameSize.height - 180;
    
    [[_logLevelTableView enclosingScrollView] setFrame: frame];
    [[_logLevelTableView enclosingScrollView] setNeedsDisplay: YES];
}



#pragma mrak - Button Event Function

- (void)buttonClicked: (NSButton *)button {
    NSString *buttonIdentifier = [button identifier];
    
    if([buttonIdentifier isEqualToString:@"fixedButton"]){
        _fixed = !_fixed;
    }
    else if([buttonIdentifier isEqualToString:@"clearButton"])
    {
        [[_logArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
        [[_processArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
    }
}



@end
