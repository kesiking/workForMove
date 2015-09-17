//
//  EHUpdateBabyUserService.m
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateBabyUserService.h"

@implementation EHUpdateBabyUserService

- (void)updateBabyUser:(EHBabyUser*)babyUser
{
    if (babyUser == nil) {
        EHLogError(@"baby user is nil!");
        return;
    }
    self.itemClass = [EHBabyUser class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHUpdateBabyUserApiName params:[babyUser toDictionary] version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    NSNumber* babyId = [model.params objectForKey:@"baby_id"];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    if ([babyId integerValue] == [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]) {
        [userInfo setObject:@YES forKey:EHFORCE_REFRESH_DATA];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EHUNBabyRelationChangedNotification object:nil userInfo:userInfo];
    [super modelDidFinishLoad:model];
}

@end
