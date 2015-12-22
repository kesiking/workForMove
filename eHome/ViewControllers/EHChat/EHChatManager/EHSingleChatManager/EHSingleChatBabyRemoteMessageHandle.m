//
//  EHSingleChatBabyRemoteMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatBabyRemoteMessageHandle.h"
#import "EHMessageManager.h"
#import "EHRemoteMessageModel.h"
#import "EHDeviceActionForMessage.h"

@implementation EHSingleChatBabyRemoteMessageHandle

-(void)sendRemoteMessageWithMessage:(EHSingleChatMessageModel*)chatMessagemodel{
    [super sendRemoteMessageWithMessage:chatMessagemodel];
    MessageModel *model = chatMessagemodel.model;
    if (model.msg == nil) {
        return;
    }
    [self sendBabyRemoteMessageWithMessage:model.msg];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma send Message method
-(void)sendBabyRemoteMessageWithMessage:(NSString*)message{
    if (message == nil) {
        return;
    }
    
    NSData* messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil || responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
        return;
    }
    // 消息转发，交由消息中心处理
    EHRemoteMessageModel* messageModel = [EHRemoteMessageModel new];
    messageModel.remoteMessageDict = responseObject;
    [[EHMessageManager sharedManager] sendMessage:messageModel];
    // 消息notification发送，device消息声音及震动
    [self sendRemoteMessageAction:messageModel];
    // 顶部消息框展示，这里写入将所有的信息都能展示
    /*
     [self sendMPNotificationMessage:messageModel];
     */
    // 本地推送
    /*
     [self sendLocalNotificationWithMessage:messageModel];
     */
}

// 本地推送
-(void)sendLocalNotificationWithMessage:(EHRemoteMessageModel*)messageModel{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification != nil) {
        NSDate *now = [NSDate date];
        notification.fireDate = [now dateByAddingTimeInterval:10];//10秒后通知
        notification.repeatInterval = 0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody = messageModel.remoteMessageInfo.info;//提示信息 弹出提示框
        
        NSDictionary *userInfo = @{@"aps":@{@"alert":messageModel.remoteMessageInfo.info?:@""}};
        notification.userInfo = userInfo; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)sendMPNotificationMessage:(EHRemoteMessageModel*)messageModel{
    [MPNotificationView notifyWithText:messageModel.remoteMessageInfo.trigger_name
                                detail:messageModel.remoteMessageInfo.info
                                 image:nil
                              duration:5.0
                         andTouchBlock:^(MPNotificationView *notificationView) {
                             EHLogInfo(@"-----> Received touch for notification with text: %@ %@", notificationView.textLabel.text,notificationView.detailTextLabel.text);
                         }];
}

-(void)sendRemoteMessageAction:(EHRemoteMessageModel*)messageModel{
    [EHDeviceActionForMessage sendRemoteMessageNotificationForMessage:messageModel];
    [EHDeviceActionForMessage sendDeviceActionForMessage:messageModel];
}

@end
