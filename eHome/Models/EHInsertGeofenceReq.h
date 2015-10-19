//
//  EHInsertGeofenceReq.h
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHInsertGeofenceReq : WeAppComponentBaseItem

@property (nonatomic, strong) NSString  *geofence_name;
@property (nonatomic, assign) CGFloat    latitude;
@property (nonatomic, assign) CGFloat    longitude;
@property (nonatomic, assign) NSInteger  geofence_radius;
@property (nonatomic, assign) NSInteger  creator_id;
@property (nonatomic, assign) NSInteger  baby_id;
@property (nonatomic, strong) NSString  *geofence_address;

@end
