//
//  EHDeviceStatusMessageModel.h
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageModel.h"
#import "EHDeviceStatusModel.h"

@interface EHDeviceStatusMessageModel : EHMessageModel

// 设备状态
@property (nonatomic, strong) EHDeviceStatusModel * deviceStatusModel;

@end
