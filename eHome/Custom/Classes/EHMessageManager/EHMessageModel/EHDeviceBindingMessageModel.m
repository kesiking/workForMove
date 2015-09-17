//
//  EHDeviceBindingMessageModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceBindingMessageModel.h"
#import "EHMessageMaroc.h"

@implementation EHDeviceBindingMessageModel

-(void)configMessage{
    [super configMessage];
    self.type = kEHDeviceBindingMessageType;
    self.deviceBindingNumber = 0;
}

@end
