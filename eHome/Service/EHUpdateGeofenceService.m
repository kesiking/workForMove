//
//  EHUpdateGeofenceService.m
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateGeofenceService.h"

@implementation EHUpdateGeofenceService

- (void)updateGeofence:(EHGetGeofenceListRsp *)geofenceInfo{
    if (geofenceInfo == nil) {
        EHLogError(@"geofenceInfo is nil!");
        return;
    }
    NSMutableDictionary *params = [[geofenceInfo toDictionary] mutableCopy];
    [params setObject:@"result" forKey:@"__jsonTopKey__"];

    [self loadItemWithAPIName:kEHUpdateGeofenceApiName params:params version:nil];
}

@end
