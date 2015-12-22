//
//  EHSingleChatMessageBasicHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatMessageBasicHandle.h"

@implementation EHSingleChatMessageBasicHandle

-(void)sendRemoteMessageWithMessage:(EHSingleChatMessageModel*)chatMessagemodel{
    self.chatMessagemodel = chatMessagemodel;
}

@end
