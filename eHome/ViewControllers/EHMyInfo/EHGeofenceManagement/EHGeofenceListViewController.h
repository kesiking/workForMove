//
//  EHGeofenceListViewController.h
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGetBabyListRsp.h"

typedef void (^GeofenceListCountDidChanged)(NSArray *geofenceList);

@interface EHGeofenceListViewController : KSViewController

@property (nonatomic, strong)NSArray *geofenceList;

@property (nonatomic, strong)GeofenceListCountDidChanged geofenceListCountDidChanged;

@property (nonatomic, strong)EHGetBabyListRsp* babyUser;

@property (nonatomic, strong)MAMapView *mapView;

@end
