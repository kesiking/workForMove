//
//  EHRemindViewModel.h
//  eHome
//
//  Created by xtq on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "EHGeofenceRemindModel.h"
#import "EHBabyAlarmModel.h"

@interface EHRemindViewModel : WeAppComponentBaseItem

@property(nonatomic, strong) NSString *time;

@property(nonatomic, strong) NSString *date;

@property(nonatomic, strong) NSNumber *is_active;

@property(nonatomic, strong) NSNumber *is_repeat;

@property(nonatomic, strong) NSString *context;

- (instancetype)initWithGeofenceRemindModel:(EHGeofenceRemindModel *)model;
- (instancetype)initWithBabyAlarmModel:(EHBabyAlarmModel *) babyAlarmModel;

@end
