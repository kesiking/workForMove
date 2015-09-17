//
//  EHDeviceStatusMessageModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceStatusMessageModel.h"
#import "EHMessageMaroc.h"

@implementation EHDeviceStatusMessageModel

-(void)configMessage{
    [super configMessage];
    self.type = kEHDeviceStatusMessageType;
}

@end
