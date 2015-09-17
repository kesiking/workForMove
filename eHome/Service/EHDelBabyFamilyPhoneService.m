//
//  EHDelBabyFamilyPhoneService.m
//  eHome
//
//  Created by louzhenhua on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDelBabyFamilyPhoneService.h"

@implementation EHDelBabyFamilyPhoneService


- (void)delBabyFamilyPhone:(NSArray*)phoneList andAdminPhone:(NSString*)adminPhone byBabyId:(NSNumber*)babyId
{
    // service 是否需要cache
    self.needCache = NO;
    self.onlyUserCache = NO;
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHDeleteBabyFamilyPhoneApiName params:@{kEHBabyId:babyId, kEHGardianPhone:adminPhone, kEHFamilyPhoneList:phoneList} version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    [super modelDidFinishLoad:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:EHRemoteMessageNotification object:nil userInfo:nil];
}

@end
