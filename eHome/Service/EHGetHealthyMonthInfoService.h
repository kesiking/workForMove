//
//  EHGetHealthyMonthInfoService.h
//  eHome
//
//  Created by 钱秀娟 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyAdapterService.h"
#import "EHGetHealthyMonthInfoRsp.h"

@interface EHGetHealthyMonthInfoService : EHHealthyAdapterService
-(void)getHealthMonthInfoWithBabyID:(NSInteger)babyID date:(NSString*)date type:(NSString*)type;

@end
