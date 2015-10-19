//
//  EHBabyAlarmViewController.h
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHBabyAlarmAddViewController.h"
#import "EHBabyAlarmEditViewController.h"
#import "EHGetBabyListRsp.h"

typedef NS_ENUM(NSInteger, EHAlarmListStatusType) {
    EHAlarmListStatusTypeAdd = 0,
    EHAlarmListStatusTypeUpdate,
    EHAlarmListStatusTypeDelete,
};


@interface EHBabyAlarmViewController : KSViewController

@property (strong,nonatomic) EHGetBabyListRsp    *babyUser;
@property (strong,nonatomic) NSMutableArray *babyAlarmList;





@end
