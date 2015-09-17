//
//  EHBaseGeofenceRemindViewController.h
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGeofenceRemindModel.h"

@interface EHBaseGeofenceRemindViewController : KSViewController

@property (nonatomic, strong)EHGeofenceRemindModel *remindModel;

@property (nonatomic, assign)BOOL remindUpdated;

@end
