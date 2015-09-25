//
//  EHBaseGeofenceRemindViewController.h
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGeofenceRemindModel.h"
#import "EHGetBabyListRsp.h"

typedef NS_ENUM(NSInteger, EHRemindStatusType) {
    EHRemindStatusTypeAdd = 0,
    EHRemindStatusTypeEdit,
};

@interface EHBaseGeofenceRemindViewController : KSViewController

@property (nonatomic, strong)EHGetBabyListRsp    *babyUser;

@property (nonatomic, strong)NSString            *geofenceName;

@property (nonatomic, strong)EHGeofenceRemindModel *remindModel;

@property (nonatomic, assign)BOOL remindUpdated;

@property (nonatomic, assign)EHRemindStatusType remindStatusType;

@end
