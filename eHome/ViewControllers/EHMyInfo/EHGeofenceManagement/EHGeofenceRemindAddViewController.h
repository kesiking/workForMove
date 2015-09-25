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

@property (nonatomic, strong)RemindNeedAdd remindNeedAdd;

@end
