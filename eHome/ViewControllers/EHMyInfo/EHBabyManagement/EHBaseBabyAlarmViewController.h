//
//  EHBaseBabyAlarmViewController.h
//  eHome
//
//  Created by jinmiao on 15/9/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHBabyAlarmModel.h"

/**
 *  闹钟状态类型
 */
typedef NS_ENUM(NSInteger, EHBabyAlarmStatusType){
    /**
     *  闹钟添加状态
     */
    EHBabyAlarmStatusTypeAdd = 0,
    /**
     *  闹钟详情状态
     */
    EHBabyAlarmStatusTypeDetail,
};

@interface EHBaseBabyAlarmViewController : KSViewController

@property (strong,nonatomic) EHGetBabyListRsp *babyUser;
@property (strong,nonatomic) EHBabyAlarmModel *alarmModel;
@property (assign,nonatomic) EHBabyAlarmStatusType alarmStatusType;

@end
