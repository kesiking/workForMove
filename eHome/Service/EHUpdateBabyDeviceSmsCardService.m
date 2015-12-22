//
//  EHUpdateBabyDeviceSmsCardService.m
//  eHome
//
//  Created by louzhenhua on 15/11/17.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateBabyDeviceSmsCardService.h"

@implementation EHUpdateBabyDeviceSmsCardService

- (void)updateBabyDeviceSmsCard:(NSString*)phoneNo byBabyId:(NSNumber *)babyid
{
    if ([EHUtils isEmptyString:phoneNo]) {
        EHLogError(@"phoneNo is nil!");
        return;
    }
    if (babyid == nil) {
        EHLogError(@"babyid is nil!");
        return;
    }
    
    self.jsonTopKey = @"responseData";
    
    [self loadItemWithAPIName:kEHUpdateBabyDeviceSmsCardApiName params:@{@"simCardId":phoneNo, @"baby_id":babyid} version:nil];

}

@end
