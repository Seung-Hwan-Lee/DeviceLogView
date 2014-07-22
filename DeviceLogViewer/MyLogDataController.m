//
//  MyLogDataController.m
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 21..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import "MyLogDataController.h"

@implementation MyLogDataController
{
    NSMutableArray *_updateData;
}

- (id)init
{
    self = [super init];
    if(self) {
        _updateData = [[NSMutableArray alloc] init];
        _isUpdateTable = YES;
    }
    
    return self;
}

- (void)addObject:(id)object
{
    [_updateData addObject:object];
    if(_isUpdateTable)
    {
        [self updateArrayController];
    }
}

- (void) updateArrayController
{
    for(int i = 0 ; i < [_updateData count] ; i ++)
    {
        [super addObject:[_updateData objectAtIndex:i]];
    }
    [_updateData removeAllObjects];
}

@end
