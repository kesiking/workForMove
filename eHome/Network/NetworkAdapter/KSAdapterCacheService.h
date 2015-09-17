//
//  KSAdapterCacheService.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/3.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSCacheService.h"

@interface KSAdapterCacheService : KSCacheService

-(NSString*)getTableNameFromApiName:(NSString*)apiName withParam:(NSDictionary *)param;

@end
