//
//  EHUnBindBabyService.m
//  eHome
//
//  Created by louzhenhua on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUnBindBabyService.h"

@implementation EHUnBindBabyService

-(void)unBindBabyWithBabyId:(NSNumber*)babyId userId:(NSNumber*)userId
{
    [self loadItemWithAPIName:kEHUnBindBabyApiName params:@{@"baby_id":babyId, @"user_id":userId} version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    [[NSNotificationCenter defaultCenter] postNotificationName:EHUNBindBabySuccessNotification object:nil];
    [super modelDidFinishLoad:model];
}

@end
