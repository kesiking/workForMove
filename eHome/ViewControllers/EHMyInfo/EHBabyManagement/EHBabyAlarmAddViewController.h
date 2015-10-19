//
//  EHBabyAlarmAddViewController.h
//  eHome
//
//  Created by jinmiao on 15/9/29.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHBabyAlarmModel.h"

@interface EHBabyAlarmAddViewController : KSViewController

typedef void(^AlarmAddBlock)(EHBabyAlarmModel *alarmModel);

@property (strong,nonatomic) EHGetBabyListRsp *babyUser;
@property (strong,nonatomic) EHBabyAlarmModel *alarmModel;
@property (copy, nonatomic) AlarmAddBlock addBlock;
@property (strong,nonatomic) NSMutableArray *babyAlarmList;
@property (assign,nonatomic) BOOL alarmUpdated;


@end
