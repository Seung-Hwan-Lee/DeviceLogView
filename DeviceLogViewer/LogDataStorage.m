//
//  SaveLogData.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 17..
//  Copyright (c) 2014년 line. All rights reserved.
//


#import "LogDataStorage.h"


@implementation LogDataStorage
{
    AnalyzeDeviceLog *_analyzeDeviceLog;
    
    NSString *_cacheForderPaths;
    NSString *filePath;
    
}


- (id)init
{
    self = [super init];
    if(self)
    {
        NSArray *documentsDirectory  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _cacheForderPaths = [[documentsDirectory objectAtIndex:0] stringByAppendingString:@"/MyDeviceLog/"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheForderPaths])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cacheForderPaths withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        _logDataArrayController = [[NSArrayController alloc] init];
        _processArrayController = [[NSArrayController alloc] init];
        _deviceArrayController = [[NSArrayController alloc] init];
        
        _logDataArrayController.selectsInsertedObjects = NO;
        _processArrayController.selectsInsertedObjects = NO;
        _deviceArrayController.selectsInsertedObjects = NO;


        [_logDataArrayController setAutomaticallyPreparesContent:YES];
        [_logDataArrayController setAutomaticallyRearrangesObjects:YES];
        //[_logDataArrayController setClearsFilterPredicateOnInsertion:NO];
        //[_processArrayController setClearsFilterPredicateOnInsertion:NO];
        //[_deviceArrayController setClearsFilterPredicateOnInsertion:NO];
        
        [_deviceArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Source", @"device", nil]];
        [_processArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Process", @"process", nil]];

        
        _analyzeDeviceLog =[[AnalyzeDeviceLog alloc] init];
        _analyzeDeviceLog.delegate = self;
        [_analyzeDeviceLog readLogFromDevice];
    }
    return self;
}


#pragma mark -


- (void)fileOpen
{
    [_analyzeDeviceLog readLogFromFile];
}


#pragma mark -


- (void) readFile
{
    [_analyzeDeviceLog readLogFromFile];
}

- (void) readDevice
{
    [_analyzeDeviceLog readLogFromDevice];
}


#pragma mark - Add Object to ArrayContoller


- (void)addLogDataToArrayController:(LogData *)aLogData
{
    [_logDataArrayController addObject:aLogData];
}


- (void)addProcessNameToArrayWithProcessName:(NSString *)aProcessName deviceID:(NSString *)aDeviceID;
{
    if(aProcessName) {
        
        BOOL isFound = NO;
        
        NSDictionary *processDictionary = @{@"process" : aProcessName, @"deviceID" : aDeviceID};
        
        for (NSDictionary *mod in _processArrayController.content)
        {
            if ([mod isEqualToDictionary:processDictionary])
            {
                isFound = true;
                break;
            }
        }
        
        if (!isFound){
            [_processArrayController addObject:processDictionary];
        }
    }
    
}

-(void)addDeviceNameToArrayWithDeviceName:(NSString *)aDeviceName deviceID:(NSString *)aDeviceID
{
    if(aDeviceName) {
        BOOL isFound = false;
        NSDictionary *deviceDictionary = [NSDictionary dictionaryWithObjectsAndKeys:aDeviceName, @"device",
                                          aDeviceID, @"deviceID", nil];
        
        for(NSDictionary *mod in _deviceArrayController.content)
        {
            if([mod isEqualToDictionary:deviceDictionary])
            {
                isFound = true;
                break;
            }
        }
        
        if(!isFound){
            [_deviceArrayController addObject:deviceDictionary];
        }
    }
    
}


#pragma mark - AnalyzeDeviceLogDelegate


- (void)analyzedLog:(NSDictionary *)aAnalyzedLog isDevice:(BOOL)isDevice
{
    LogData *logData = [[LogData alloc] initWithLogDataInfo:aAnalyzedLog];
    NSString *sourceType;
    if(isDevice)
    {
        sourceType = @"D: ";
    }
    else
    {
        sourceType = @"F: ";
    }
    
    
    [self addDeviceNameToArrayWithDeviceName:[sourceType stringByAppendingString:logData.device] deviceID:logData.deviceID];
    [self addProcessNameToArrayWithProcessName:logData.process deviceID:logData.deviceID];
    [self addLogDataToArrayController:logData];
    if(isDevice)
    {
        [self saveLogToCacheFile:logData];
    }
    
    if ([_delegate respondsToSelector:@selector(dataUpdate)]) {
        [_delegate dataUpdate];
    }
}

- (void)deviceConnected
{
    NSLog(@"device connected");
}

- (void)deviceDisConnectedWithDeviceID:(NSString *)aDeviceID
{
    
    NSArray *allLogs = [_logDataArrayController content];
    NSArray *allDevice = [_deviceArrayController content];
    NSArray *allProcess = [_processArrayController content];
    
    NSArray *deleteLogs = [allLogs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"deviceID MATCHES %@", aDeviceID]];
    [_logDataArrayController removeObjects: deleteLogs];
    NSArray *deleteDevices = [allDevice filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"deviceID MATCHES %@", aDeviceID]];
    [_deviceArrayController removeObjects: deleteDevices];
    NSArray *deleteProcess = [allProcess filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"deviceID MATCHES %@", aDeviceID]];
    [_processArrayController removeObjects: deleteProcess];
    NSLog(@"device disconncted");
    
}





#pragma mark - save file

- (void)saveLogToCacheFile:(LogData *)aLog
{
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY_MM_dd_HH"];
    NSString *fileName = [[outputFormatter stringFromDate:now] stringByAppendingString:@"_LogData.txt"];
    filePath = [NSString stringWithFormat:@"%@%@", _cacheForderPaths, fileName];
    NSString *logData = [NSString stringWithFormat:@"%@%@%@%@%@", aLog.date, aLog.device, aLog.process, aLog.logLevel, aLog.log];
    NSData *data = [logData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    [fileHandle closeFile];
    
}


- (void)saveFile:(BOOL)isSavingEveryLog
{
    
    NSString *stringfilePath = [[[self openDialogForSaveFile] absoluteString] substringFromIndex:7];
    
    NSArray *logData = nil;
    
    if(isSavingEveryLog)
    {
        logData = [_logDataArrayController content];
        
    }
    else
    {
        logData = [_logDataArrayController arrangedObjects];
    }
    
    if( logData != nil && stringfilePath != nil)
    {
       
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:stringfilePath contents:nil attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:stringfilePath];
        
        for(int i = 0 ; i < [logData count] ; i++)
        {
            LogData *aLog = [logData objectAtIndex:i];
            NSString *log = [NSString stringWithFormat:@"%@%@%@%@%@", aLog.date, aLog.device, aLog.process, aLog.logLevel, aLog.log];
            NSData *data = [log dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            [fileHandle writeData:data];
        }
        
        [fileHandle closeFile];
        
    }
}

- (NSURL *)openDialogForSaveFile
{
    NSURL *url = nil;
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel setMessage:@"Please select a path where to save checkboard as an image."]; // Message inside modal window
    [panel setAllowsOtherFileTypes:YES];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setNameFieldStringValue:@"NewFile.txt"];
    
    
    NSInteger result = [panel runModal];
    
    if (result == NSOKButton)
    {
        url  = [panel URL];
    }
    return url;
}

- (NSString *)currentFilePath
{
    return filePath;
}

@end



