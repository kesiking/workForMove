//
//  EHGetGeofenceListRsp.h
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHGetGeofenceListRsp : WeAppComponentBaseItem

@property(nonatomic, assign)int geofence_id;
@property(nonatomic, strong)NSString* geofence_name;
@property(nonatomic, assign)double latitude;
@property(nonatomic, assign)double longitude;
@property(nonatomic, assign)int geofence_radius;
@property(nonatomic, strong)NSString* creat_time;
@property(nonatomic, strong)NSString* geofence_address;
@property(nonatomic, assign)int status_switch;

@end
