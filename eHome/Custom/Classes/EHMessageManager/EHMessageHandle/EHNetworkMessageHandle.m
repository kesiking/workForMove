//
//  EHNetworkMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/28.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHNetworkMessageHandle.h"
#import "EHNetworkMessageModel.h"

@implementation EHNetworkMessageHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (![messageModel isKindOfClass:[EHNetworkMessageModel class]]) {
        return NO;
    }
    return [super messageShouldHandle:messageModel];
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    EHNetworkMessageModel* networkMessage = (EHNetworkMessageModel*)messageModel;
    if (!networkMessage.isReachable && [self canAttentionViewShowWithMessageAttentionType:EHMessageAttentionType_DeviceHasNoNetWork]){
        [self setupAttentionViewWithMessage:UILOGIN_NETWORK_ERROR_MESSAGE];
    }else if([self getAttentionViewType] == EHMessageAttentionType_DeviceHasNoNetWork){
        [self removeAttentionView];
    }
    EHLogInfo(@"-----> %@",networkMessage);
}

-(void)setupAttentionViewWithMessage:(NSString*)message{
    EHMessageAttentionView* attentionView = [self getAttentionView];
    [self resetAttentionView];
    [attentionView setMessageIconShow:NO];
    attentionView.attentionViewClickedBlock = ^(void  ){
        // 点击后去设置界面
        if (IOS_VERSION >= 8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
        }
    };
    [attentionView setMessageInfo:message];
}

@end
