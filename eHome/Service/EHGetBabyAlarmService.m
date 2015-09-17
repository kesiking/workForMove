//
//  EHGetBabyAlarmService.m
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyAlarmService.h"

@implementation EHGetBabyAlarmService

-(void)getBabyAlarmListById:(NSNumber *)babyId{
    self.itemClass = [EHBabyAlarmModel class];
    
    // service 是否需要cache
    self.needCache = NO;
    self.onlyUserCache = NO;
    self.jsonTopKey = @"responseData";
    
    [self loadDataListWithAPIName:kEHGetBabyAlarmApiName params:@{kEHBabyId : babyId} version:nil];

}


@end
