//
//  EHAddBabyAlarmReq.h
//  eHome
//
//  Created by jinmiao on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHAddBabyAlarmReq : WeAppComponentBaseItem

@property (strong, nonatomic) NSNumber *baby_id;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) BOOL is_active;
@property (assign, nonatomic) BOOL is_repeat;
@property (strong, nonatomic) NSString *context;
@property (strong, nonatomic) NSNumber *clock_index;
@property (assign, nonatomic) BOOL is_site;


@end
