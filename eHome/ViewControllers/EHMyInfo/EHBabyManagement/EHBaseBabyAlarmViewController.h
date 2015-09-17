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
 *  围栏状态类型
 */
typedef NS_ENUM(NSInteger, EHGeofenceStatusType){
    /**
     *  围栏添加状态
     */
    EHGeofenceStatusTypeAdd = 0,
    /**
     *  围栏详情状态
     */
    EHGeofenceStatusTypeDetail,
};

@interface EHBaseBabyAlarmViewController : KSViewController

@property (strong,nonatomic) EHGetBabyListRsp *babyUser;
@property (strong,nonatomic) EHBabyAlarmModel *alarmModel;

@end
