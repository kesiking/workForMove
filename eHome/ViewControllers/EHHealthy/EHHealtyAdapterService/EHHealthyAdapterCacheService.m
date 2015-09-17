//
//  EHHealthyAdapterCacheService.m
//  eHome
//
//  Created by 孟希羲 on 15/7/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyAdapterCacheService.h"

@implementation EHHealthyAdapterCacheService

-(NSString *)getTableNameFromApiName:(NSString *)apiName withParam:(NSDictionary *)param{
    NSString* tableName = [super getTableNameFromApiName:apiName withParam:param];
    if (!param) {
        return tableName;
    }
    NSString* type = [param objectForKey:@"type"];
    NSString* babyID = [NSString stringWithFormat:@"%@",[param objectForKey:@"baby_id"]];
    if (type) {
        tableName = [tableName stringByAppendingFormat:@"_%@",type];
    }
    if (babyID) {
        tableName = [tableName stringByAppendingFormat:@"_%@",babyID];
    }
    return tableName;
}

@end
