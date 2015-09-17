//
//  EHBabyAlarmModel.h
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHBabyAlarmModel : WeAppComponentBaseItem

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSNumber *baby_id;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *work_date;
@property (assign, nonatomic) NSNumber *is_active;
@property (assign, nonatomic) NSNumber *is_repeat;
@property (strong, nonatomic) NSString *context;
@property (strong, nonatomic) NSNumber *clock_index;
@property (assign, nonatomic) NSString *is_site;


@end
