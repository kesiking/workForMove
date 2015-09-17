//
//  EHGetGeofenceRemindService.m
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetGeofenceRemindService.h"
#import "EHGeofenceRemindModel.h"

@implementation EHGetGeofenceRemindService

- (void)getGeofenceRemindWithGeofenceID:(NSNumber *)geofence_id {
    self.jsonTopKey = @"responseData";
    self.itemClass = [EHGeofenceRemindModel class];
    
    [self loadDataListWithAPIName:kEHGetGeofenceRemindApiName params:@{@"geofence_id":geofence_id} version:nil];
}

@end
