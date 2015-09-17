//
//  EHUpdateGeofenceStatusService.m
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUpdateGeofenceStatusService.h"

@implementation EHUpdateGeofenceStatusService

- (void)updateGeofenceStatus:(NSArray *)geofenceStatus{
    [self loadItemWithAPIName:kEHUpdateStatusSwitchByGeofenceIdApiName params:@{@"list":geofenceStatus,@"__jsonTopKey__":@"result"} version:nil];
}

@end
