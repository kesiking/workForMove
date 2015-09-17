//
//  EHSingleChatCacheService.h
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterCacheService.h"

#define EHSingleChatCacheDefaultTableName @"SINGLE_CHAT_CACHE"

@interface EHSingleChatCacheService : KSAdapterCacheService

+(NSString*)getSingleChatCacheTableNameWithBabyID:(NSString*)babyID;

@end
