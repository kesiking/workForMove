//
//  EHSingleChatCacheService.h
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterCacheService.h"

typedef NS_ENUM(NSInteger, EHMessageContextType) {
    EHMessageContextType_Text,      // 文字
    EHMessageContextType_Voice,     // 语音
    EHMessageContextType_Emotion,   // 表情
};

#define EHSingleChatCacheDefaultTableName @"SINGLE_CHAT_CACHE"

@interface EHSingleChatCacheService : KSAdapterCacheService

+(NSString*)getSingleChatCacheTableNameWithBabyID:(NSString*)babyID;

@end
