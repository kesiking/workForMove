//
//  EHInsertGeofenceService.h
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHInsertGeofenceReq.h"

@interface EHInsertGeofenceService : KSAdapterService

- (void)insertGeofence:(EHInsertGeofenceReq *)geofenceInfo;

@end
