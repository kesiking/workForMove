//
//  EHGetUserSettingService.m
//  eHome
//
//  Created by louzhenhua on 15/11/10.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHGetUserSettingService.h"
#import "EHUserSettingModel.h"
@implementation EHGetUserSettingService


- (void)getUserSetting:(NSNumber *)userId{
    if (userId == nil) {
        EHLogError(@"userId is nil!");
        return;
    }
    
    self.itemClass=[EHUserSettingModel class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:KEHGetUserSetting params:@{@"user_id":userId} version:nil];
}

@end
