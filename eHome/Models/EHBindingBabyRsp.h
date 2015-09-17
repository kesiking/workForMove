//
//  EHBindingBabyRsp.h
//  eHome
//
//  Created by louzhenhua on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "EHBabyInfo.h"

@interface EHbindBabyInfo : WeAppComponentBaseItem

@property (nonatomic, strong) EHBabyInfo* baby;
@property (nonatomic, strong) NSString* device_phone;

@end

@interface EHBindingBabyRsp : WeAppComponentBaseItem

//responseData =     {
//    "baby_info" =         {
//        baby =             {
//            "baby_age" = 6;
//            "baby_head_imag" = "http://112.54.207.8:9080/PersonSafeManagement/photo/18867102715_1432803927877.jpg";
//            "baby_height" = 80;
//            "baby_id" = 3;
//            "baby_name" = "xyj's son";
//            "baby_sex" = 1;
//            "baby_target_steps" = 10000;
//            "baby_weight" = 20;
//        };
//        "device_phone" = 18867101652;
//    };
//    "exist_gardian" = 1;
//    "gardian_phone" = 13758147971;
//};
//}
@property(nonatomic, strong)EHbindBabyInfo* baby_info;
@property(nonatomic, strong)NSNumber* exist_gardian;
@property(nonatomic, strong)NSString* gardian_phone;

@end


