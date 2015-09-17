//
//  EHEditBabyAlarmService.m
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHEditBabyAlarmService.h"

@implementation EHEditBabyAlarmService

-(void)editBabyAlarm:(EHBabyAlarmModel *)babyAlarm{
    if (babyAlarm == nil) {
        EHLogError(@"baby alarm is nil!");
        return;
    }
    self.itemClass = [EHBabyAlarmModel class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHEditBabyAlarmApiName params:[babyAlarm toDictionary] version:nil];
    
}


@end
