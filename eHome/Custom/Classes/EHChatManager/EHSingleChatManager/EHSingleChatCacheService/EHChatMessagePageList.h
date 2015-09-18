//
//  EHChatMessagePageList.h
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSPageList.h"

typedef enum {
    EHChatMessageaginationDirectionNextPage = 0,                // 当前时间与timestamp
    EHChatMessagePaginationDirectionBetweenTimestampAndNow = 1, // 翻页 BeforeTimestamp之间的数据
}EHChatMessagePaginationDirection;

@interface EHChatMessagePageList : KSPageList

@end
