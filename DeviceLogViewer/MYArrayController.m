//
//  MYArrayController.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 28..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "MYArrayController.h"

@implementation MYArrayController
{
    LogFilter *_logFilter;
    NSPredicate *_logPredicate;
    NSMutableArray *_allLogData;
}


- (id)init{
    if((self = [super init])) {
        _logFilter = nil;
        _allLogData = [[NSMutableArray alloc] init];
    }
    return self;

}



#pragma mark - set table object



- (void)addLogData:(id)aLogData
{
    if([_logPredicate evaluateWithObject:aLogData])
    {
        [super addObject:aLogData];
        [_allLogData addObject:aLogData];
    }
    else
    {
        [_allLogData addObject:aLogData];
    }
    
    
}

- (void)updatePredicate
{
    
    if ([_delegate respondsToSelector:@selector(beforChangingData)]) {
        [[self delegate] beforChangingData];
    }
    
    _logPredicate = [_logFilter logPredicate];
    [self removeArrangedLog];
    [super addObjects:[_allLogData filteredArrayUsingPredicate:_logPredicate]];
    
    if ([_delegate respondsToSelector:@selector(afterChangingData)]) {
        [[self delegate] afterChangingData];
    }
    
}

- (void)setLogFilter:(LogFilter *)aLogFilter
{
    _logFilter = aLogFilter;
    [self updatePredicate];
}




#pragma mark - remove object



- (void)removeAllLog
{
    if ([_delegate respondsToSelector:@selector(beforChangingData)]) {
        [[self delegate] beforChangingData];
    }
    
    [[super content] removeAllObjects];
    [_allLogData removeAllObjects];
    
    if ([_delegate respondsToSelector:@selector(afterChangingData)]) {
        [[self delegate] afterChangingData];
    }
    
}

- (void)removeArrangedLog
{
    [[super content] removeAllObjects];
    
}







@end
