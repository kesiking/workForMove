//
//  EHDelBabyAlarmService.m
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDelBabyAlarmService.h"

@implementation EHDelBabyAlarmService

-(void)delBabyAlarm: (NSArray *)alarmList byBabyId:(NSNumber *)babyId andAdminPhone:(NSString *)adminPhone{
    self.needCache = NO;
    self.onlyUserCache = NO;
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHDeleteBabyAlarmApiName params:@{kEHBabyId:babyId, kEHGardianPhone:adminPhone, kEHBabyAlarmList:alarmList}version:nil];
        
}




//- (void)delBabyFamilyPhone:(NSArray*)phoneList andAdminPhone:(NSString*)adminPhone byBabyId:(NSNumber*)babyId
//{
//    // service 是否需要cache
//    self.needCache = NO;
//    self.onlyUserCache = NO;
//    self.jsonTopKey = @"responseData";
//    
//    [self loadItemWithAPIName:kEHDeleteBabyFamilyPhoneApiName params:@{kEHBabyId:babyId, kEHGardianPhone:adminPhone, kEHFamilyPhoneList:phoneList} version:nil];
//}



@end
