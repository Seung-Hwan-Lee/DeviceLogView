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
    NSButton *_loadfileButton;
    NSArrayController *_processArrayController;
    NSArrayController *_deviceArrayController;
    NSArrayController *_logArrayController;
    NSArray *_logLevelArray;
    NSSearchField *_logSearchField;
    NSSearchField *_loghighlightField;
    BOOL _fixed;
    NSString *_highlightString;
}


#pragma mark - initialize


-(id)initWithWindow:(NSWindow *)aWindow
{
    self = [super init];
    if (self) {
        _window = aWindow;
        _logFilter = [[LogFilter alloc]init];
        _highlightString = nil;
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
    
    _fixedButton = [[NSButton alloc] initWithFrame:NSMakeRect(720, windowSize.height - 180, 80, 25)];
    [_fixedButton setButtonType:NSSwitchButton];
    [_fixedButton setIdentifier:@"fixedButton"];
    [_fixedButton setTitle:@"Fixed"];
    [_fixedButton setTarget:self];
    [_fixedButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_fixedButton];
    _fixed = NO;
    
    _clearButton = [[NSButton alloc] initWithFrame:NSMakeRect(610, windowSize.height - 180, 80, 25)];
    [_clearButton setIdentifier:@"clearButton"];
    [_clearButton setTitle:@"Clear"];
    [_clearButton setTarget:self];
    [_clearButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_clearButton];
    
    
    _loadfileButton = [[NSButton alloc] initWithFrame:NSMakeRect(480, windowSize.height - 130, 80, 25)];
    [_loadfileButton setIdentifier:@"loadFileButton"];
    [_loadfileButton setTitle:@"LoadFile"];
    [_loadfileButton setTarget:self];
    [_loadfileButton setAction:@selector(buttonClicked:)];
    [_window.contentView addSubview:_loadfileButton];

    
    _logSearchField = [[NSSearchField alloc] initWithFrame:NSMakeRect(600, windowSize.height - 90, 200, 50)];
    [_logSearchField setIdentifier:@"LogSearch"];
    [_logSearchField setDelegate:self];
    [_window.contentView addSubview:_logSearchField];
    
    _loghighlightField = [[NSSearchField alloc] initWithFrame:NSMakeRect(600, windowSize.height - 150, 200, 50)];
    [_loghighlightField setIdentifier:@"LogHighlight"];
    [_loghighlightField setDelegate:self];
    [_window.contentView addSubview:_loghighlightField];
    
    
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(330, windowSize.height - 180, 120, 150)];
    _logLevelTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(330, windowSize.height - 180, 120, 150)];
    [_logLevelTableView setIdentifier:@"logLevelTable"];
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
    if( [tableView.identifier isEqualToString:@"logLevelTable"])
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
            [cell setAttributedStringValue:cellText];
            return;
        }
    }
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if( [tableView.identifier isEqualToString:@"logLevelTable"])
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
    
    if ([tableView.identifier isEqualToString:@"logLevelTable"])
    {
        BOOL value = [_logFilter logLevel][row];
        return [NSNumber numberWithInteger:(value ? NSOnState : NSOffState)];
    }
    
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn *)column row:(NSInteger)row
{
  
    if ([tableView.identifier isEqualToString:@"logLevelTable"])
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
    if( [tableView.identifier isEqualToString:@"LogTable"])
    {
        LogData *data = [[_logArrayController arrangedObjects] objectAtIndex:row];
        NSInteger line = [[data.log componentsSeparatedByCharactersInSet:
                           [NSCharacterSet newlineCharacterSet]] count];
        return tableView.rowHeight * (line - 1);
        
    }
    return tableView.rowHeight;
}


#pragma mark - TextField Delegate


- (void)controlTextDidChange:(NSNotification *)aObject
{
    NSString *objectIdentifier = [[aObject object] identifier];
    NSTextField *textField = [aObject object];
    
    if([objectIdentifier isEqualToString:@"LogSearch"])
    {
        NSString *text = [textField stringValue];
        if([text isEqualToString: @""]) {
            [_logFilter setSentence:nil];
        } else {
            [_logFilter setSentence:text];
        }
        [self updateTable];
    }
    else if([objectIdentifier isEqualToString:@"LogHighlight"])
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


#pragma mark - GUI resize function


-  (void)resizingLogTable:(NSSize)frameSize
{
    NSSize frame = frameSize;
    frame.height-= 200;
    frame.width -= 20;
    
    [[_logTableView enclosingScrollView] setFrameSize: frame];
    [[_logTableView enclosingScrollView] setNeedsDisplay: YES];

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

- (void)resizingGUI:(NSSize)frameSize
{
 
    [_fixedButton setFrame:NSMakeRect(720, frameSize.height - 180, 80, 25)];
    [_logSearchField setFrame:NSMakeRect(600, frameSize.height - 90, 200, 50)];
    [_loghighlightField setFrame:NSMakeRect(600, frameSize.height - 150, 200, 50)];
    [_clearButton setFrame:NSMakeRect(610, frameSize.height - 180, 80, 25)];
    [_loadfileButton setFrame:NSMakeRect(480, frameSize.height - 130, 80, 25)];
    
}


#pragma mrak - Button Event Function


- (void)buttonClicked: (NSButton *)button
{
#warning comment
    // 버튼을 구분하기 위해 identifier의 NSString 객체로 비교하는 거보다
    // tag 를 이용해서 구분처리하는게 비용이 더 쌉니다.
    // tag로 변경해주시고 if else 가 3개이상 될경우에는 switch case 문으로
    NSString *buttonIdentifier = [button identifier];

    if([buttonIdentifier isEqualToString:@"fixedButton"]){
        _fixed = !_fixed;
    }
    else if([buttonIdentifier isEqualToString:@"clearButton"])
    {
        [[_logArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
        [[_processArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
        [_processArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Process", @"process", nil]];
    }
    
    else if([buttonIdentifier isEqualToString:@"loadFileButton"])
    {
#warning comment
        // delegate method 호출시에는 항상 selector 가 응답할수 있는 지 체크가 필요.
        if ([_delegate respondsToSelector:@selector(fileLoading)]) {
            [_delegate fileLoading];
        }
    }
}



@end
