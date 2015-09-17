//
//  EHAddBabyAlarmService.m
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddBabyAlarmService.h"

@implementation EHAddBabyAlarmService

-(void)addBabyAlarm:(EHBabyAlarmModel *)addBabyAlarmReq{
    if (addBabyAlarmReq == nil) {
        EHLogError(@"baby alarm is nil!");
        return;
    }
    self.itemClass = [EHBabyAlarmModel class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHAddBabyAlarmApiName params:[addBabyAlarmReq toDictionary] version:nil];
    


}

@end
