//
//  EHSingleChatVoiceMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatVoiceMessageHandle.h"
#import "MessageModel+EHMessageParse.h"

@implementation EHSingleChatVoiceMessageHandle

-(void)sendRemoteMessageWithMessage:(EHSingleChatMessageModel*)chatMessagemodel{
    [super sendRemoteMessageWithMessage:chatMessagemodel];
    MessageModel *model = chatMessagemodel.model;
    // 如果是历史消息
    if (model.isHistoryMessage) {
        return;
    }
    
}

@end
