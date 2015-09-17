//
//  EHGetHealthyMonthInfoService.m
//  eHome
//
//  Created by 钱秀娟 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetHealthyMonthInfoService.h"

@implementation EHGetHealthyMonthInfoService
-(void)getHealthMonthInfoWithBabyID:(NSInteger)babyID date:(NSString*)date type:(NSString*)type{
    if (babyID < 0 || date == nil || type == nil) {
        return;
    }
    self.itemClass = [EHGetHealthyMonthInfoRsp class];
//    self.jsonTopKey = @"responseData";
//    self.needCache = NO;

    [self loadItemWithAPIName:kEHGetHealthyWeekMonthInfoApiName params:@{@"baby_id":[NSNumber numberWithInteger:babyID],@"date":date,@"type":type,@"__jsonTopKey__":@"result"} version:nil];

}@end
