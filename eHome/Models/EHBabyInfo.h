//
//  EHBabyInfo.h
//  eHome
//
//  Created by louzhenhua on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHBabyInfo

@end

@interface EHBabyInfo : WeAppComponentBaseItem

@property (nonatomic, strong) NSNumber* baby_id;
@property (nonatomic, strong) NSString * baby_name;
@property (nonatomic, strong) NSString * baby_head_imag;
@property (nonatomic, strong) NSNumber * baby_height;
@property (nonatomic, strong) NSNumber * baby_weight;
@property (nonatomic, strong) NSNumber * baby_age;
@property (nonatomic, strong) NSNumber * baby_sex;
@property (nonatomic, strong) NSNumber * baby_target_steps;
@property (nonatomic, strong) NSString * baby_birthDay;

@end
