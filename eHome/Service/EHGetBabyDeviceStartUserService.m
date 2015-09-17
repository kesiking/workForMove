//
//  EHGetBabyDeviceStartUserService.m
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyDeviceStartUserService.h"

@implementation EHGetBabyDeviceStartUserService

- (void)getBabyDeviceStartUserDayWithBabyId:(NSString*)babyId
{
    if (babyId == nil) {
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];

    if ([babyId isKindOfClass:[NSNumber class]]) {
        [params setObject:(NSNumber*)babyId forKey:@"baby_id"];
    }else{
        [params setObject:[NSNumber numberWithInteger:[babyId integerValue]] forKey:@"baby_id"];
    }

    [params setObject:@"result" forKey:@"__jsonTopKey__"];
    
    self.jsonTopKey = @"responseData";

    [self loadObjectValueWithAPIName:kEHGetBabyDeviceStartUserDayApiName params:params version:nil];
}

@end
