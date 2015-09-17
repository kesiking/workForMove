//
//  EHMessageManager.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageManager.h"
#import "EHMessageHandleFactory.h"
#import "EHMessageAttentionView.h"
#import "EHMessageOperationQueue.h"

@interface EHMessageManager()

@property (nonatomic, strong) NSMutableDictionary* messageDidHandelDict;

@end

@implementation EHMessageManager

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    self.messageDidHandelDict = [NSMutableDictionary dictionary];
}

-(void)dealloc{
    
}

-(void)sendMessage:(EHMessageModel*)messageModel{
    // to do send message
    if (messageModel == nil || messageModel.type == nil) {
        EHLogError(@"message is wrong");
        return;
    }
    // 消息分发
    EHMessageBasicHandle* messageHandel = [EHMessageHandleFactory getMessageHandleByType:messageModel.type];
    if (messageModel.sourceTarget == nil) {
        messageModel.sourceTarget = self.sourceTarget;
    }
    if (messageHandel && [messageHandel messageShouldHandle:messageModel]) {
        [messageHandel handleMessage:messageModel];
        if (![messageHandel messageDidfinished:messageModel]) {
            [[EHMessageOperationQueue sharedCenter] addMessageModel:messageModel];
        }else{
            [[EHMessageOperationQueue sharedCenter] messageHandelFinished:messageModel];
        }
    }
}

@end
