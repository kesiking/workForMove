//
//  EHAddBabyAlarmViewController.h
//  eHome
//
//  Created by jinmiao on 15/9/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseBabyAlarmViewController.h"
#import "EHBabyAlarmModel.h"
@interface EHAddBabyAlarmViewController : EHBaseBabyAlarmViewController

typedef void(^AlarmAddBlock)(EHBabyAlarmModel *alarmModel);

@property (copy, nonatomic) AlarmAddBlock addBlock;
@property (strong,nonatomic) NSMutableArray *babyAlarmList;



@end
