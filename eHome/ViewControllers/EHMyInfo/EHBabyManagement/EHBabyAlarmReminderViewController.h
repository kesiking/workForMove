//
//  EHBabyAlarmReminderViewController.h
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"

@interface EHBabyAlarmReminderViewController : KSViewController

typedef void(^AlarmReminderEditBlock)(NSString *reminderContent);

@property (nonatomic, strong) NSNumber *babyId;
@property (nonatomic, copy) AlarmReminderEditBlock reminderEditBlock;
@property (nonatomic, strong) NSString *reminderContent;


@end
