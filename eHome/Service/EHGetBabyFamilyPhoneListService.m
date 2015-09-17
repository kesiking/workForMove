//
//  EHGetBabyFamilyPhoneListService.m
//  eHome
//
//  Created by louzhenhua on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyFamilyPhoneListService.h"

@implementation EHGetBabyFamilyPhoneListService


- (void)getBabyFamilyPhoneListById:(NSNumber*)babyId
{
    self.itemClass = [EHBabyFamilyPhone class];
    
    // service 是否需要cache
    self.needCache = NO;
    self.onlyUserCache = NO;
    self.jsonTopKey = @"responseData";
    
    [self loadDataListWithAPIName:kEHGetBabyFamilyPhoneApiName params:@{kEHBabyId : babyId, kEHUserId : [NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]]} version:nil];
}

@end
