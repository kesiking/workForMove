//
//  EHAddBabyUserService.m
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddBabyUserService.h"

@implementation EHAddBabyUserService

- (void)addBabyUser:(EHBabyUser*)babyUser
{
    if (babyUser == nil) {
        EHLogError(@"baby user is nil!");
        return;
    }
    self.itemClass = [EHBabyUser class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHAddBabyUserApiName params:[babyUser toDictionary] version:nil];
}
@end
