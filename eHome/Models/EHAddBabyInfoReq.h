//
//  EHAddBabyInfoReq.h
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHAddBabyInfoReq : WeAppComponentBaseItem

@property (nonatomic, strong) NSString * device_code;
@property (nonatomic, strong) NSString * baby_name;
@property (nonatomic, strong) NSString * baby_head_imag;
@property (nonatomic, strong) NSNumber* baby_height;
@property (nonatomic, strong) NSNumber* baby_weight;
@property (nonatomic, strong) NSNumber* baby_age;
@property (nonatomic ,strong) NSNumber* baby_sex; // 1：男 2：女


@end
