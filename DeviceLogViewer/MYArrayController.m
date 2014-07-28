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

- (void)setLogFilter:(LogFilter *)aLogFilter
{
    _logFilter = aLogFilter;
    [self updatePredicate];
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


- (void)addObject:(id)object
{
    if([_logPredicate evaluateWithObject:object])
    {
        [super addObject:object];
        [_allLogData addObject:object];
    }
    else
    {
        [_allLogData addObject:object];
    }
    
    
}

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
