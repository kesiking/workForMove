//
//  EHMessageBasicHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageBasicHandle.h"

@implementation EHMessageBasicHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (![KSAuthenticationCenter isLogin]) {
        return NO;
    }
    self.messageModel = messageModel;
    return YES;
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    
}

-(BOOL)messageDidfinished:(EHMessageModel*)messageModel{
    return YES;
}

@end
