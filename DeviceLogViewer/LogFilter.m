//
//  LogFilter.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "LogFilter.h"


@implementation LogFilter
{

    NSString *_process;
    NSString *_deviceID;
    NSString *_sentence;
    BOOL _logLevel[8];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if(self) {
        for(int i = 0 ; i < 8 ; i++)
        {
            _logLevel[i] = TRUE;
        }
        _deviceID = nil;
        _process = nil;
        _sentence = nil;
        
    }
    
    return self;
}


- (NSPredicate *)processPredicate
{
    NSPredicate *processPredicate;
    
    if( _deviceID != nil) {
         processPredicate = [NSPredicate predicateWithFormat:@"deviceID == %@ or process == %@", _deviceID, @"All Process"];
    }
   
    
    return processPredicate;
}


- (NSPredicate *)logPredicate
{
    NSMutableArray *compoundPredicateArray = [[NSMutableArray alloc] init];
    
    if( _deviceID != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"deviceID == %@", _deviceID]];
    }
    if( _process != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"process == %@", _process]];
    }
    if( _sentence != nil) {
        _sentence = [NSString stringWithFormat:@".*%@.*", _sentence];
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"log matches %@", _sentence]];
    }
    if( !_logLevel[0]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Debug"]];
    }
    if( !_logLevel[1]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Info"]];
    }
    if( !_logLevel[2]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Notice"]];
    }
    if( !_logLevel[3]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Warning"]];
    }
    if( !_logLevel[4]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Error"]];
    }
    if( !_logLevel[5]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Critical"]];
    }
    if( !_logLevel[6]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Alert"]];
    }
    if( !_logLevel[7]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Emergency"]];
    }
    
    NSPredicate *logPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:compoundPredicateArray];
    
    //NSLog(@"%@", logPredicate);
    
    return logPredicate;
}


#pragma mark -


- (void)setDeviceID:(NSString *)aDeviceID
{
    _deviceID = aDeviceID;
}

- (void)setProcess:(NSString *)aProcess
{
    _process = aProcess;
}

- (void)setSentence:(NSString *)aSentence
{
    _sentence = aSentence;
}

- (BOOL *)logLevel
{
    return _logLevel;
}


@end
