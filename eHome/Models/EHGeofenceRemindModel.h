//
//  EHGeofenceRemindModel.h
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHGeofenceRemindModel : WeAppComponentBaseItem

@property(nonatomic, strong) NSNumber * geofence_id;

@property(nonatomic, strong) NSNumber * geofence_baby_id;

@property(nonatomic, strong) NSString * time;

@property(nonatomic, strong) NSString * work_date;

@property(nonatomic, strong) NSNumber * is_active;

@property(nonatomic, strong) NSNumber * is_repeat;

@property(nonatomic, strong) NSString * uuid;


@end
