//
//  EHDeviceStatusMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceStatusMessageHandle.h"
#import "EHDeviceStatusMessageModel.h"

@implementation EHDeviceStatusMessageHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (![messageModel isKindOfClass:[EHDeviceStatusMessageModel class]]) {
        return NO;
    }
    EHDeviceStatusMessageModel* deviceStatusMessage = (EHDeviceStatusMessageModel*)messageModel;
    if (deviceStatusMessage.deviceStatusModel == nil) {
        return NO;
    }
    return [super messageShouldHandle:messageModel];
}

-(void)handleMessage:(EHMessageModel*)messageModel{
    EHDeviceStatusMessageModel* deviceStatusMessage = (EHDeviceStatusMessageModel*)messageModel;
    [self handleDeviceOutOrInLineStatusMessage:messageModel];
    [self handleDeviceBatteryStatusMessage:messageModel];
    if([EHUtils isNotEmptyString:deviceStatusMessage.deviceStatusModel.device_description_info]) {
        // 离线状态 展示
        EHLogInfo(@"-----> 状态描述");
        if ([self canAttentionViewShowWithMessageAttentionType:EHMessageAttentionType_DeviceLowBattery]) {
            [self setupAttentionViewWithMessage:deviceStatusMessage.deviceStatusModel.device_description_info];
            return;
        }
    }
    if([self isDeviceStatusMessageOutLineWithDeviceStatusMessage:deviceStatusMessage]) {
        // 离线状态 展示
        EHLogInfo(@"-----> 离线状态");
        if ([self canAttentionViewShowWithMessageAttentionType:EHMessageAttentionType_DeviceOutLine]){
            [self setupAttentionViewWithMessage:@"宝贝的手表处于离网状态！"];
            return;
        }
    }
    if ([self isDeviceStatusMessageBatteryWithDeviceStatusMessage:deviceStatusMessage]){
        // 低电量 展示
        EHLogInfo(@"-----> 低电量警告");
        
        NSUInteger deviceKWH = [deviceStatusMessage.deviceStatusModel.device_kwh integerValue];
        
        NSString* message = @"宝贝的手表电量低于20%，请及时充电！";
        
        if (deviceKWH <= EHDeviceMiddleLowKwhNumber) {
            message = @"宝贝的手表电量不足10%，请及时充电！";
        }else if (deviceKWH <= 5){
            message = @"宝贝的手表电量不足5%，即将关机！";
        }
        
        if ([self canAttentionViewShowWithMessageAttentionType:EHMessageAttentionType_DeviceLowBattery]){
            [self setupAttentionViewWithMessage:message];
            return;
        }
    }
    if([self getAttentionViewType] == EHMessageAttentionType_DeviceLowBattery
             || [self getAttentionViewType] == EHMessageAttentionType_DeviceOutLine){
        [self removeAttentionView];
    }
    
}

-(BOOL)isDeviceStatusMessageOutLineWithDeviceStatusMessage:(EHDeviceStatusMessageModel*)deviceStatusMessage{
    if (deviceStatusMessage.deviceStatusModel.device_status == nil) {
        return NO;
    }
    return [deviceStatusMessage.deviceStatusModel.device_status integerValue] == EHDeviceStatus_OutLine && (EHDeviceStatusModelMessageType_OutOrInLine == deviceStatusMessage.deviceStatusModel.device_Message_type || EHDeviceStatusModelMessageType_All == deviceStatusMessage.deviceStatusModel.device_Message_type);
}

-(BOOL)isDeviceStatusMessageBatteryWithDeviceStatusMessage:(EHDeviceStatusMessageModel*)deviceStatusMessage{
    if (deviceStatusMessage.deviceStatusModel.device_kwh == nil) {
        return NO;
    }
    return [deviceStatusMessage.deviceStatusModel.device_kwh integerValue] <= EHDeviceLowKwhNumber && (EHDeviceStatusModelMessageType_Battery == deviceStatusMessage.deviceStatusModel.device_Message_type || EHDeviceStatusModelMessageType_All == deviceStatusMessage.deviceStatusModel.device_Message_type);
}

-(void)handleDeviceOutOrInLineStatusMessage:(EHMessageModel *)messageModel{
    
    EHDeviceStatusMessageModel* deviceStatusMessage = (EHDeviceStatusMessageModel*)messageModel;
    
    if (deviceStatusMessage.deviceStatusModel.device_status == nil) {
        return;
    }
    
    EHGetBabyListRsp* currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    
    if([deviceStatusMessage.deviceStatusModel.device_status integerValue] == EHDeviceStatus_OutLine) {
        // 从在线转为离线时发出消息，如果已经记录为离线，不做操作
        if (currentBabyUserInfo.device_status
            && [currentBabyUserInfo.device_status integerValue] == EHDeviceStatus_OnLine) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyOutLineNotification object:nil];
        }
    }else if ([deviceStatusMessage.deviceStatusModel.device_status integerValue] == EHDeviceStatus_OnLine) {
        // 从离线转为在线时发出消息，如果已经记录为在线，不做操作
        if (currentBabyUserInfo.device_status
            && [currentBabyUserInfo.device_status integerValue] == EHDeviceStatus_OutLine) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyOnLineNotification object:nil];
        }
    }
    currentBabyUserInfo.device_status = deviceStatusMessage.deviceStatusModel.device_status;
    
    EHBabyDeviceStatus* babyDeviceStatus = [[EHBabyListDataCenter sharedCenter] currentBabyDeviceStatus];
    babyDeviceStatus.device_status = currentBabyUserInfo.device_status;
}

-(void)handleDeviceBatteryStatusMessage:(EHMessageModel *)messageModel{
    EHDeviceStatusMessageModel* deviceStatusMessage = (EHDeviceStatusMessageModel*)messageModel;
    if ([self isDeviceStatusMessageBatteryWithDeviceStatusMessage:deviceStatusMessage] || [EHUtils isNotEmptyString:deviceStatusMessage.deviceStatusModel.device_description_info]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyLowBatteryNotification object:nil];
    }
}

-(void)setupAttentionViewWithMessage:(NSString*)message{
    EHMessageAttentionView* attentionView = [self getAttentionView];
    [self resetAttentionView];
    [attentionView setMessageIconShow:YES];
    [attentionView setMessageInfo:message];
}

@end
