//
//  EHInviteBabyUserService.m
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHInviteBabyUserService.h"

@implementation EHInviteBabyUserService

- (void)inviteUser:(NSString*)userPhone ToAttentionBaby:(NSInteger)babyId byAdmin:(NSString*)adminPhone
{
    if (babyId < 0 || adminPhone == nil || userPhone == nil) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHInviteBabyUserApiName params:@{kEHBabyId:[NSNumber numberWithInteger:babyId], kEHGardianPhone:adminPhone, kEHUserPhone:userPhone} version:nil];
}
@end
