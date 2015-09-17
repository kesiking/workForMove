//
//  EHInsertGeofenceService.m
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHInsertGeofenceService.h"

@implementation EHInsertGeofenceService

- (void)insertGeofence:(EHInsertGeofenceReq *)geofenceInfo{
    if (geofenceInfo == nil) {
        EHLogError(@"geofenceInfo is nil!");
        return;
    }

    NSMutableDictionary *params = [[geofenceInfo toDictionary] mutableCopy];
    [params setObject:@"result" forKey:@"__jsonTopKey__"];
    [self loadItemWithAPIName:kEHInsertGeofenceApiName params:params version:nil];
}

@end
