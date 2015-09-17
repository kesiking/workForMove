//
//  EHGetBabyAttentionUsersRsp.h
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "EHBabyInfo.h"

@protocol EHBabyAttentionUser


@end


@interface EHBabyAttentionUserDetail : WeAppComponentBaseItem
//@property(nonatomic,strong)NSNumber* outPut_msg;
//@property(nonatomic,strong)NSNumber* outPut_status;
//@property(nonatomic,strong)NSString* outPut_time;
//@property(nonatomic,strong)NSNumber* message_number;
@property(nonatomic,strong)NSString* nick_name;
@property(nonatomic,strong)NSNumber* user_age;
@property(nonatomic,strong)NSString* user_head_img;
@property(nonatomic,strong)NSString* user_head_img_small;
@property(nonatomic,strong)NSNumber* user_id;
//@property(nonatomic,strong)NSString* user_last_login_time;
//@property(nonatomic,strong)NSString* user_password;
@property(nonatomic,strong)NSString* user_phone;
//@property(nonatomic,strong)NSString* user_reg_time;
@property(nonatomic,strong)NSNumber* user_sex;
@property(nonatomic,strong)NSNumber* user_status;
@property(nonatomic,strong)NSString* user_trueName;
@property(nonatomic,strong)NSNumber* user_type;
@end

@interface EHBabyAttentionUser : WeAppComponentBaseItem
@property(nonatomic,strong)NSString* authority;
@property(nonatomic,strong)NSString* relationship;
@property(nonatomic,strong)EHBabyAttentionUserDetail* user;
@end


@interface EHGetBabyAttentionUsersRsp : WeAppComponentBaseItem


@property(nonatomic, strong)NSArray<EHBabyInfo>*baby;

@property(nonatomic, strong)NSArray<EHBabyAttentionUser>*user;

//@property(nonatomic,strong)NSNumber* baby_id;
//@property(nonatomic,strong)NSString* baby_name;
//@property(nonatomic,strong)NSString* baby_head_imag;
//@property(nonatomic,strong)NSNumber* baby_height;
//@property(nonatomic,strong)NSNumber* baby_weight;
//@property(nonatomic,strong)NSNumber* baby_age;
//@property(nonatomic,strong)NSNumber* baby_sex;
//@property(nonatomic,strong)NSNumber* baby_target_steps;
//@property(nonatomic,strong)NSNumber* user_id;
//@property(nonatomic,strong)NSString* user_phone;
//@property(nonatomic,strong)NSString* user_password;
//@property(nonatomic,strong)NSString* user_trueName;
//@property(nonatomic,strong)NSString* user_reg_time;
//@property(nonatomic,strong)NSString* user_head_img;
//@property(nonatomic,strong)NSNumber* user_age;
//@property(nonatomic,strong)NSNumber* user_sex;
//@property(nonatomic,strong)NSNumber* user_type;
//@property(nonatomic,strong)NSNumber* user_status;
//@property(nonatomic,strong)NSString* user_last_login_time;
////outPut_msg
////outPut_status
////outPut_time
//@property(nonatomic,strong)NSString* nick_name;
//@property(nonatomic,strong)NSString* user_head_img_small;



@end
