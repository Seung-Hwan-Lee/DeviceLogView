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


- (void)readFile
{
    NSURL *filePath = [self openDialogAndGetFilePath];
    NSString *fileContent = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
   
    NSArray* allLinedStrings =
    [fileContent componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    NSString *sendText;
    
    for( int i = 0 ; i < allLinedStrings.count ; i++)
    {
        NSString *tempString = [allLinedStrings objectAtIndex:i];
       
        if(tempString.length != 0 &&[tempString characterAtIndex:0] == NSTabCharacter)
        {
            sendText = [NSString stringWithFormat:@"%@%@", sendText, tempString];
        }
        else
        {
            if( sendText != nil)
            {
                const char* utf8String = [sendText UTF8String];
                size_t len = strlen(utf8String) + 1;
                [self.delegate analizeWithLogBuffer:utf8String length:len deviceID:[filePath absoluteString]];
            }
            sendText =  [NSString stringWithFormat:@"%@\n", tempString];
        }
    }
    if( sendText != nil)
    {
        const char* utf8String = [sendText UTF8String];
        size_t len = strlen(utf8String) + 1;
        [self.delegate analizeWithLogBuffer:utf8String length:len deviceID:[filePath absoluteString]];
    }
    
}


#pragma mark - Get FilePath with Dialog


- (NSURL *)openDialogAndGetFilePath
{
#warning comment
    // 객체는 생성 시 nil 처리 하는 습관
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
