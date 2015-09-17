//
//  EHBabyFamilyPhone.h
//  eHome
//
//  Created by louzhenhua on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@protocol EHBabyFamilyPhone <NSObject>

@end

@interface EHBabyFamilyPhone : WeAppComponentBaseItem


@property(nonatomic, strong)NSString* attention_phone;
@property(nonatomic, strong)NSNumber* device_id;
@property(nonatomic, strong)NSNumber* device_phone_id;
@property(nonatomic, strong)NSString* phone_name;
@property(nonatomic, strong)NSString* phone_type;

@end
