//
//  EHUserDevicePosition.h
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

static NSString * const normal_LocationType = @"1";
static NSString * const SOS_LocationType = @"2";
static NSString * const current_LocationType = @"3";

typedef NS_ENUM(NSInteger, EHDeviceStatus) {
    EHDeviceStatus_OutLine          = 0,
    EHDeviceStatus_OnLine           = 1,
};

#define EHDeviceHighKwhNumber      (100)
#define EHDeviceMiddleLowKwhNumber (10)
#define EHDeviceLowKwhNumber       (20)


@interface EHUserDevicePosition : WeAppComponentBaseItem

@property (nonatomic, strong) NSNumber * positionId;
// 设备ID
@property (nonatomic, strong) NSNumber * device_code;
// 设备电量
@property (nonatomic, strong) NSNumber * device_kwh;
// 设备状态，是否在线
@property (nonatomic, strong) NSNumber * device_status;
// 位置经度
@property (nonatomic, strong) NSNumber * location_latitude;
// 位置纬度
@property (nonatomic, strong) NSNumber * location_longitude;
// 位置描述
@property (nonatomic, strong) NSString * location_Des;
// 定位时间
@property (nonatomic, strong) NSString * location_time;
// 定位精度
@property (nonatomic, strong) NSNumber * location_accurancy;
// 定位方式
@property (nonatomic, strong) NSString * location_method;
// 是否自动定位
@property (nonatomic, strong) NSNumber * location_auto;

//@property (nonatomic, assign) BOOL       location_caution;
// 位置信息
@property(nonatomic, strong)  NSString*  locationType;


@end
