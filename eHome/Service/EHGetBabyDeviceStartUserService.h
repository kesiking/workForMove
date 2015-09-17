//
//  EHGetBabyDeviceStartUserService.h
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHGetBabyDeviceStartUserService : KSAdapterService

- (void)getBabyDeviceStartUserDayWithBabyId:(NSString*)babyId;

@end
