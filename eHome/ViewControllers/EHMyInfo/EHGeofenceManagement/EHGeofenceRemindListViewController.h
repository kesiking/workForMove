//
//  EHGeofenceRemindListViewController.h
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGetBabyListRsp.h"
#import "EHBaseGeofenceRemindViewController.h"
#import "EHGeofenceRemindAddViewController.h"
#import "EHGeofenceRemindEditViewController.h"

typedef NS_ENUM(NSInteger, EHRemindListStatusType) {
    EHRemindListStatusTypeAdd = 0,
    EHRemindListStatusTypeUpdate,
    EHRemindListStatusTypeDelete,
};

@interface EHGeofenceRemindListViewController : KSViewController

@property (nonatomic, strong)NSNumber            *geofence_id;

@property (nonatomic, strong)EHGetBabyListRsp    *babyUser;

@property (nonatomic, strong)NSString            *geofenceName;

@end
