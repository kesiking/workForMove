//
//  EHDeviceActionForMessage.m
//  eHome
//
//  Created by 孟希羲 on 15/7/20.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceActionForMessage.h"
#import "EHRemoteMessageTimeOverdueObject.h"
#import "EHDeviceStatusCenter.h"
#import <AudioToolbox/AudioToolbox.h>

#define sms_message_received_sound_id  (1007)

@implementation EHDeviceActionForMessage

+(void)sendRemoteMessageNotificationForMessage:(EHRemoteMessageModel*)messageModel{
    // 如果过期了则不做消息提醒
    if ([EHRemoteMessageTimeOverdueObject isRemoteMessageTimeOverdue:messageModel.remoteMessageInfo]) {
        return;
    }
    // 全局消息
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    if (messageModel.remoteMessageInfo) {
        [param setObject:messageModel.remoteMessageInfo forKey:@"remoteMessageInfo"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EHRemoteMessageNotification object:nil userInfo:param];
}

+(void)sendDeviceActionForMessage:(EHRemoteMessageModel*)messageModel{
    // 如果过期了则不做消息提醒
    if ([EHRemoteMessageTimeOverdueObject isRemoteMessageTimeOverdue:messageModel.remoteMessageInfo]) {
        return;
    }
    // 设备响应
    BOOL neednNoticeNotice = [[EHDeviceStatusCenter sharedCenter] neednNoticeNotice];
    if (!neednNoticeNotice) {
        return;
    }
    
    BOOL needShakeNotice = [[EHDeviceStatusCenter sharedCenter] needShakeNotice];
    BOOL needVoiceNotice = [[EHDeviceStatusCenter sharedCenter] needVoiceNotice];
    if (needShakeNotice) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (needVoiceNotice) {
        AudioServicesPlaySystemSound(sms_message_received_sound_id);
    }
}

@end
