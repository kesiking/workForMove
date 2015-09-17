//
//  EHGetHealthyMonthInfoRsp.m
//  eHome
//
//  Created by 钱秀娟 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetHealthyMonthInfoRsp.h"

@implementation EHGetHealthyMonthInfoRsp
-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    if ([self.responseData count] > 0) {
        EHHealthyMonthDataModel* monthDataModel = [self.responseData firstObject];
        self.beginTime = monthDataModel.beginTime;
        self.endTime = monthDataModel.endTime;
    }
}


+(NSString*)getPrimaryKey{
    return @"beginTime";
}

@end

@implementation EHHealthyMonthDataModel


@end

