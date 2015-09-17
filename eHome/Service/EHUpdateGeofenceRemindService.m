//
//  EHUpdateGeofenceRemindService.m
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateGeofenceRemindService.h"

@implementation EHUpdateGeofenceRemindService

- (void)UpdateGeofenceRemind:(EHGeofenceRemindModel *)remindReq{
    if (remindReq == nil) {
        EHLogError(@"remindReq is nil!");
        return;
    }
    
    [self loadItemWithAPIName:kEHUpdateGeofenceRemindApiName params:[remindReq toDictionary] version:nil];
}

@end
