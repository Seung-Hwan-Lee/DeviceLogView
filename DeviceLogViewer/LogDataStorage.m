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


#warning comment 메소드의 파라매터의 시작은 항상 소문자로
//DeviceID:(NSString *)aDeviceID; -> deviceID:(NSString *)aDeviceID;
- (void)addProcessNameToArrayWithProcessName:(NSString *)aProcessName deviceID:(NSString *)aDeviceID;
{
    if(aProcessName) {
#warning comment
        // BOOL 변수는 YES / NO 를 사용.
        BOOL isFound = NO;
        
        
#warning comment
        // 아래와 같은 방식보단 modern objective-c 스타일을 따름. (apple 이 권장)
        // NSDictionary *processDictionary = [NSDictionary dictionaryWithObjectsAndKeys:aProcessName, @"process", aDeviceID, @"deviceID",  nil];
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


#warning comment 메소드이름 시작은 항상 소문자로
- (void)analyzedLog:(NSDictionary *)aAnalyzedLog
{
    LogData *logData = [[LogData alloc] initWithLogDataInfo:aAnalyzedLog];
    [self addDeviceNameToArrayWithDeviceName:logData.device deviceID:logData.deviceID];
    [self addProcessNameToArrayWithProcessName:logData.process deviceID:logData.deviceID];
    [self addLogDataToArrayController:logData];
    
#warning comment
    // delegate method 호출시에는 항상 selector 가 응답할수 있는 지 체크가 필요.
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
#warning comment
    // allObjects 라는 변수 이름은 좋지 않아요.
    // 이름만 가지고 어떤 데이터가 들어있는지 알수 있으면 더 좋겠죠?
    // NSArray *allObjects  -> logDatas
    NSArray *allLogs = [_logDataArrayController valueForKeyPath:@"arrangedObjects"];
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
    
    /*for(int i = 0 ; i < allObjects.count ; i++)
    {
        LogData *logData = [allObjects objectAtIndex:i];
        if([logData.deviceID isEqualToString:aDeviceID]){
            [_logDataArrayController removeObject:logData];
            i = i - 1;
        }
        else{
            [self addProcessNameToArrayWithProcessName:logData.process deviceID:logData.deviceID];
            [self addDeviceNameToArrayWithDeviceName:logData.device DeviceID:logData.deviceID];
            //NSLog(@"%@ %@ %@", );
        }
    }*/
    
    NSLog(@"device disconncted");

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

