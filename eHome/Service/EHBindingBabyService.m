//
//  EHBindingBabyService.m
//  eHome
//
//  Created by 孟希羲 on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBindingBabyService.h"
#import "EHBindingBabyRsp.h"

@implementation EHBindingBabyService

-(void)bindingBabyWithDeviceCode:(NSString*)deviceCode userPhone:(NSString*)userPhone{
    if (userPhone == nil) {
        userPhone = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (deviceCode == nil
        || userPhone == nil) {
        return;
    }
    self.itemClass = [EHBindingBabyRsp class];
    self.jsonTopKey = @"responseData";
    [self loadItemWithAPIName:kEHBindingBabyApiName params:@{@"user_phone":userPhone,@"device_code":deviceCode} version:nil];
}

@end
