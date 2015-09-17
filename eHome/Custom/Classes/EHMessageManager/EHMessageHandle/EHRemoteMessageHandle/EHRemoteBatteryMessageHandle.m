//
//  EHRemoteBatteryMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteBatteryMessageHandle.h"
#import "EHDeviceStatusMessageModel.h"
#import "EHMessageManager.h"

@implementation EHRemoteBatteryMessageHandle

-(void)remoteMessageHandle:(EHMessageInfoModel *)messageInfoModel{
    [super remoteMessageHandle:messageInfoModel];
    // 并非当前选中宝贝则不做任何操作
    if (messageInfoModel.babyId && [messageInfoModel.babyId integerValue] != [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]) {
        return;
    }
    // 判断是否过期，如果过期则不再发送消息
    if ([self isRemoteMessageTimeOverdue:messageInfoModel]) {
        return;
    }
    
    // 发送电量不足的消息
    if (self.remoteMessageCategory == EHMessageInfoCatergoryType_Battery) {
        // to do
        EHDeviceStatusMessageModel* messageModel = [EHDeviceStatusMessageModel new];
        messageModel.deviceStatusModel = [EHDeviceStatusModel new];
        if (messageInfoModel.info) {
            messageModel.deviceStatusModel.device_description_info = messageInfoModel.info;
        }else{
            messageModel.deviceStatusModel.device_kwh = [NSNumber numberWithInt:EHDeviceMiddleLowKwhNumber];
            messageModel.deviceStatusModel.device_status = [NSNumber numberWithInt:EHDeviceStatus_OnLine];
        }
        messageModel.deviceStatusModel.device_Message_type = EHDeviceStatusModelMessageType_Battery;
        [[EHMessageManager sharedManager] sendMessage:messageModel];
    }
}

@end
