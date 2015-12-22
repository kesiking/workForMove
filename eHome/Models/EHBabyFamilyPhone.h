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


@property(nonatomic, strong)NSString* phoneNumber;//亲情电话
@property(nonatomic, strong)NSString* deviceCode;//设备编码
@property(nonatomic, strong)NSNumber* devicePhoneId;//亲情电话表ID
@property(nonatomic, strong)NSString* relationship;//电话昵称
@property(nonatomic, assign)NSInteger index;//亲情电话顺序

@end
