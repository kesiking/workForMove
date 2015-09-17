//
//  EHDeviceStatusModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceStatusModel.h"

@implementation EHDeviceStatusModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.device_Message_type = EHDeviceStatusModelMessageType_All;
    }
    return self;
}

@end
