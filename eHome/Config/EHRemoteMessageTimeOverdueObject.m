//
//  EHRemoteMessageTimeOverdueObject.m
//  eHome
//
//  Created by 孟希羲 on 15/8/28.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteMessageTimeOverdueObject.h"

#define MINUTE_VALID_RANGE_NUMBER (10)

@implementation EHRemoteMessageTimeOverdueObject

+ (BOOL)isRemoteMessageTimeOverdue:(EHMessageInfoModel*)messageInfoModel{
    static NSDateFormatter* inputFormatter = nil;
    
    if (messageInfoModel == nil) {
        return NO;
    }
    
    if (messageInfoModel.message_time) {
        if (inputFormatter == nil) {
            inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate* inputDate = [inputFormatter dateFromString:messageInfoModel.message_time];
        double minutesAgo = inputDate.minutesAgo;
        // 如果与当前时间相比大于10分钟则返回已过期
        if (minutesAgo > MINUTE_VALID_RANGE_NUMBER) {
            return YES;
        }
    }
    return NO;
}

@end
