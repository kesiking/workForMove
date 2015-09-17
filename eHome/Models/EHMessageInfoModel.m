//
//  EHMessageInfoModel.m
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageInfoModel.h"

@implementation EHMessageInfoModel

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    if (self.info == nil && [dict objectForKey:@"message"] != nil) {
        self.info = [dict objectForKey:@"message"];
    }
    if (self.message_time == nil && [dict objectForKey:@"time"] != nil) {
        self.message_time = [dict objectForKey:@"time"];
    }
}

@end
