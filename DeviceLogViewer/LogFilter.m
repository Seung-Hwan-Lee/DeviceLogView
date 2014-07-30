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
    BOOL _logLevel[9];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if(self) {
        for(int i = 0 ; i < 9 ; i++)
        {
            _logLevel[i] = TRUE;
        }
        _deviceID = nil;
        _process = nil;
        _sentence = nil;
        _deviceName = nil;
        
    }
    
    return self;
}


- (NSPredicate *)processPredicate
{
    NSPredicate *processPredicate;
    
    if( _deviceID != nil && _deviceName != nil) {
         processPredicate = [NSPredicate predicateWithFormat:@"(device == %@ and deviceID == %@) or process == %@",_deviceName, _deviceID, @"All Process"];
    }
    
    return processPredicate;
}


- (NSPredicate *)logPredicate
{
    NSMutableArray *compoundPredicateArray = [[NSMutableArray alloc] init];
    
    if( _deviceID != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"deviceID == %@", _deviceID]];
    }
    if( _deviceName != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"device == %@", _deviceName]];
    }
    if( _process != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"process contains %@", _process]];
    }
    if( _sentence != nil) {
        NSString *regexString = [NSString stringWithFormat:@".*(%@).*",_sentence];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[regexString stringByReplacingOccurrencesOfString:@"&" withString:@".*"] options:0 error:nil];
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"log matches[cd] %@", [regex pattern]]];
    }
    if( !_logLevel[1]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Debug"]];
    }
    if( !_logLevel[2]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Info"]];
    }
    if( !_logLevel[3]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Notice"]];
    }
    if( !_logLevel[4]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Warning"]];
    }
    if( !_logLevel[5]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Error"]];
    }
    if( !_logLevel[6]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Critical"]];
    }
    if( !_logLevel[7]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Alert"]];
    }
    if( !_logLevel[8]) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"NOT (logLevel contains %@)", @"Emergency"]];
    }
    
    NSPredicate *logPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:compoundPredicateArray];
    
    
    return logPredicate;
}


#pragma mark -



- (BOOL *)logLevel
{
    return _logLevel;
}



@end
