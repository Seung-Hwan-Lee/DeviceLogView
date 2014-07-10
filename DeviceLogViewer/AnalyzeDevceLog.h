//
//  AnalyzeDevceLog.h
//  DeviceLogViewer
//
//  Created by LINEPLUS on 2014. 7. 10..
//  Copyright (c) 2014년 line. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadDeviceLog.h"
#import "LogData.h"

@interface AnalyzeDevceLog : ReadDeviceLog
{
    NSArrayController* logDataArr;
    NSMutableSet* processSet;
    NSMutableSet* deviceSet;
}

-(NSArrayController*) getLogDataArr;
-(void)setLogDataArr: (NSArrayController*)inLogDataArr;
-(NSMutableSet*) getProcessSet;
-(NSMutableSet*) getDeviceSet;
-(void) removeAllData;


-(id)init;

@end
