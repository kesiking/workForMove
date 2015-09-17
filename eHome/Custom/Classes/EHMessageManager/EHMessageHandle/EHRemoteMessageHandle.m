//
//  EHRemoteMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteMessageHandle.h"
#import "EHRemoteMessageModel.h"
#import "EHRemoteMessageHandleFactory.h"

@interface EHRemoteMessageHandle(){
    EHRemoteBasicMessageHandle*     _messageHandle;
}

@end

@implementation EHRemoteMessageHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (![messageModel isKindOfClass:[EHRemoteMessageModel class]]) {
        return NO;
    }
    EHRemoteMessageModel* remoteMessage = (EHRemoteMessageModel*)messageModel;
    if (remoteMessage.remoteMessageInfo == nil) {
        EHLogError(@"----->  remote message has no remote message info");
        return NO;
    }
    return [super messageShouldHandle:messageModel];
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    EHRemoteMessageModel* remoteMessage = (EHRemoteMessageModel*)messageModel;
    NSUInteger category = [remoteMessage.remoteMessageInfo.category unsignedIntegerValue];
    EHRemoteBasicMessageHandle* messageHandle = [EHRemoteMessageHandleFactory getMessageHandleByCategory:category];
    messageHandle.sourceView = self.sourceView;
    messageHandle.messageModel = messageModel;
    [messageHandle remoteMessageHandle:remoteMessage.remoteMessageInfo];
    EHLogInfo(@"-----> %@",remoteMessage);
    
    _messageHandle = messageHandle;
}

-(BOOL)messageDidfinished:(EHMessageModel*)messageModel{
    if (_messageHandle != nil) {
        EHRemoteMessageModel* remoteMessage = (EHRemoteMessageModel*)messageModel;
        return [_messageHandle remoteMessageDidfinished:remoteMessage.remoteMessageInfo];
    }
    return [super messageDidfinished:messageModel];
}

@end
