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
    NSButton *_clearButton;
    NSButton *_loadfileButton;
    NSButton *_saveallButton;
    NSButton *_savefilteredButton;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;
    NSArrayController *_logArrayController;
    NSArray *_logLevelArray;
    NSSearchField *_logSearchField;
    NSSearchField *_loghighlightField;
    NSTextField *_dataSource, *_processName, *_logLevel, *_searchLog, *_highlightLog;
    NSMutableArray *_checkedLog;
    NSInteger _checkedPoint;
    
    NSScrollView *_logScrollContainer;
    NSTableColumn *_dateColumn;
    NSTableColumn *_deviceColumn;
    NSTableColumn *_processColumn;
    NSTableColumn *_logLevelColumn;
    NSTableColumn *_logColumn;
    
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
        _checkedLog = [[NSMutableArray alloc] init];
        _highlightString = nil;
        _fixed = NO;
        _checkedPoint= 0;
    }
    
    [_window setDelegate:self];
    [self createGUI];
   
    
    return self;
}


#pragma mark - Update TableView


- (void)updateTable{

    if(!_fixed)
    {
        NSInteger numberOfRows = [_logTableView numberOfRows];
        if (numberOfRows > 0)
        {
            [_logTableView scrollRowToVisible:numberOfRows - 1];
        }
    }
    
}





#pragma mark - make GUI


- (void)createGUI
{
    
    NSSize windowSize = _window.frame.size;
    
    _clearButton = [[NSButton alloc] initWithFrame:NSMakeRect(730, windowSize.height - 210, 100, 25)];
    [_clearButton setIdentifier:@"clearButton"];
    [_clearButton setTag:0];
    [_clearButton setTitle:@"Clear Log"];
    [_clearButton setTarget:self];
    [_clearButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_clearButton];
    
    
    
    _saveallButton = [[NSButton alloc] initWithFrame:NSMakeRect(730, windowSize.height - 170, 100, 25)];
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

    _loadfileButton = [[NSButton alloc] initWithFrame:NSMakeRect(730, windowSize.height - 90, 100, 25)];
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
    [_logSearchField setAutoresizingMask:4];
    [[_logSearchField cell] setScrollable:YES];
    [_window.contentView addSubview:_logSearchField];
    
    
    _loghighlightField = [[NSSearchField alloc] initWithFrame:NSMakeRect(480, windowSize.height - 190, 200, 50)];
    [_loghighlightField setIdentifier:@"LogHighlight"];
    [_loghighlightField setTag:1];
    [_loghighlightField setDelegate:self];
    [_loghighlightField setAutoresizingMask:4];
    [[_loghighlightField cell] setScrollable:YES];
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
    
    _dataSource = [[NSTextField alloc] initWithFrame:NSMakeRect(10, windowSize.height - 70, 100, 20)];
    [_dataSource setStringValue:@"Data Source"];
    [_dataSource setBackgroundColor:[NSColor darkGrayColor]];
    [_dataSource setBezeled:NO];
    [_dataSource setEditable:NO];
    [_dataSource setSelectable:NO];
    [_window.contentView addSubview:_dataSource];

    
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



- (void)makeLogTableWithLogArrayController:(NSArrayController *)aLogArrayController
{
    _logArrayController = aLogArrayController;
      
    NSSize windowSize = _window.frame.size;
    _logScrollContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, windowSize.width - 20, windowSize.height - 240)];
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
    
    [self bindingLogTable];
 
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
    
    
    [_logScrollContainer setDocumentView:_logTableView];
    [_logScrollContainer setHasVerticalScroller:YES];
    [[_logScrollContainer contentView] setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsChangeNotificationHandler:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[_logScrollContainer contentView]];
    
    [_window.contentView addSubview:_logScrollContainer];
}



- (void)makeDeviceTableWithDeviceArrayController:(NSArrayController *)aDeviceArrayController
{
    _deviceArrayController = aDeviceArrayController;
    NSSize windowSize = _window.frame.size;
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 220, 120, 150)];
    _deviceTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(10, windowSize.height - 220, 120, 150)];
    [_deviceTableView setIdentifier:@"deviceSet"];
    [_deviceTableView setHeaderView: nil];
    [_deviceTableView setTag:1];
    
    NSTableColumn *deviceColumn = [[NSTableColumn alloc] initWithIdentifier:@"device"];
    //[deviceColumn setEditable:NO];
    [deviceColumn setWidth:120];
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
    if( tableView.tag == 0)
    {
        if(([tableColumn.identifier isEqualToString:@"date"]) && [_checkedLog containsObject:[[_logArrayController arrangedObjects] objectAtIndex:row]])
        {
            NSTextFieldCell *cell = aCell;
            NSMutableAttributedString *cellText = [[NSMutableAttributedString alloc] initWithAttributedString:[cell attributedStringValue]];
            NSRange searchedRange = NSMakeRange(0, [cellText length]);
        
            [cellText addAttribute:NSBackgroundColorAttributeName value:[NSColor redColor] range:searchedRange];
            [cellText addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:searchedRange];
            [cell setAttributedStringValue:cellText];
            return;
        }
        if((_highlightString != nil) && ([tableColumn.identifier isEqualToString:@"log"]))
        {
            NSTextFieldCell *cell = aCell;
            NSMutableAttributedString *cellText = [[NSMutableAttributedString alloc] initWithAttributedString:[cell attributedStringValue]];
            NSRange searchedRange = NSMakeRange(0, [cellText length]);
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[_highlightString stringByReplacingOccurrencesOfString:@"&" withString:@".*"] options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *matches = [regex matchesInString:[cellText string] options:0 range:searchedRange];
            
            for (NSTextCheckingResult* match in matches) {
                [cellText addAttribute:NSBackgroundColorAttributeName value:[NSColor redColor] range:[match range]];
                [cellText addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:[match range]];
                [cell setAttributedStringValue:cellText];
                //return;
            }
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
         _logArrayController.filterPredicate = [_logFilter logPredicate];
        [self updateTable];
    }

}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    [self bindingLogTable];
    if ([notification object] == _processTableView){
        NSInteger row = [_processTableView selectedRow];
        if(row > [[_processArrayController arrangedObjects] count])
        {
            return;
        }
        if (row == 0){
            
            [_logFilter setProcess:nil];
            
            if( [_deviceTableView selectedRow] == 0)
            {
                [_logFilter setDeviceID:nil];
            }
            _logArrayController.filterPredicate = [_logFilter logPredicate];

            
        } else {
            NSDictionary *processData = [[_processArrayController arrangedObjects] objectAtIndex:row];
            
            [_logFilter setDeviceID: [processData objectForKey:@"deviceID"]];
            [_logFilter setProcess: [processData objectForKey:@"process"]];
            _logArrayController.filterPredicate = [_logFilter logPredicate];

        }
        [self updateTable];
    } else if([notification object] == _deviceTableView) {
        NSInteger row = [_deviceTableView selectedRow];
        if(row > [[_deviceArrayController arrangedObjects] count])
        {
            return;
        }
        if (row == 0){
            
            [_window setTitle:@"DeviceLogViewer"];
            [_logFilter setDeviceID:nil];
            
            _processArrayController.filterPredicate = [_logFilter processPredicate];
            _logArrayController.filterPredicate = [_logFilter logPredicate];
            
        } else {
            NSDictionary *deviceData = [[_deviceArrayController arrangedObjects] objectAtIndex:row];
            NSString *source = [[deviceData objectForKey:@"device"] substringToIndex:2];
            NSString *sourceID = [deviceData objectForKey:@"deviceID"];
            
            if( [source isEqualToString:@"F:"])
            {
                [_window setTitle:sourceID];
            }
            else
            {
                if ([_delegate respondsToSelector:@selector(changeWindowTitle)]) {
                    [_delegate changeWindowTitle];
                }

            }
            
            [_logFilter setDeviceID: sourceID];
            _processArrayController.filterPredicate = [_logFilter processPredicate];
            _logArrayController.filterPredicate = [_logFilter logPredicate];

        }
        [_processTableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:0] byExtendingSelection:NO];
        [_logFilter setProcess:nil];
         _logArrayController.filterPredicate = [_logFilter logPredicate];
        
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
   
    if ([aNotification object] == [[_logTableView enclosingScrollView] contentView])
    {
        NSClipView *scrollClipView =[[_logTableView enclosingScrollView] contentView];
        NSPoint currentScrollPosition = [scrollClipView bounds].origin;
        CGSize tableSize = _logTableView.frame.size;
        
        
        if(currentScrollPosition.y > (tableSize.height - _window.frame.size.height + 255))
        {
            _fixed = NO;
        }
        else
        {
            _fixed = YES;
        }
        
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
       
         _logArrayController.filterPredicate = [_logFilter logPredicate];
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
    NSRect test = textField.frame;
    test.origin.x = 400;

    [textField locationOfPrintRect:test];
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

- (BOOL)windowShouldClose:(id)sender
{
    exit(0);
    return NO;
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
    [_clearButton setFrame:NSMakeRect(730, frameSize.height - 210, 100, 25)];
    [_saveallButton setFrame:NSMakeRect(730, frameSize.height - 170, 100, 25)];
    [_savefilteredButton setFrame:NSMakeRect(730, frameSize.height - 130, 100, 25)];
    [_loadfileButton setFrame:NSMakeRect(730, frameSize.height - 90, 100, 25)];
    [_searchLog setFrame:NSMakeRect(480, frameSize.height - 90, 200, 20)];
    [_highlightLog setFrame:NSMakeRect(480, frameSize.height - 150, 200, 20)];
    [_dataSource setFrame:NSMakeRect(10, frameSize.height - 70, 100, 20)];
    [_processName setFrame:NSMakeRect(150, frameSize.height - 70, 100, 20)];
    [_logLevel setFrame:NSMakeRect(330, frameSize.height - 70, 70, 20)];

    
}


#pragma mrak - Button Event Function


- (void)buttonClicked: (NSButton *)button
{
    NSInteger buttonTag = [button tag];
    
    switch (buttonTag) {
        case 0:
            
            [self unbindingLogTable];
            [_logTableView reloadData];
            
            [[_logArrayController content] removeAllObjects];
            [[_processArrayController content] removeAllObjects];
            [[_deviceArrayController content] removeAllObjects];
            [_processArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Process", @"process", nil]];
            [_deviceArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Source", @"device", nil]];
            
            NSLog(@"%ld", [[_logArrayController content] count]);
            
            break;
        case 1:
            if ([_delegate respondsToSelector:@selector(fileLoading)]) {
                [self unbindingLogTable];
                [_logTableView reloadData];
                [_delegate fileLoading];
                _fixed = YES;
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


#pragma mark - Log Check function

- (void)checkingCurrentLog
{
    NSInteger row = [_logTableView selectedRow];
    if( row >= 0)
    {
        LogData *log = [[_logArrayController arrangedObjects] objectAtIndex:row];
        if(![_checkedLog containsObject:log])
        {
            [_checkedLog addObject:log];
        }
        else
        {
            [_checkedLog removeObject:log];
        }
        [_logTableView reloadData];
    }
}

- (void)moveNextCheckedLog
{
    if([_checkedLog count] < 1)
    {
        return;
    }
    
    if( _checkedPoint >= [_checkedLog count] || _checkedPoint < 0)
    {
        _checkedPoint = 0;
    }
    
    LogData *log = [_checkedLog objectAtIndex:_checkedPoint];
    NSArray *arrangLogs = [_logArrayController arrangedObjects];
    
    if([arrangLogs containsObject:log])
    {
        NSInteger checkedLogRow =[arrangLogs indexOfObject:log];
        [_logTableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex: checkedLogRow] byExtendingSelection:NO];
        [_logTableView scrollRowToVisible:checkedLogRow];
        _checkedPoint++;
    }
    else{
        for( ; _checkedPoint < [_checkedLog count] ; _checkedPoint ++)
        {
            log = [_checkedLog objectAtIndex:_checkedPoint];
            
            if([arrangLogs containsObject:log])
            {
                [self moveNextCheckedLog];
                return;
            }
            
        }
    }

    
}

- (void)movePrevCheckedLog
{
    
    if([_checkedLog count] < 1)
    {
        return;
    }
    
    if( _checkedPoint >= [_checkedLog count] || _checkedPoint < 0)
    {
        _checkedPoint = [_checkedLog count] - 1;
    }
    
    LogData *log = [_checkedLog objectAtIndex:_checkedPoint];
    NSArray *arrangLogs = [_logArrayController arrangedObjects];
    
    if([arrangLogs containsObject:log])
    {
        NSInteger checkedLogRow =[arrangLogs indexOfObject:log];
        [_logTableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex: checkedLogRow] byExtendingSelection:NO];
        [_logTableView scrollRowToVisible:checkedLogRow];
        _checkedPoint--;
    }
    else{
        for( ; _checkedPoint < [_checkedLog count] ; _checkedPoint ++)
        {
            log = [_checkedLog objectAtIndex:_checkedPoint];
            
            if([arrangLogs containsObject:log])
            {
                [self movePrevCheckedLog];
                return;
            }

        }
    }
    
}


# pragma mark -

- (void) bindingLogTable
{
    [_checkedLog removeAllObjects];
    
    [_dateColumn bind:NSValueBinding toObject:_logArrayController
          withKeyPath:@"arrangedObjects.date" options:nil];
    [_dateColumn bind:@"textColor" toObject:_logArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [_deviceColumn bind:NSValueBinding toObject:_logArrayController
            withKeyPath:@"arrangedObjects.device" options:nil];
    [_deviceColumn bind:@"textColor" toObject:_logArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [_processColumn bind:NSValueBinding toObject:_logArrayController
             withKeyPath:@"arrangedObjects.process" options:nil];
    [_processColumn bind:@"textColor" toObject:_logArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [_logLevelColumn bind:NSValueBinding toObject:_logArrayController
              withKeyPath:@"arrangedObjects.logLevel" options:nil];
    [_logLevelColumn bind:@"textColor" toObject:_logArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
    
    [_logColumn bind:NSValueBinding toObject:_logArrayController
         withKeyPath:@"arrangedObjects.log" options:nil];
    [_logColumn bind:@"textColor" toObject:_logArrayController withKeyPath:@"arrangedObjects.textColor" options:nil];
}

- (void) unbindingLogTable
{
    [_dateColumn unbind:NSValueBinding];
    [_dateColumn unbind:@"textColor"];
    [_deviceColumn unbind:NSValueBinding];
    [_deviceColumn unbind:@"textColor"];
    [_processColumn unbind:NSValueBinding];
    [_processColumn unbind:@"textColor"];
    [_logLevelColumn unbind:NSValueBinding];
    [_logLevelColumn unbind:@"textColor"];
    [_logColumn unbind:NSValueBinding];
    [_logColumn unbind:@"textColor"];
}


@end
