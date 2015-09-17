//
//  EHGetBabyAttentionUsersService.m
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyAttentionUsersService.h"
#import "EHGetBabyAttentionUsersRsp.h"

@implementation EHGetBabyAttentionUsersService

- (instancetype)init
{
    if (self = [super init]){
        self.itemClass = [EHGetBabyAttentionUsersRsp class];
        
        // service 是否需要cache
        self.needCache = NO;
        self.onlyUserCache = NO;
        self.jsonTopKey = @"responseData";
        return self;
    }
    
    return nil;
}

-(void)getThisBabyAllAttentionUsers:(NSNumber*)babyId
{
    if (babyId < 0) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHGetThisBabyAllUsersApiName params:@{kEHBabyId:babyId} version:nil];
}

@end
