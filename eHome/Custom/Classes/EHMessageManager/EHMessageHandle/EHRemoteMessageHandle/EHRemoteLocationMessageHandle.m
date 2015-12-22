//
//  EHRemoteLocationMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteLocationMessageHandle.h"
#import "EHDeviceStatusCenter.h"

#define categoryInfoShowSecond (6.0)

@implementation EHRemoteLocationMessageHandle

-(void)remoteMessageHandle:(EHMessageInfoModel *)messageInfoModel{
    [super remoteMessageHandle:messageInfoModel];
    // 判断是否合法，如果不合法则不再发送消息
    if (![self isRemoteMessageLogical:messageInfoModel]) {
        return;
    }
    if (self.remoteMessageCategory == EHMessageInfoCatergoryType_Location) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyLocationNotification object:nil userInfo:@{@"babyId":messageInfoModel.babyId}];
        
        // to do
        NSString* subMessageInfo = messageInfoModel.info;
        if (messageInfoModel.trigger_name) {
            NSRange range = [messageInfoModel.info rangeOfString:messageInfoModel.trigger_name];
            if (range.location != NSNotFound) {
                subMessageInfo = [messageInfoModel.info substringFromIndex:range.location];
            }
        }
        EHGetBabyListRsp *babyListRsp = [[EHBabyListDataCenter sharedCenter] getBabyListRspWithBabyId:messageInfoModel.babyId];
        NSString* messageTriggerName = babyListRsp.babyNickName;
        if (!messageTriggerName) {
            messageTriggerName = messageInfoModel.trigger_name?[NSString stringWithFormat:@"%@",messageInfoModel.trigger_name]:messageInfoModel.recipient;
        }
        NSString* messageInfo = subMessageInfo?:[NSString stringWithFormat:@"%@进出围栏消息！",messageTriggerName];
        if (![KSAuthenticationCenter isTestAccount]){
#ifdef EH_USE_NAVIGATION_NOTIFICATION
            BOOL neednNoticeNotice = [[EHDeviceStatusCenter sharedCenter] neednNoticeNotice];
            if (neednNoticeNotice) {
                [MPNotificationView notifyWithText:messageTriggerName
                                            detail:messageInfo
                                             image:nil
                                          duration:categoryInfoShowSecond
                                     andTouchBlock:^(MPNotificationView *notificationView) {
                                         EHLogInfo(@"-----> Received touch for notification with text: %@ %@", notificationView.textLabel.text,notificationView.detailTextLabel.text);
                                     }];
            }
#else
            [WeAppToast toast:messageInfo toView:[[UIApplication sharedApplication] keyWindow] displaytime:categoryInfoShowSecond];
#endif
        }
    }
}

@end
