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
    NSTableColumn *_deviceColumn;
    NSTableColumn *_dateColumn;
    NSTableColumn *_processColumn;
    NSTableColumn *_logLevelColumn;
    NSTableColumn *_logColumn;
    NSButton *_clearButton;
    NSButton *_loadfileButton;
    NSButton *_saveallButton;
    NSButton *_savefilteredButton;
    MyLogDataController *_processArrayController;
    MyLogDataController *_deviceArrayController;
    MyLogDataController *_logArrayController;
    NSArray *_logLevelArray;
    NSSearchField *_logSearchField;
    NSSearchField *_loghighlightField;
    NSTextField *_deviceName, *_processName, *_logLevel, *_searchLog, *_highlightLog;
    
    NSString *_highlightString;
    BOOL _fixed;
}


#pragma mark - initialize


-(id)initWithWindow:(NSWindow *)aWindow
{
    self = [super init];
    if (self) {
        _window = aWindow;
        _logFilter = [[LogFilter alloc]init];
        _highlightString = nil;
        _fixed = NO;
    }
    
    [_window setDelegate:self];
    [self createGUI];
   
    
    return self;
}


#pragma mark - Update TableView


- (void)updateTable{
    
    
    
    NSInteger numberOfRows = [_logTableView numberOfRows];
    if (numberOfRows > 0 && !_fixed)
    {
        [_logTableView scrollRowToVisible:numberOfRows - 1];
    }
    
    _processArrayController.filterPredicate = [_logFilter processPredicate];
    _logArrayController.filterPredicate = [_logFilter logPredicate];
}





#pragma mark - make GUI


- (void)createGUI
{
    
    NSSize windowSize = _window.frame.size;
    
    _clearButton = [[NSButton alloc] initWithFrame:NSMakeRect(525, windowSize.height - 220, 100, 25)];
    [_clearButton setIdentifier:@"clearButton"];
    [_clearButton setTag:0];
    [_clearButton setTitle:@"Clear Log"];
    [_clearButton setTarget:self];
    [_clearButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_clearButton];
    
    
    
    _saveallButton = [[NSButton alloc] initWithFrame:NSMakeRect(730, windowSize.height - 90, 100, 25)];
    [_saveallButton setIdentifier:@"saveallButton"];
    [_saveallButton setTag:2];
    [_saveallButton setTitle:@"Save All"];
    [_saveallButton setTarget:self];
    [_saveallButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_saveallButton];
    
    _savefilteredButton = [[NSButton alloc] initWithFrame:NSMakeRect(730, windowSize.height - 130, 100, 25)];
    [_savefilteredButton setIdentifier:@"saveFilteredButton"];
    [_savefilteredButton setTag:3];
    [_savefilteredButton setTitle:@"Save Filtered"];
    [_savefilteredButton setTarget:self];
    [_savefilteredButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_savefilteredButton];

    _loadfileButton = [[NSButton alloc] initWithFrame:NSMakeRect(730, windowSize.height - 170, 100, 25)];
    [_loadfileButton setIdentifier:@"loadFileButton"];
    [_loadfileButton setTag:1];
    [_loadfileButton setTitle:@"Load File"];
    [_loadfileButton setTarget:self];
    [_loadfileButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_loadfileButton];


    
    _logSearchField = [[NSSearchField alloc] initWithFrame:NSMakeRect(480, windowSize.height - 130, 200, 50)];
    [_logSearchField setIdentifier:@"LogSearch"];
    [_logSearchField setTag:0];
    [_logSearchField setDelegate:self];
    [_window.contentView addSubview:_logSearchField];
    
    _loghighlightField = [[NSSearchField alloc] initWithFrame:NSMakeRect(480, windowSize.height - 190, 200, 50)];
    [_loghighlightField setIdentifier:@"LogHighlight"];
    [_loghighlightField setTag:1];
    [_loghighlightField setDelegate:self];
    [_window.contentView addSubview:_loghighlightField];
    
    _searchLog = [[NSTextField alloc] initWithFrame:NSMakeRect(480, windowSize.height - 90, 200, 20)];
    [_searchLog setStringValue:@"Searching Log"];
    [_searchLog setTextColor:[NSColor redColor]];
    [_searchLog setBezeled:NO];
    [_searchLog setDrawsBackground:NO];
    [_searchLog setEditable:NO];
    [_searchLog setSelectable:NO];
    [_window.contentView addSubview:_searchLog];
    
    _highlightLog = [[NSTextField alloc] initWithFrame:NSMakeRect(480, windowSize.height - 150, 200, 20)];
    [_highlightLog setStringValue:@"Highlighting Log"];
    [_highlightLog setTextColor:[NSColor redColor]];
    [_highlightLog setBezeled:NO];
    [_highlightLog setDrawsBackground:NO];
    [_highlightLog setEditable:NO];
    [_highlightLog setSelectable:NO];
    [_window.contentView addSubview:_highlightLog];
    
    _deviceName = [[NSTextField alloc] initWithFrame:NSMakeRect(10, windowSize.height - 70, 100, 20)];
    [_deviceName setStringValue:@"Device Name"];
    [_deviceName setBackgroundColor:[NSColor darkGrayColor]];
    [_deviceName setBezeled:NO];
    [_deviceName setEditable:NO];
    [_deviceName setSelectable:NO];
    [_window.contentView addSubview:_deviceName];

    
    _processName = [[NSTextField alloc] initWithFrame:NSMakeRect(150, windowSize.height - 70, 100, 20)];
    [_processName setStringValue:@"Process Name"];
    [_processName setBackgroundColor:[NSColor darkGrayColor]];
    [_processName setBezeled:NO];
    [_processName setEditable:NO];
    [_processName setSelectable:NO];
    [_window.contentView addSubview:_processName];

    
    _logLevel = [[NSTextField alloc] initWithFrame:NSMakeRect(330, windowSize.height - 70, 70, 20)];
    [_logLevel setStringValue:@"Log Level"];
    [_logLevel setBackgroundColor:[NSColor darkGrayColor]];
    [_logLevel setBezeled:NO];
    [_logLevel setEditable:NO];
    [_logLevel setSelectable:NO];
    [_window.contentView addSubview:_logLevel];

    
    
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(330, windowSize.height - 220, 120, 150)];
    _logLevelTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(330, windowSize.height - 220, 120, 150)];
    [_logLevelTableView setIdentifier:@"logLevelTable"];
    [_logLevelTableView setTag:3];
    [_logLevelTableView setHeaderView: nil];
    NSTableColumn *logLevelColumn = [[NSTableColumn alloc] initWithIdentifier:@"logLevel"];
    _logLevelArray = @[@"Debug", @"Info", @"Notice", @"Warning", @"Error", @"Critical", @"Alert", @"Emergency"];
    [_logLevelTableView addTableColumn:logLevelColumn];
    [_logLevelTableView setDelegate:self ];
    [_logLevelTableView setDataSource:self];
    [_logLevelTableView reloadData];
    [tableContainer setDocumentView:_logLevelTableView];
    [tableContainer setHasVerticalScroller:YES];
    [_window.contentView addSubview:tableContainer];
    
}



- (void)makeLogTableWithLogArrayController:(MyLogDataController *)aLogArrayController
{
    _logArrayController = aLogArrayController;
    _logArrayController.selectsInsertedObjects = NO;
    
    NSSize windowSize = _window.frame.size;
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, windowSize.width - 20, windowSize.height - 240)];
    _logTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, windowSize.width - 20, windowSize.height - 200)];
    [_logTableView setIdentifier:@"LogTable"];
    [_logTableView setTag:0];
    
    _dateColumn = [[NSTableColumn alloc] initWithIdentifier:@"date"];
    _deviceColumn = [[NSTableColumn alloc] initWithIdentifier:@"device"];
    _processColumn = [[NSTableColumn alloc] initWithIdentifier:@"process"];
    _logLevelColumn = [[NSTableColumn alloc] initWithIdentifier:@"logLevel"];
    _logColumn = [[NSTableColumn alloc] initWithIdentifier:@"log"];
    
    [_dateColumn.headerCell setTitle:@"Date"];
    [_deviceColumn.headerCell setTitle:@"Device"];
    [_processColumn.headerCell setTitle:@"Process"];
    [_logLevelColumn.headerCell setTitle:@"LogLevel"];
    [_logColumn.headerCell setTitle:@"Log"];
    
    [_dateColumn setWidth:100];
    [_deviceColumn setWidth:100];
    [_processColumn setWidth:100];
    [_logLevelColumn setWidth:100];
    [_logColumn setWidth:windowSize.width];
    
    [_dateColumn bind:NSValueBinding toObject:aLogArrayController
       withKeyPath:@"arrangedObjects.date" options:nil];
    [_dateColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];

    [_deviceColumn bind:NSValueBinding toObject:aLogArrayController
         withKeyPath:@"arrangedObjects.device" options:nil];
    [_deviceColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];

    [_processColumn bind:NSValueBinding toObject:aLogArrayController
            withKeyPath:@"arrangedObjects.process" options:nil];
    [_processColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [_logLevelColumn bind:NSValueBinding toObject:aLogArrayController
         withKeyPath:@"arrangedObjects.logLevel" options:nil];
    [_logLevelColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [_logColumn bind:NSValueBinding toObject:aLogArrayController
         withKeyPath:@"arrangedObjects.log" options:nil];
    [_logColumn bind:@"textColor" toObject:aLogArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
 
    // add column
    [_logTableView addTableColumn:_dateColumn];
    [_logTableView addTableColumn:_deviceColumn];
    [_logTableView addTableColumn:_processColumn];
    [_logTableView addTableColumn:_logLevelColumn];
    [_logTableView addTableColumn:_logColumn];
    
    [_logTableView setDelegate:self ];
    [_logTableView setDataSource:self];
    [_logTableView setAllowsMultipleSelection:YES];
    [_logTableView reloadData];
    
    
    [tableContainer setDocumentView:_logTableView];
    [tableContainer setHasVerticalScroller:YES];
    [[tableContainer contentView] setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsChangeNotificationHandler:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[tableContainer contentView]];
    
    [_window.contentView addSubview:tableContainer];
}



- (void)makeDeviceTableWithDeviceArrayController:(MyLogDataController *)aDeviceArrayController
{
    _deviceArrayController = aDeviceArrayController;
    _deviceArrayController.selectsInsertedObjects = NO;
    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 220, 120, 150)];
    _deviceTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 220, 120, 150)];
    [_deviceTableView setIdentifier:@"deviceSet"];
    [_deviceTableView setHeaderView: nil];
    [_deviceTableView setTag:1];
    
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

- (void)makeProcessTable:(MyLogDataController *)aProcessArrayController
{
    _processArrayController = aProcessArrayController;
    _processArrayController.selectsInsertedObjects = NO;

    NSSize windowSize = _window.frame.size;
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(150, windowSize.height - 220, 150, 150)];
    _processTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(150, windowSize.height - 220, 150, 150)];
    [_processTableView setIdentifier:@"processSet"];
    [_processTableView setHeaderView: nil];
    [_processTableView setTag:2];
    
    
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
    
    if( tableView.tag == 3)
    {
        return _logLevelArray.count;
    }
    
    return [tableView numberOfRows];
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if((_highlightString != nil) && ([tableColumn.identifier isEqualToString:@"log"]))
    {
        NSTextFieldCell *cell = aCell;
        NSMutableAttributedString *cellText = [[NSMutableAttributedString alloc] initWithAttributedString:[cell attributedStringValue]];
        NSRange textLocation = [[cellText string] rangeOfString:_highlightString options:NSCaseInsensitiveSearch];
        if(textLocation.location != NSNotFound)
        {
            [cellText addAttribute:NSBackgroundColorAttributeName value:[NSColor redColor] range:textLocation];
            [cellText addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:textLocation];
            [cell setAttributedStringValue:cellText];
            return;
        }
    }
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if( tableView.tag == 3)
    {
        NSButtonCell *cell=[[NSButtonCell alloc] init];
        NSString *displayText;
        displayText=[_logLevelArray objectAtIndex:row];
        [cell setTitle:displayText];
        [cell setAllowsMixedState:YES];
        [cell setButtonType:NSSwitchButton];
        return cell;
    }
    return nil;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    if (tableView.tag == 3)
    {
        BOOL value = [_logFilter logLevel][row];
        return [NSNumber numberWithInteger:(value ? NSOnState : NSOffState)];
    }
    
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn *)column row:(NSInteger)row
{
  
    if (tableView.tag == 3)
    {
        [_logFilter logLevel][row] = [value boolValue];
        [self updateTable];
    }

}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    if ([notification object] == _processTableView){
        NSInteger row = [_processTableView selectedRow];
        if (row == 0){
            [_logFilter setProcess:nil];
            
        } else {
            NSDictionary *processData = [[_processArrayController arrangedObjects] objectAtIndex:row];
            [_logFilter setDeviceID: [processData objectForKey:@"deviceID"]];
            [_logFilter setProcess: [processData objectForKey:@"process"]];
        }
        [self updateTable];
    } else if([notification object] == _deviceTableView) {
        NSInteger row = [_deviceTableView selectedRow];
        if (row == 0){
            [_logFilter setProcess:nil];
            [_logFilter setDeviceID:nil];
        } else {
            NSDictionary *deviceData = [[_deviceArrayController arrangedObjects] objectAtIndex:row];
            [_logFilter setDeviceID: [deviceData objectForKey:@"deviceID"]];
        }
        
        [self updateTable];
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if( tableView.tag == 0)
    {
        LogData *data = [[_logArrayController arrangedObjects] objectAtIndex:row];
        NSInteger line = [[data.log componentsSeparatedByCharactersInSet:
                           [NSCharacterSet newlineCharacterSet]] count];
        if(line > 1)
        {
            return tableView.rowHeight * (line - 1);
        }
    }
    return tableView.rowHeight;
}


- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}


- (void)boundsChangeNotificationHandler:(NSNotification *)aNotification
{
   
    //NSLog(@"bound");
    if ([aNotification object] == [[_logTableView enclosingScrollView] contentView])
    {
        NSClipView *scrollClipView =[[_logTableView enclosingScrollView] contentView];
        NSPoint currentScrollPosition = [scrollClipView bounds].origin;
        CGSize tableSize = _logTableView.frame.size;
        
        if(currentScrollPosition.y > (tableSize.height - _window.frame.size.height + 240))
        {
            _fixed = NO;
            [_logArrayController setIsUpdateTable:YES];
            [_logArrayController updateArrayController];
        }
        else
        {
            _fixed = YES;
             [_logArrayController setIsUpdateTable:NO];
        }
        
        NSLog(@"%f",currentScrollPosition.y - (tableSize.height - _window.frame.size.height + 240) );
        
    }
    
}


#pragma mark - TextField Delegate


- (void)controlTextDidChange:(NSNotification *)aSearchField
{
    NSInteger searchFieldTag = [[aSearchField object] tag];
    NSTextField *textField = [aSearchField object];
    
    if(searchFieldTag == 0)
    {
        NSString *text = [textField stringValue];
        if([text isEqualToString: @""]) {
            [_logFilter setSentence:nil];
        } else {
            [_logFilter setSentence:text];
        }
        [self updateTable];
    }
    else if(searchFieldTag == 1)
    {
        NSString *text = [textField stringValue];
        if([text isEqualToString: @""]) {
            _highlightString = nil;
        } else {
            _highlightString = text;
        }
        [_logTableView reloadData];
        
    }
}


#pragma mark - Window Delegate


- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    //NSLog(@"resizing");
    [self resizingLogTable:frameSize];
    [self resizingDeviceTable:frameSize];
    [self resizingProcessTable:frameSize];
    [self resizingLogLevelTable:frameSize];
    [self resizingGUI:frameSize];
    
    return frameSize;
}

- (IBAction)copy:(id)sender
{
    NSResponder *firstResponder;
    
    firstResponder = [_window firstResponder];
    if (firstResponder == _logTableView)
    {
        NSIndexSet *selectedIndex = [_logTableView selectedRowIndexes];
        __block NSString *copyString = @"";
        [selectedIndex enumerateIndexesUsingBlock:^(NSUInteger i, BOOL *stop)
        {
            LogData *log = [[_logArrayController arrangedObjects] objectAtIndex:i];
            copyString = [NSString stringWithFormat:@"%@%@%@%@%@%@", copyString, log.date, log.device, log.process, log.logLevel, log.log];
        }];
        NSPasteboard *pastedboard = [NSPasteboard generalPasteboard];
        [pastedboard clearContents];
        [pastedboard setString:copyString forType:NSStringPboardType];
    }
}


#pragma mark - GUI resize function


-  (void)resizingLogTable:(NSSize)frameSize
{
    NSSize frame = frameSize;
    frame.height-= 240;
    frame.width -= 20;
    
    [[_logTableView enclosingScrollView] setFrameSize: frame];
    [[_logTableView enclosingScrollView] setNeedsDisplay: YES];

}

- (void)resizingDeviceTable:(NSSize)frameSize
{
    [[_deviceTableView enclosingScrollView] setFrame:NSMakeRect(10, frameSize.height - 220, 120, 150)];
    [[_deviceTableView enclosingScrollView] setNeedsDisplay: YES];
}

- (void)resizingProcessTable:(NSSize)frameSize
{
    [[_processTableView enclosingScrollView] setFrame:NSMakeRect(150, frameSize.height - 220, 150, 150)];
    [[_processTableView enclosingScrollView] setNeedsDisplay: YES];
}

- (void)resizingLogLevelTable:(NSSize)frameSize
{
    [[_logLevelTableView enclosingScrollView] setFrame: NSMakeRect(330, frameSize.height - 220, 120, 150)];
    [[_logLevelTableView enclosingScrollView] setNeedsDisplay: YES];
}

- (void)resizingGUI:(NSSize)frameSize
{
 
    [_logSearchField setFrame:NSMakeRect(480, frameSize.height - 130, 200, 50)];
    [_loghighlightField setFrame:NSMakeRect(480, frameSize.height - 190, 200, 50)];
    [_clearButton setFrame:NSMakeRect(525, frameSize.height - 220, 100, 25)];
    [_loadfileButton setFrame:NSMakeRect(730, frameSize.height - 170, 100, 25)];
    [_savefilteredButton setFrame:NSMakeRect(730, frameSize.height - 130, 100, 25)];
    [_saveallButton setFrame:NSMakeRect(730, frameSize.height - 90, 100, 25)];
    [_searchLog setFrame:NSMakeRect(480, frameSize.height - 90, 200, 20)];
    [_highlightLog setFrame:NSMakeRect(480, frameSize.height - 150, 200, 20)];
    [_deviceName setFrame:NSMakeRect(10, frameSize.height - 70, 100, 20)];
    [_processName setFrame:NSMakeRect(150, frameSize.height - 70, 100, 20)];
    [_logLevel setFrame:NSMakeRect(330, frameSize.height - 70, 70, 20)];

    
}


#pragma mrak - Button Event Function


- (void)buttonClicked: (NSButton *)button
{
    NSInteger buttonTag = [button tag];
    
    switch (buttonTag) {
        case 0:
            [[_logArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
            [[_processArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
            [[_deviceArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
            [_processArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Process", @"process", nil]];
            [_deviceArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Device", @"device", nil]];

            break;
        case 1:
            if ([_delegate respondsToSelector:@selector(fileLoading)]) {
                [_delegate fileLoading];
            }
            
            break;
        case 2:
            if ([_delegate respondsToSelector:@selector(fileSaving:)]) {
                [_delegate fileSaving:YES];
            }
            break;
            
        case 3:
            if ([_delegate respondsToSelector:@selector(fileSaving:)]) {
                [_delegate fileSaving:NO];
            }
            break;
            
        default:
            break;
    }
}

@end
