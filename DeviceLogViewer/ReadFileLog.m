//
//  ReadFileLog.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 17..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "ReadFileLog.h"


@implementation ReadFileLog


#pragma mark - Read File Line by Line


- (void)readConsoleLogFile
{
    
    NSURL *filePath = [self openDialogForOpenFile];
    
    
    NSString *fileContent = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *allLinedStrings =[fileContent componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    NSLog(@"%ld", [allLinedStrings count]);
        NSString *sendText;
        
        for( int i = 0 ; i < allLinedStrings.count ; i++)
        {
            
            NSString *tempString = [allLinedStrings objectAtIndex:i];
          
            if(tempString.length != 0 &&[tempString characterAtIndex:0] == NSTabCharacter)
            {
                sendText = [NSString stringWithFormat:@"%@%@\n", sendText, tempString];
            }
            else
            {
                if( sendText != nil)
                {
                    const char* utf8String = [sendText UTF8String];
                    size_t len = strlen(utf8String);
                    
                    if ([_delegate respondsToSelector:@selector(analizeWithLogBuffer:length:deviceID:source:)]) {
                        [_delegate analizeWithLogBuffer:utf8String length:len deviceID:[filePath absoluteString] source:1];
                    }
                }
                sendText =  [NSString stringWithFormat:@"%@\n", tempString];
            }
        }
        if( sendText != nil)
        {
            const char* utf8String = [sendText UTF8String];
            size_t len = strlen(utf8String);
            if ([_delegate respondsToSelector:@selector(analizeWithLogBuffer:length:deviceID:source:)]) {
                [_delegate analizeWithLogBuffer:utf8String length:len deviceID:[filePath absoluteString] source:1];
            }
        }
        
    
}




- (void)readDeviceLogFile
{
    
    NSURL *filePath = [self openDialogForOpenFile];

    NSString *fileContent = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *allLinedStrings =[fileContent componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    NSString *sendText;
    
    for( int i = 0 ; i < allLinedStrings.count ; i++)
    {
        
        NSString *tempString = [allLinedStrings objectAtIndex:i];
        
        if(tempString.length != 0 && !isnumber([tempString characterAtIndex:0]))
        {
            sendText = [NSString stringWithFormat:@"%@%@\n", sendText, tempString];
        }
        else
        {
            if( sendText != nil)
            {
                const char* utf8String = [sendText UTF8String];
                size_t len = strlen(utf8String);
                
                if ([_delegate respondsToSelector:@selector(analizeWithLogBuffer:length:deviceID:source:)]) {
                    [_delegate analizeWithLogBuffer:utf8String length:len deviceID:[filePath absoluteString] source:3];
                }
            }
            sendText =  [NSString stringWithFormat:@"%@\n", tempString];
        }
    }
    if( sendText != nil)
    {
        const char* utf8String = [sendText UTF8String];
        size_t len = strlen(utf8String);
        if ([_delegate respondsToSelector:@selector(analizeWithLogBuffer:length:deviceID:source:)]) {
            [_delegate analizeWithLogBuffer:utf8String length:len deviceID:[filePath absoluteString] source:3];
        }
    }
    
    
}



#pragma mark - Get FilePath with Dialog


- (NSURL *)openDialogForOpenFile
{
    NSURL *url = nil;
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanChooseDirectories:NO];
    if ([openDlg runModal] == NSOKButton)
    {
        NSArray* urls = [openDlg URLs];
        for(int i = 0; i < [urls count]; i++ )
        {
            url = [urls objectAtIndex:i];
        }
    }
    
    return url;
}


@end
