//
//  EHChatMessageTimestampCaculater.m
//  eHome
//
//  Created by 孟希羲 on 15/9/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessageTimestampCaculater.h"

static NSUInteger const showPromptGap = 300;

@interface EHChatMessageTimestampCaculater(){
    NSUInteger      _earliestDate;
    NSUInteger      _lastestDate;
}

@end

@implementation EHChatMessageTimestampCaculater

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastestDate = 0;
        _earliestDate = 0;
    }
    return self;
}

-(void)configChatMessageTimestampAfterChatlist:(NSArray*)chatlist{
    if (chatlist == nil || [chatlist count] == 0) {
        return;
    }
    [self checkAndConfigLastAndEarlyDataWithChatlist:chatlist];
    for (id messageInfoObj in chatlist)
    {
        XHBabyChatMessage* chatMessage = [self safeGetChatMessageWithMessageInfoObj:messageInfoObj];
        NSUInteger chatMessageTimestamp = chatMessage.msgTimestamp;
        if (chatMessageTimestamp - _lastestDate > showPromptGap)
        {
            chatMessage.needShowTimestamp = YES;
           _lastestDate = chatMessageTimestamp;
        }
    }
}

-(void)configChatMessageTimestampBeforChatlist:(NSArray*)chatlist{
    if (chatlist == nil || [chatlist count] == 0) {
        return;
    }
    [self checkAndConfigLastAndEarlyDataWithChatlist:chatlist];
    
    NSUInteger chatlistCount = [chatlist count];
    for (NSInteger index = chatlistCount - 1; index >= 0;index --)
    {
        id messageInfoObj = [chatlist objectAtIndex:index];
        XHBabyChatMessage* chatMessage = [self safeGetChatMessageWithMessageInfoObj:messageInfoObj];
        NSUInteger chatMessageTimestamp = chatMessage.msgTimestamp;
        if (_earliestDate - chatMessageTimestamp > showPromptGap)
        {
            chatMessage.needShowTimestamp = YES;
            _earliestDate = chatMessageTimestamp;
        }
    }
}

-(void)configChatMessageEarliestTimestampWithMessage:(XHBabyChatMessage*)chatMessage{
    if (chatMessage == nil) {
        return;
    }
    chatMessage.needShowTimestamp = YES;
    _earliestDate = chatMessage.msgTimestamp;
}

-(void)configChatMessageLastiestTimestampWithMessage:(XHBabyChatMessage*)chatMessage{
    if (chatMessage == nil) {
        return;
    }
    chatMessage.needShowTimestamp = YES;
    _lastestDate = chatMessage.msgTimestamp;
}

-(void)checkAndConfigLastAndEarlyDataWithChatlist:(NSArray*)chatlist{
    if (chatlist == nil || [chatlist count] == 0) {
        return;
    }
    
    if (_earliestDate == 0) {
        XHBabyChatMessage* chatMessage = [self safeGetChatMessageWithMessageInfoObj:[chatlist firstObject]];
        _earliestDate = chatMessage.msgTimestamp;
        chatMessage.needShowTimestamp = YES;
    }
    
    if (_lastestDate == 0) {
        XHBabyChatMessage* chatMessage = [self safeGetChatMessageWithMessageInfoObj:[chatlist firstObject]];
        _lastestDate = chatMessage.msgTimestamp;
    }
}

-(XHBabyChatMessage*)safeGetChatMessageWithMessageInfoObj:(id)messageInfoObj{
    if (messageInfoObj == nil) {
        return nil;
    }
    if ([messageInfoObj isKindOfClass:[EHChatMessageinfoModel class]]) {
        EHChatMessageinfoModel* messageInfoModel = messageInfoObj;
        return messageInfoModel.babyChatMessage;
    }else if([messageInfoObj isKindOfClass:[XHBabyChatMessage class]]){
        return ((XHBabyChatMessage*)messageInfoObj);
    }
    return nil;
}


@end
