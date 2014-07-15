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
    BOOL _notice;
    BOOL _error;
    BOOL _warning;
    BOOL _debug;
    BOOL _emergency;
    BOOL _alert;
    BOOL _critical;
    BOOL _info;
    NSString *_process;
    NSString *_deviceID;
    NSString *_sentence;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if(self) {
        _notice = TRUE;
        _error = TRUE;
        _warning = TRUE;
        _debug = TRUE;
        _emergency = TRUE;
        _alert = TRUE;
        _critical = TRUE;
        _info = TRUE;
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
         processPredicate = [NSPredicate predicateWithFormat:@"deviceID contains %@ or process contains %@", _deviceID, @"All Process"];
    }
   
    
    return processPredicate;
}


- (NSPredicate *)logPredicate
{
    NSMutableArray *compoundPredicateArray = [[NSMutableArray alloc] init];
    
    if( _deviceID != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"deviceID contains %@", _deviceID]];
    }
    if( _process != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"process contains %@", _process]];
    }
    if( _sentence != nil) {
        [compoundPredicateArray addObject:[NSPredicate predicateWithFormat:@"log contains %@", _sentence]];
    }
    
    NSPredicate *logPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:compoundPredicateArray];
    
    //NSLog(@"%@", logPredicate);
    
    return logPredicate;
}


#pragma mark -


- (void)setNotice:(BOOL)aNotice
{
    _notice = aNotice;
}

- (void)setError:(BOOL)aError
{
    _error = aError;
}

- (void)setWarning:(BOOL)aWarning
{
    _warning = aWarning;
}

- (void)setDebug:(BOOL)aDebug
{
    _debug = aDebug;
}

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


@end
