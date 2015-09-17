//
//  EHInsertGeofenceReq.h
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHInsertGeofenceReq : WeAppComponentBaseItem

@property (nonatomic, strong) NSString *geofence_name;
@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;
@property (nonatomic, assign) int       geofence_radius;
@property (nonatomic, assign) int       creator_id;
@property (nonatomic, assign) int       baby_id;
@property (nonatomic, strong) NSString *geofence_address;

@end
