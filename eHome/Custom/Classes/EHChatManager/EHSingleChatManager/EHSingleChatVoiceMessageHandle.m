//
//  EHSingleChatVoiceMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatVoiceMessageHandle.h"
#import "MessageModel+EHMessageParse.h"
#import "EHChatMessageinfoModel.h"
#import "EHDeviceActionForMessage.h"
#import "EHSingleChatCacheManager.h"

@implementation EHSingleChatVoiceMessageHandle

-(void)sendRemoteMessageWithMessage:(EHSingleChatMessageModel*)chatMessagemodel{
    [super sendRemoteMessageWithMessage:chatMessagemodel];
    MessageModel *model = chatMessagemodel.model;
    // 如果是历史消息
    if (model.isHistoryMessage) {
        return;
    }
    if (model.msg == nil) {
        return;
    }
    [self sendChatVoiceMessageWithMessage:model.msg];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma send Message method
-(void)sendChatVoiceMessageWithMessage:(NSString*)message{
    if (message == nil) {
        return;
    }
    
    NSData* messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil || responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    EHChatMessageinfoModel* chatMessageModel = [EHChatMessageinfoModel modelWithJSON:[(NSDictionary*)responseObject objectForKey:@"message"]];
    [[EHSingleChatCacheManager sharedCenter] recieveBabyChatMessage:chatMessageModel];
    [EHDeviceActionForMessage sendDeviceAction];
}

@end
