//
//  EHInsertGeofenceRemindService.m
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHInsertGeofenceRemindService.h"

@implementation EHInsertGeofenceRemindService

- (void)insertGeofenceRemind:(EHGeofenceRemindModel *)remindReq{
    if (remindReq == nil) {
        EHLogError(@"remindReq is nil!");
        return;
    }
    
    [self loadItemWithAPIName:kEHInsertGeofenceRemindApiName params:[remindReq toDictionary] version:nil];
}

@end
