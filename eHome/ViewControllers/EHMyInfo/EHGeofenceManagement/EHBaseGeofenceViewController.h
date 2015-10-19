//
//  EHBaseGeofenceViewController.h
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGetBabyListRsp.h"
#import "EHGeofenceTopView.h"
#import "EHGetGeofenceListRsp.h"
#import "EHGeofenceNameView.h"
#import "EHGeofenceAddressView.h"
#import "EHRadiusSliderView.h"

@interface EHBaseGeofenceViewController : KSViewController

@property (nonatomic, strong) EHGetGeofenceListRsp *geofenceInfo;           //围栏信息

@property (nonatomic, strong) EHGetBabyListRsp *babyUser;                   //baby信息


@property (nonatomic, strong) MAMapView *mapView;                           //地图视图

@property (nonatomic, strong) EHGeofenceNameView *geofenceNameView;         //围栏名称视图

@property (nonatomic, strong) EHGeofenceAddressView *geofenceAddressView;   //围栏中心点视图

@property (nonatomic, strong) EHRadiusSliderView *sliderView;               //半径滑动条视图


@property (nonatomic, assign) CLLocationCoordinate2D geofenceCoordinate;    //围栏坐标

@property (nonatomic, strong) UIButton *rightItemButton;                    //导航栏右按钮

@property (nonatomic, assign) BOOL geofenceModifiedTag;                     //围栏是否更新状态标记

@end
