//
//  EHGetGeofenceListRsp.h
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHGetGeofenceListRsp : WeAppComponentBaseItem

@property(nonatomic, assign)NSInteger geofence_id;
@property(nonatomic, strong)NSString* geofence_name;
@property(nonatomic, assign)CGFloat   latitude;
@property(nonatomic, assign)CGFloat   longitude;
@property(nonatomic, assign)NSInteger geofence_radius;
@property(nonatomic, strong)NSString* creat_time;
@property(nonatomic, strong)NSString* geofence_address;
@property(nonatomic, assign)NSInteger status_switch;

@end
