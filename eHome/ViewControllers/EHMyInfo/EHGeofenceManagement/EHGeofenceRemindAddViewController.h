//
//  EHGeofenceRemindAddViewController.h
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseGeofenceRemindViewController.h"

typedef void(^RemindNeedAdd)(EHGeofenceRemindModel *remindModel);


@interface EHGeofenceRemindAddViewController : EHBaseGeofenceRemindViewController

@property (nonatomic, strong)RemindNeedAdd remindNeedAdd;           //由围栏添加状态进来时需要保存每次新设置的围栏再统一添加

@end
