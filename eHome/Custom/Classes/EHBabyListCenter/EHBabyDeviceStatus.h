//
//  EHBabyDeviceStatus.h
//  eHome
//
//  Created by 孟希羲 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHBabyDeviceStatus : WeAppComponentBaseItem

@property (nonatomic, strong) NSNumber * babyId;
// 设备电量
@property (nonatomic, strong) NSNumber * device_kwh;
// 设备状态，是否在线
@property (nonatomic, strong) NSNumber * device_status;

@end
