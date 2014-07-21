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
}


- (id)init
{
    self = [super init];
    if(self)
    {
        _logDataArrayController = [[NSArrayController alloc] init];
        _processArrayController = [[NSArrayController alloc] init];
        [_processArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Process", @"process", nil]];
        _deviceArrayController = [[NSArrayController alloc] init];
        [_deviceArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Device", @"device", nil]];
        
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


- (void)analyzedLog:(NSDictionary *)aAnalyzedLog
{
    LogData *logData = [[LogData alloc] initWithLogDataInfo:aAnalyzedLog];
    [self addDeviceNameToArrayWithDeviceName:logData.device deviceID:logData.deviceID];
    [self addProcessNameToArrayWithProcessName:logData.process deviceID:logData.deviceID];
    [self addLogDataToArrayController:logData];
    
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
    [[_processArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
    [[_deviceArrayController mutableArrayValueForKey:@"content"] removeAllObjects];
    [_processArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Process", @"process", nil]];
    [_deviceArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Device", @"device", nil]];
    
    NSArray *deleteLogs = [allLogs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"deviceID MATCHES %@", aDeviceID]];
    [_logDataArrayController removeObjects: deleteLogs];
    
    NSArray *arrangedLogs = [_logDataArrayController valueForKeyPath:@"arrangedObjects"];
    for(int i = 0 ; i < arrangedLogs.count ; i++)
    {
        LogData *logData = [arrangedLogs objectAtIndex:i];
        [self addProcessNameToArrayWithProcessName:logData.process deviceID:logData.deviceID];
        [self addDeviceNameToArrayWithDeviceName:logData.device deviceID:logData.deviceID];
    }
    
    NSLog(@"device disconncted");

}





#pragma mark - save file


- (void)saveFile:(BOOL)isSavingEveryLog
{
    NSURL *filePath = [self openDialogForSaveFile];
    NSArray *logData = nil;
    
    if(isSavingEveryLog)
    {
        logData = [_logDataArrayController content];

    }
    else
    {
        logData = [_logDataArrayController arrangedObjects];
    }
    
    if( logData != nil && filePath != nil)
    {
        NSString *saveLogData = @"";
        for(int i = 0 ; i < [logData count] ; i++)
        {
            LogData *log = [logData objectAtIndex:i];
            saveLogData = [NSString stringWithFormat:@"%@%@%@%@%@%@", saveLogData, log.date, log.device, log.process, log.logLevel, log.log];
        }
        
        [saveLogData writeToURL:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
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

@end



/*
- (NSManagedObjectModel *)_model
{
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
    
	// create the entity
	NSEntityDescription *entity = [[NSEntityDescription alloc] init];
	[entity setName:@"CachedFile"];
	[entity setManagedObjectClassName:@"CachedFile"];
    
	// create the attributes
	NSMutableArray *properties = [NSMutableArray array];
    
    NSAttributeDescription *deviceID = [[NSAttributeDescription alloc] init];
	[deviceID setName:@"deviceID"];
	[deviceID setAttributeType:NSStringAttributeType];
	[deviceID setOptional:NO];
	[deviceID setIndexed:YES];
	[properties addObject:deviceID];

    
	NSAttributeDescription *date = [[NSAttributeDescription alloc] init];
	[date setName:@"date"];
	[date setAttributeType:NSStringAttributeType];
	[date setOptional:NO];
	[date setIndexed:YES];
	[properties addObject:date];
    
    NSAttributeDescription *device = [[NSAttributeDescription alloc] init];
	[device setName:@"device"];
	[device setAttributeType:NSStringAttributeType];
	[device setOptional:NO];
	[device setIndexed:YES];
	[properties addObject:device];
    
    NSAttributeDescription *process = [[NSAttributeDescription alloc] init];
	[process setName:@"process"];
	[process setAttributeType:NSStringAttributeType];
	[process setOptional:NO];
	[process setIndexed:YES];
	[properties addObject:process];
    
    NSAttributeDescription *logLevel = [[NSAttributeDescription alloc] init];
	[logLevel setName:@"logLevel"];
	[logLevel setAttributeType:NSStringAttributeType];
	[logLevel setOptional:NO];
	[logLevel setIndexed:YES];
	[properties addObject:logLevel];
    
    NSAttributeDescription *log = [[NSAttributeDescription alloc] init];
	[log setName:@"log"];
	[log setAttributeType:NSStringAttributeType];
	[log setOptional:NO];
	[log setIndexed:YES];
	[properties addObject:log];
    
	NSAttributeDescription *textColor = [[NSAttributeDescription alloc] init];
	[textColor setName:@"textColor"];
	[textColor setAttributeType:NSStringAttributeType];
	[textColor setOptional:YES];
	[properties addObject:textColor];
    
	// add attributes to entity
	[entity setProperties:properties];
    
	// add entity to model
	[model setEntities:[NSArray arrayWithObject:entity]];
    
	return model;
}*/

