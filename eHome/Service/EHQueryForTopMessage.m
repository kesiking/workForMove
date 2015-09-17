//
//  EHQueryForTopMessage.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHQueryForTopMessage.h"

@implementation EHQueryForTopMessage

-(void)queryForTopMessageWithUserPhone:(NSString *)userPhone
                                babyId:(NSString*)babyId{
    if (babyId == nil) {
        EHLogError(@"babyId is nil!");
        return;
    }
    if (userPhone == nil) {
        userPhone = [KSAuthenticationCenter userPhone];
    }
    if (userPhone == nil) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    
    self.itemClass = [EHDeviceStatusModel class];
    self.jsonTopKey = @"responseData";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"phone"];
    }
    if (babyId) {
        [params setObject:[NSNumber numberWithInteger:[babyId integerValue]] forKey:@"baby_id"];
    }
    [params setObject:@"result" forKey:@"__jsonTopKey__"];
    
    [self loadItemWithAPIName:kEHQueryForMessageNumberApiName params:params version:nil];
}

@end
