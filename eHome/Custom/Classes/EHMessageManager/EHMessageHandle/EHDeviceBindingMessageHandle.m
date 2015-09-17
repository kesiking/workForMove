//
//  EHDeviceBindingMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceBindingMessageHandle.h"
#import "EHDeviceBindingMessageModel.h"
#import "EHMessageAttentionView.h"

@implementation EHDeviceBindingMessageHandle

static NSMutableDictionary* dict = nil;

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    if (![messageModel isKindOfClass:[EHDeviceBindingMessageModel class]]) {
        return NO;
    }
//    if ([KSAuthenticationCenter userPhone]) {
//        // 如果已经展示过就不再展示
//        NSString* deviceBindingMessageDidShow = [dict objectForKey:[KSAuthenticationCenter userPhone]];
//        if (deviceBindingMessageDidShow) {
//            return NO;
//        }
//    }
    return [super messageShouldHandle:messageModel];
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    EHDeviceBindingMessageModel* deviceBindingMessage = (EHDeviceBindingMessageModel*)messageModel;
    if (deviceBindingMessage.deviceBindingNumber == 0) {
        // 展示没有绑定手表
        if ([self canAttentionViewShowWithMessageAttentionType:EHMessageAttentionType_DeviceBinding]){
            EHMessageAttentionView* attentionView = [self getAttentionView];
            [self resetAttentionView];
            [attentionView setMessageIconShow:NO];
            __typeof(self.sourceView) __weak __block weakSourceView = self.sourceView;
            attentionView.attentionViewClickedBlock = ^(void  ){
                __typeof(self.sourceView) __strong strongSourceView = weakSourceView;
                // 校验登录，未登录先弹出登录界面
                [[KSAuthenticationCenter sharedCenter] authenticateWithAlertViewMessage:LOGIN_ALERTVIEW_MESSAGE LoginActionBlock:^(BOOL loginSuccess) {
                    TBOpenURLFromSourceAndParams(internalURL(kEHBabyAtteintion), strongSourceView, nil);
                } cancelActionBlock:nil source:strongSourceView];
            };
            [attentionView setMessageInfo:@"您尚未关注宝贝，点击进行添加"];
        }
    }else if([self getAttentionViewType] == EHMessageAttentionType_DeviceBinding){
        [self removeAttentionView];
    }
}

@end
