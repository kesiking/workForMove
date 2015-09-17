//
//  EHUpdateBabyInfoService.m
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateBabyInfoService.h"
#import "EHBabyInfo.h"


@implementation EHUpdateBabyInfoService

- (void)updateBabyInfo:(EHUpdateBabyInfoReq*)updateBabyRInfoeq
{
    if (updateBabyRInfoeq == nil) {
        EHLogError(@"baby info is nil!");
        return;
    }
    self.itemClass = [EHBabyInfo class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHUpdateBabyApiName params:[updateBabyRInfoeq toDictionary] version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    NSNumber* babyId = [model.params objectForKey:@"baby_id"];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    if ([babyId integerValue] == [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]) {
        [userInfo setObject:@YES forKey:EHFORCE_REFRESH_DATA];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyInfoChangedNotification object:nil userInfo:userInfo];
    [super modelDidFinishLoad:model];
}

@end
