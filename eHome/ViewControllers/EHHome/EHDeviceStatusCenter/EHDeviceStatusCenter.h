//
//  EHDeviceStatusCenter.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHDeviceStatusModel.h"

typedef void (^didGetDeviceStatusBlock)       (EHDeviceStatusModel* deviceStatus);
typedef void (^getDeviceStatusFailBlock)      (void);

@interface EHDeviceStatusCenter : NSObject

@property (nonatomic,assign)  NSUInteger               second;

@property (nonatomic,strong)  CLLocation              *currentLocation;
@property (nonatomic,assign)  CLLocationCoordinate2D   currentPhoneCoordinate;

@property (nonatomic,copy  )  didGetDeviceStatusBlock  didGetDeviceStatus;

@property (nonatomic,copy  )  getDeviceStatusFailBlock getDeviceStatusFail;

+ (instancetype)sharedCenter;

- (BOOL)didGetCurrentLoaction;

- (NSString*)getCurrentBabyId;

- (void)setupDeviceCenterWithBabyId:(NSString*)babyId;

- (void)reset;

- (void)stop;

/*!
 *  @brief  needShakeNotice, needVoiceNotice, neednNoticeNotice 返回设置状态
 *
 *  @return 默认为YES
 *
 *  @since 1.0
 */
- (BOOL)needShakeNotice;

- (BOOL)needVoiceNotice;

- (BOOL)neednNoticeNotice;

@end
