//
//  EHCancelAttentionBabyService.m
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHCancelAttentionBabyService.h"

@implementation EHCancelAttentionBabyService

-(void)cancelAttentionBaby:(NSInteger)babyId byBabyUser:(NSInteger)userId
{
    if (babyId < 0 || userId < 0) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHCancelBabyUserApiName params:@{kEHBabyId:[NSNumber numberWithInteger:babyId], kEHUserId:[NSNumber numberWithInteger:userId]} version:nil];
}
@end
