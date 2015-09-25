//
//  EHGeofenceRemindEditViewController.h
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseGeofenceRemindViewController.h"

typedef void(^RemindNeedEdit)(EHGeofenceRemindModel *remindModel);

@interface EHGeofenceRemindEditViewController : EHBaseGeofenceRemindViewController

@property (nonatomic, strong)RemindNeedEdit remindNeedUpdate;

@property (nonatomic, strong)RemindNeedEdit remindNeedDelete;

@end
