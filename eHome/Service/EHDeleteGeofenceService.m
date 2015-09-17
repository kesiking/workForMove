//
//  EHDeleteGeofenceService.m
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeleteGeofenceService.h"

@implementation EHDeleteGeofenceService

- (void)deleteGeofenceByID:(NSNumber *)geofenceID{
    [self loadItemWithAPIName:kEHDeleteGeofenceApiName params:@{@"geofence_id":geofenceID,@"__jsonTopKey__":@"result"} version:nil];
}

@end
