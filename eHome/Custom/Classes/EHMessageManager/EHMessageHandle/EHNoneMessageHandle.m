//
//  EHNoneMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHNoneMessageHandle.h"
#import "EHNoneMessageModel.h"

@implementation EHNoneMessageHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (![messageModel isKindOfClass:[EHNoneMessageModel class]]) {
        return NO;
    }
    return [super messageShouldHandle:messageModel];
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    EHNoneMessageModel* remoteMessage = (EHNoneMessageModel*)messageModel;
    if([self getAttentionViewType] != EHMessageAttentionType_DeviceHasNoNetWork){
        [self removeAttentionView];
    }
    EHLogInfo(@"-----> %@",remoteMessage);
}

@end
