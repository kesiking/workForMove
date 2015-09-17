//
//  EHDeleteGeofenceRemindService.m
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeleteGeofenceRemindService.h"

@implementation EHDeleteGeofenceRemindService

- (void)deleteGeofenceRemind:(NSString *)geofenceUUID{
    if (geofenceUUID == nil) {
        EHLogError(@"geofenceUUID is nil!");
        return;
    }
    
    [self loadItemWithAPIName:kEHDeleteGeofenceRemindApiName params:@{@"uuid":geofenceUUID} version:nil];
}

@end
