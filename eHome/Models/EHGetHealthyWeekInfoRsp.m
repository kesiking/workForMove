//
//  EHGetHealthyWeekInfoRsp.m
//  eHome
//
//  Created by 钱秀娟 on 15/7/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetHealthyWeekInfoRsp.h"

@implementation EHGetHealthyWeekInfoRsp

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    self.monday = self.responseData.monday;
    self.sunday = self.responseData.sunday;
}

+(NSString*)getPrimaryKey{
    return @"monday";
}

@end
