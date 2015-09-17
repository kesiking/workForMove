//
//  EHBabyBindingStatusListRsp.h
//  eHome
//
//  Created by jss on 15/9/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHBabyBindingStatusListRsp : WeAppComponentBaseItem
@property(nonatomic,strong) NSString *baby_status_id;
@property(nonatomic,strong) NSNumber *baby_id;
@property(nonatomic,strong) NSString *user_phone;
@property(nonatomic,strong) NSString *baby_status;
@property(nonatomic,strong) NSString *binding_time;
@property(nonatomic,strong) NSString *nick_name;
@property(nonatomic,strong) NSString *relationship;
@property(nonatomic,strong) NSString *head_imag_small;

@end
