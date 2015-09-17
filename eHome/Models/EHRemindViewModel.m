//
//  EHRemindViewModel.m
//  eHome
//
//  Created by xtq on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemindViewModel.h"
#import "EHUtils.h"

@implementation EHRemindViewModel

- (instancetype)initWithGeofenceRemindModel:(EHGeofenceRemindModel *)model {
    self = [super init];
    if (self) {
        self.time = model.time;
        self.date = [EHUtils getWeekSelectedDaysStr:model.work_date];
        self.is_active = model.is_active;
        self.is_repeat = model.is_repeat;
    }
    return self;
}

- (instancetype)initWithBabyAlarmModel:(EHBabyAlarmModel *) babyAlarmModel{
    self = [super init];
    if (self) {
        self.time = babyAlarmModel.time;
        self.date = [EHUtils getWeekSelectedDaysStr:babyAlarmModel.work_date];
        self.is_active = babyAlarmModel.is_active;
        self.is_repeat = babyAlarmModel.is_repeat;
    }
    return self;
}


@end
