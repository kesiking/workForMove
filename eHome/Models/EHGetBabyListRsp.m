//
//  EHGetBabyListRsp.m
//  eHome
//
//  Created by louzhenhua on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyListRsp.h"

@implementation EHGetBabyListRsp

static NSDateFormatter* inputFormatter = nil;

-(NSString *)babyNickName{
    NSString* babyNickName = [EHUtils isEmptyString:_babyNickName] ? _babyName : _babyNickName;
    return [self.authority boolValue] ? _babyName : babyNickName;
}

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    self.device_status = [NSNumber numberWithInteger:EHDeviceStatus_OnLine];
    
    if (inputFormatter == nil) {
        inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (self.baby_creatTime) {
        self.babyDeviceStartUserDay = [inputFormatter dateFromString:self.baby_creatTime];
    }
}

-(BOOL)isBabyInFamilyPhoneNumbers{
    if (self.devicePhoneNumber == nil || self.devicePhoneNumber.length == 0) {
        return YES;
    }
    NSString* phoneNumber = [KSAuthenticationCenter userPhone];
    if (phoneNumber == nil || phoneNumber.length == 0) {
        return NO;
    }
    if (self.devicePhoneList == nil || self.devicePhoneList.count == 0) {
        return NO;
    }
    for (EHBabyFamilyPhone* familyPhone in self.devicePhoneList) {
        if ([familyPhone.attention_phone isEqualToString:phoneNumber]) {
            return YES;
        }
    }
    return NO;
}

@end
