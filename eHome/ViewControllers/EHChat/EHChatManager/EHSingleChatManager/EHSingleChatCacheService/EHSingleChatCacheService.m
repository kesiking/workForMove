//
//  EHSingleChatCacheService.m
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatCacheService.h"

@implementation EHSingleChatCacheService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheStrategy.strategyType = KSCacheStrategyTypeInsert;
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark- common method

-(NSString*)getTableNameFromApiName:(NSString*)apiName withParam:(NSDictionary *)param{
    NSString* babyID = [NSString stringWithFormat:@"%@",[param objectForKey:@"baby_id"]];
    return [EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID];
}

+(NSString*)getSingleChatCacheTableNameWithBabyID:(NSString*)babyID{
    NSString* tableName = EHSingleChatCacheDefaultTableName;
    
    NSString* userPhone = [KSAuthenticationCenter userPhone];
    
    if (userPhone) {
        tableName = [tableName stringByAppendingFormat:@"_%@",userPhone];
    }
    
    if (babyID) {
        tableName = [tableName stringByAppendingFormat:@"_%@",babyID];
    }
    
    return tableName;
}

@end
