//
//  EHDeviceStatusModel.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

typedef NS_ENUM(NSInteger, EHDeviceStatusModelMessageType) {
    EHDeviceStatusModelMessageType_All = 0,             // 默认为涵盖所有的信息
    EHDeviceStatusModelMessageType_Battery = 1,         // 电池电量
    EHDeviceStatusModelMessageType_OutOrInLine = 2,     // 离线
};
typedef NS_ENUM(NSInteger, EHCurrentMessageType) {
    EHCurrentMessageType_babyMessage = 1,         // 宝贝消息
    EHCurrentMessageType_systemMessage = 2,         // 系统消息
};
@interface EHDeviceStatusModel : WeAppComponentBaseItem

// 设备电量
@property (nonatomic, strong) NSNumber * device_kwh;
// 设备状态，是否在线
@property (nonatomic, strong) NSNumber * device_status;
// 设备未读消息
@property (nonatomic, strong) NSNumber * message_number;
// 最后一条消息的类型,用于不同消息类型的跳转
@property (nonatomic, strong) NSNumber * message_type;
// 设备描述文案
@property (nonatomic, strong) NSString * device_description_info;

@property (nonatomic, assign) EHDeviceStatusModelMessageType   device_Message_type;

@end
