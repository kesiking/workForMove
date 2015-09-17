//
//  EHDelBabyAlarmService.h
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHDelBabyAlarmService : KSAdapterService

// alarmList内存放dic：@{kEHAttentionPhone:188******, kEHPhoneType:@"0"}
-(void)delBabyAlarm: (NSArray *)alarmList byBabyId:(NSNumber *)babyId andAdminPhone:(NSString *)adminPhone;

@end
