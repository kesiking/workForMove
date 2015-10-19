//
//  EHBabyAlarmEditViewController.h
//  eHome
//
//  Created by jinmiao on 15/9/29.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHBabyAlarmModel.h"


@interface EHBabyAlarmEditViewController : KSViewController

typedef void(^AlarmEditBlock)(EHBabyAlarmModel *alarmModel);



@property (strong,nonatomic) AlarmEditBlock editBlock;
@property (strong,nonatomic) AlarmEditBlock deleteBlock;
@property (strong,nonatomic) EHGetBabyListRsp *babyUser;
@property (strong,nonatomic) EHBabyAlarmModel *alarmModel;
@property (strong,nonatomic) NSMutableArray *babyAlarmList;
@property (assign,nonatomic) BOOL alarmUpdated;




@end
