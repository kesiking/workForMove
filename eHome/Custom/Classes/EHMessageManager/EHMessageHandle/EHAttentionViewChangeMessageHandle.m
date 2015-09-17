//
//  EHAttentionViewChangeMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAttentionViewChangeMessageHandle.h"
#import "EHAttentionMessageModel.h"

@implementation EHAttentionViewChangeMessageHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (![messageModel isKindOfClass:[EHAttentionMessageModel class]]) {
        return NO;
    }
    return [super messageShouldHandle:messageModel];
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    EHAttentionMessageModel* remoteMessage = (EHAttentionMessageModel*)messageModel;
    EHMessageAttentionView* attentionView = [self getAttentionView];
    if (remoteMessage.hideAttentionView) {
        attentionView.alpha = 0;
    }else{
        attentionView.alpha = 1;
    }
    EHLogInfo(@"-----> %@",remoteMessage);
}

@end
