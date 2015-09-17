//
//  EHAddBabyInfoService.m
//  eHome
//
//  Created by louzhenhua on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddBabyInfoService.h"
#import "EHBabyInfo.h"

@implementation EHAddBabyInfoService


- (void)addBabyInfo:(EHAddBabyInfoReq*)babyInfo
{
    if (babyInfo == nil) {
        EHLogError(@"baby info is nil!");
        return;
    }
    self.itemClass = [EHBabyInfo class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHAddBabyApiName params:[babyInfo toDictionary] version:nil];
}
@end
