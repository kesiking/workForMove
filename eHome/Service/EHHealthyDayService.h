//
//  EHQueryBabyHealthyForDay.h
//  eHome
//
//  Created by jweigang on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyAdapterService.h"
#import "EHHealthyDayModel.h"
@interface EHHealthyDayService : EHHealthyAdapterService
- (void)queryBabyHealthyDataWithBabyId:(NSInteger)baby_id AndDate:(NSString *)date;
@end
