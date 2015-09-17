//
//  EHMapOverLayServiceContainer.h
//  eHome
//
//  Created by 孟希羲 on 15/7/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapServiceContainer.h"
#import "EHGetGeofenceListService.h"

@interface EHMapOverLayServiceContainer : EHMapServiceContainer{
    EHGetGeofenceListService        *_geofencelistService;
}

@property (nonatomic, strong) EHGetGeofenceListService    *geofencelistService;

@property (nonatomic, strong) NSMutableArray *            geofenceOverLayArray;

@property (nonatomic, strong) NSMutableArray *            geofenceOverLayPointAnnotationArray;

-(void)loadGeofenceListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo;

-(void)resetMapGeoFenceOverLay;

@end
