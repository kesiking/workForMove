//
//  EHGetHealthyWeekInfoService.h
//  eHome
//
//  Created by 钱秀娟 on 15/7/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyAdapterService.h"
#import "EHGetHealthyWeekInfoRsp.h"

@interface EHGetHealthyWeekInfoService : EHHealthyAdapterService
-(void)getHealthWeekInfowithBabyID:(NSInteger)babyID date:(NSString*)date type:(NSString*)type;
@end