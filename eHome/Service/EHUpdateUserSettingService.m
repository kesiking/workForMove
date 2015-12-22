//
//  EHUpdateUserSettingService.m
//  eHome
//
//  Created by louzhenhua on 15/11/10.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateUserSettingService.h"

@implementation EHUpdateUserSettingService


- (void)updateUserSetting:(EHUserSettingModel *)userSetting{
    if (userSetting == nil) {
        EHLogError(@"userSetting is nil!");
        return;
    }
    self.itemClass=[EHUserSettingModel class];
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:KEHSetUserSetting params:[userSetting toDictionary] version:nil];
}
@end
