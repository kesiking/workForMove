//
//  EHSendRandomToManagerService.m
//  eHome
//
//  Created by louzhenhua on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSendRandomToManagerService.h"

@implementation EHSendRandomToManagerService

-(void)sendRandomNumToManager:(NSString*)adminPhone withUserPhone:(NSString*)userPhone andBabyNmae:(NSString*)babyName andBabyId:(NSNumber*)babyId
{
    if ([EHUtils isEmptyString:adminPhone]
        || [EHUtils isEmptyString:userPhone]
        || [EHUtils isEmptyString:babyName]) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHSendRandomToManagerApiName params:@{kEHGardianPhone:adminPhone, kEHUserPhone:userPhone, kEHBabyName:babyName, kEHBabyId: babyId} version:nil];
}

@end
