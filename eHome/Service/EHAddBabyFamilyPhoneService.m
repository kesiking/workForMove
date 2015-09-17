//
//  EHAddBabyFamilyPhoneService.m
//  eHome
//
//  Created by louzhenhua on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddBabyFamilyPhoneService.h"

@implementation EHAddBabyFamilyPhoneService


- (void)addBabyFamilyPhone:(NSString*)phoneNo andPhoneName:(NSString*)phoneName andPhoneType:(NSString*)phoneType byBabyId:(NSNumber*)babyId
{
    self.itemClass = [EHBabyFamilyPhone class];
    
    // service 是否需要cache
    self.needCache = NO;
    self.onlyUserCache = NO;
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHAddBabyFamilyPhoneApiName params:@{kEHBabyId:babyId, kEHAttentionPhone:phoneNo, kEHPhoneName:phoneName, kEHPhoneType:phoneType} version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    [super modelDidFinishLoad:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:EHRemoteMessageNotification object:nil userInfo:nil];
}

@end
