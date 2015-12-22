//
//  EHDeleteBabyUserService.m
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeleteBabyUserService.h"
#import "EHDeviceStatusCenter.h"

@implementation EHDeleteBabyUserService

- (void)deleteUsers:(NSArray*)userPhoneList ToAttentionBaby:(NSNumber*)babyId byAdmin:(NSString*)adminPhone
{
    if (babyId < 0 || adminPhone == nil || userPhoneList == nil) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHDeleteBabyUserApiName params:@{kEHBabyId:babyId, kEHGardianPhone:adminPhone, kEHFamilyPhoneList:userPhoneList} version:nil];
}
-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    [super modelDidFinishLoad:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:EHRemoteMessageNotification object:nil userInfo:nil];
    [EHDeviceStatusCenter sharedCenter].currentMessageType = [NSNumber numberWithLong:EHCurrentMessageType_systemMessage];
}
@end
