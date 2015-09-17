//
//  EHGetBabyListRsp.h
//  eHome
//
//  Created by louzhenhua on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "EHBabyFamilyPhone.h"

typedef NS_ENUM(NSInteger, EHBabySexType) {
    EHBabySexType_boy          = 1,
    EHBabySexType_girl         = 2,
};


@interface EHGetBabyListRsp : WeAppComponentBaseItem

@property(nonatomic, strong)NSString* authority;
@property(nonatomic, strong)NSNumber* babyAge;
@property(nonatomic, strong)NSString* babyHeadImage;
@property(nonatomic, strong)NSNumber* babyHeight;
@property(nonatomic, strong)NSNumber* babyWeight;
@property(nonatomic, strong)NSNumber* babyId;
@property(nonatomic, strong)NSString* babyName;
@property(nonatomic, strong)NSString* babyNickName;
@property(nonatomic, strong)NSString* devicePhoneNumber;
@property(nonatomic, strong)NSNumber* phoneLevel;
@property(nonatomic, strong)NSString* device_code;
@property(nonatomic, strong)NSString* relationShip;
@property(nonatomic, strong)NSNumber* babySex;
@property(nonatomic, strong)NSString* babyBirthDay;
@property(nonatomic, strong)NSNumber* baby_target_steps;
@property(nonatomic, strong)NSString* baby_creatTime;
@property(nonatomic, strong)NSDate*   babyDeviceStartUserDay;
@property (nonatomic,strong)NSNumber* device_status;
@property(nonatomic, strong)NSString* workMode;
@property(nonatomic, strong)NSArray<EHBabyFamilyPhone>*  devicePhoneList;

-(BOOL)isBabyInFamilyPhoneNumbers;

@end
