//
//  EHEditBabyAlarmViewController.h
//  eHome
//
//  Created by jinmiao on 15/9/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseBabyAlarmViewController.h"

@interface EHEditBabyAlarmViewController : EHBaseBabyAlarmViewController

typedef void(^AlarmEditBlock)(EHBabyAlarmModel *alarmModel);
typedef void(^AlarmDeleteBlock)();



@property (strong,nonatomic) AlarmEditBlock editBlock;
@property (strong,nonatomic) AlarmDeleteBlock deleteBlock;


@end
