//
//  EHRemoteOutOrInLineMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/8/12.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteOutOrInLineMessageHandle.h"
#import "EHDeviceStatusMessageModel.h"
#import "EHMessageHeader.h"

#define BABY_ONLINE_FLAG  (502)
#define BABY_OUTLINE_FLAG (501)

@implementation EHRemoteOutOrInLineMessageHandle

-(void)remoteMessageHandle:(EHMessageInfoModel *)messageInfoModel{
    [super remoteMessageHandle:messageInfoModel];
    if (self.remoteMessageCategory != EHMessageInfoCatergoryType_OutOrInLine) {
        return;
    }
    // to do
    if (messageInfoModel.babyId == nil || messageInfoModel.msgId == nil) {
        return;
    }
    
    // 判断是否过期，如果过期则不再发送消息
    if ([self isRemoteMessageTimeOverdue:messageInfoModel]) {
        return;
    }
    
    if ([self isDeviceBabyCurrentBabyWithMessageInfoModel:messageInfoModel]) {
        // 如果是当前宝贝 发送消息给状态栏展示并将头像变暗
        [self sendDeviceStatusUseEHMessageManagerWithMessageInfoModel:messageInfoModel];
    }else{
        // 如果不是当前宝贝 发送通知消息将相应头像变暗
        [self sendDeviceStatusUseNotificationWithMessageInfoModel:messageInfoModel];
    }
}

// 是否为当前选中宝贝的babyid
-(BOOL)isDeviceBabyCurrentBabyWithMessageInfoModel:(EHMessageInfoModel *)messageInfoModel{
    NSString* currentBabyId = [[EHBabyListDataCenter sharedCenter] currentBabyId];
    return currentBabyId && [currentBabyId integerValue] == [messageInfoModel.babyId integerValue];
}

// 是否在线
-(BOOL)isDeviceOnLineWithMessageInfoModel:(EHMessageInfoModel *)messageInfoModel{
    return [messageInfoModel.msgId integerValue] == BABY_ONLINE_FLAG;
}

// 是否离线
-(BOOL)isDeviceOutLineWithMessageInfoModel:(EHMessageInfoModel *)messageInfoModel{
    return [messageInfoModel.msgId integerValue] == BABY_OUTLINE_FLAG;
}

/*!
 *  @author 孟希羲, 15-08-15 13:08:48
 *
 *  @brief  利用EHMessageManager发送消息，可控制状态栏展示同时头像变暗，仅针对当前babyId
 *
 *  @param messageInfoModel EHMessageInfoModel对象
 *
 *  @since 1.0
 */
-(void)sendDeviceStatusUseEHMessageManagerWithMessageInfoModel:(EHMessageInfoModel *)messageInfoModel{
    EHDeviceStatusMessageModel* messageModel = [EHDeviceStatusMessageModel new];
    messageModel.deviceStatusModel = [EHDeviceStatusModel new];
    messageModel.sourceTarget = self.sourceView;
    if ([self isDeviceOnLineWithMessageInfoModel:messageInfoModel]) {
        /*在线消息*/
        messageModel.deviceStatusModel.device_status = [NSNumber numberWithInteger:EHDeviceStatus_OnLine];
    }else if([self isDeviceOutLineWithMessageInfoModel:messageInfoModel]){
        /*离线消息*/
        messageModel.deviceStatusModel.device_status = [NSNumber numberWithInteger:EHDeviceStatus_OutLine];
    }
    messageModel.deviceStatusModel.device_Message_type = EHDeviceStatusModelMessageType_OutOrInLine;
    [[EHMessageManager sharedManager] sendMessage:messageModel];
}

/*!
 *  @author 孟希羲, 15-08-15 13:08:06
 *
 *  @brief  利用系统的Notification发送消息通知
 *
 *  @param messageInfoModel EHMessageInfoModel对象
 *
 *  @since 1.0
 */
-(void)sendDeviceStatusUseNotificationWithMessageInfoModel:(EHMessageInfoModel *)messageInfoModel{
    if ([self isDeviceOnLineWithMessageInfoModel:messageInfoModel]) {
        /*在线消息*/
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyOnLineNotification object:nil userInfo:@{EHMESSAGE_BABY_ID_DATA:messageInfoModel.babyId}];
    }else if([self isDeviceOutLineWithMessageInfoModel:messageInfoModel]){
        /*离线消息*/
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyOutLineNotification object:nil userInfo:@{EHMESSAGE_BABY_ID_DATA:messageInfoModel.babyId}];
    }
}

@end
