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
        
        NSString *currentChatBabyId = [[EHBabyListDataCenter sharedCenter] currentChatBabyId];
        NSData *historyData = [model.msg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:historyData options:NSJSONReadingMutableContainers error:&error];
        
        if (error != nil || responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        id historyMessage = [responseObject valueForKey:@"message"];
        if (historyMessage == nil || ![historyMessage isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSString *historyMsgBabyId = nil;
        if ([[historyMessage valueForKey:@"baby_id"] isKindOfClass: [NSNumber class]]) {
            historyMsgBabyId = [[historyMessage valueForKey:@"baby_id"] stringValue];
        }else if([[historyMessage valueForKey:@"baby_id"] isKindOfClass: [NSString class]]){
            historyMsgBabyId = [historyMessage valueForKey:@"baby_id"];
        }
        if (currentChatBabyId&&[currentChatBabyId isEqualToString:historyMsgBabyId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EHXiaoXiHistoryChatMessageNotification object:nil userInfo:@{@"historyMessage":historyMessage}];
        }

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
    
    // 方案一  如果是当前聊天宝贝才接受insert否则都不更新数据库，避免漏掉聊天数据
     NSString *currentChatBabyId = [[EHBabyListDataCenter sharedCenter] currentChatBabyId];
    if (currentChatBabyId != nil && [currentChatBabyId integerValue] == [chatMessageModel.baby_id integerValue]) {
        [[EHSingleChatCacheManager sharedCenter] recieveBabyChatMessage:chatMessageModel];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:EHRecieveUnselectedBabyChatMessageNotification object:nil userInfo:@{@"baby_id":chatMessageModel.baby_id}];
        [EHDeviceActionForMessage sendDeviceAction];
    }
}

@end
