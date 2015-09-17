//
//  EHGetGeofenceRemindService.h
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHGetGeofenceRemindService : KSAdapterService

- (void)getGeofenceRemindWithGeofenceID:(NSNumber *)geofence_id;

@end
