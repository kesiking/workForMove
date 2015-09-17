//
//  EHBabyAlarmViewController.h
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHAddBabyAlarmViewController.h"
#import "EHEditBabyAlarmViewController.h"
#import "EHGetBabyListRsp.h"



@interface EHBabyAlarmViewController : KSViewController

@property (strong,nonatomic) EHGetBabyListRsp    *babyUser;
@property (strong,nonatomic) NSMutableArray *babyAlarmList;




@end
