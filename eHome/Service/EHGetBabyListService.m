//
//  EHGetBabyListService.m
//  eHome
//
//  Created by louzhenhua on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyListService.h"

@implementation EHGetBabyListService

- (instancetype)init
{
    if (self = [super init]){
        self.itemClass = [EHGetBabyListRsp class];
    
        // service 是否需要cache
        self.needCache = NO;
        self.onlyUserCache = NO;
        self.jsonTopKey = @"responseData";
        return self;
    }
    
    return nil;
}

- (void)loadData{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ([KSAuthenticationCenter userPhone]) {
        [params setObject:[KSAuthenticationCenter userPhone] forKey:kEHUserPhone];
    }
    [self loadDataListWithAPIName:kEHGetThisUserAllBabys params:params version:nil];
}


@end
