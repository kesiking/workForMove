//
//  EHGetBabyAlarmService.h
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHBabyAlarmModel.h"

@interface EHGetBabyAlarmService : KSAdapterService

-(void)getBabyAlarmListById:(NSNumber *)babyId;

@end
