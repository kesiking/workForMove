//
//  EHMessageInfoModel.h
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

typedef NS_ENUM(NSInteger, EHMessageInfoCatergoryType) {
    EHMessageInfoCatergoryType_Battery = 1,       // 电池电量
    EHMessageInfoCatergoryType_Family,        // 家庭
    EHMessageInfoCatergoryType_Location,      // 位置
    EHMessageInfoCatergoryType_SOS,           // SOS
    EHMessageInfoCatergoryType_OutOrInLine,   // 离线
    EHMessageInfoCatergoryType_Family_ChangeBabyPhone = 2090,   // 换卡提醒
};

@interface EHMessageInfoModel : WeAppComponentBaseItem

@property (nonatomic,strong) NSString *        message_time;
@property (nonatomic,strong) NSString *        trigger_name;
@property (nonatomic,strong) NSString *        geofence_name;
@property (nonatomic,strong) NSString *        info;
@property (nonatomic,strong) NSNumber *        msgId;
@property (nonatomic,strong) NSNumber *        babyId;
@property (nonatomic,strong) NSNumber *        category;
@property (nonatomic,strong) NSNumber *        dataCounts;
// for remote message
@property (nonatomic,strong) NSString *        recipient;
@property (nonatomic,strong) NSString *        sender;
@property (nonatomic,strong) NSString *        submessage;

@end
