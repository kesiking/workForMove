//
//  EHChatMessagePaginationItem.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessagePaginationItem.h"

@implementation EHChatMessagePaginationItem

- (id)init {
    if (self = [super init]) {
        self.useTimesatmpAsReference = YES;
        self.paginationType = WeAppPaginationTypeTimeStamp;
        self.paginationTimestamp = WeAppPaginationTimestampAfter;
    }
    return self;
}

@end
