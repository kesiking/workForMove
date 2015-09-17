//
//  EHBaseGeofenceViewController.h
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGetBabyListRsp.h"
#import "EHRadiusSliderView.h"
#import "EHGeofenceTopView.h"

@interface EHBaseGeofenceViewController : KSViewController

@property (nonatomic, strong)EHGetBabyListRsp *babyUser;        //baby信息

@property (nonatomic, strong)MAMapView *mapView;                //地图

@property (nonatomic, strong)EHGeofenceTopView *topView;        //顶部视图

@property (nonatomic, strong)EHRadiusSliderView *sliderView;    //底部滑动视图

@property(nonatomic, assign)CLLocationCoordinate2D geofenceCoordinate;  //围栏坐标

@property (nonatomic, assign)NSInteger radius;                  //围栏半径

@property (nonatomic, strong)UIButton *rightItemButton;         //导航栏右按钮

@property (nonatomic, assign)CGFloat neededZoomLevel;           //根据围栏设定的所需缩放级别

@property (nonatomic, assign)BOOL geofenceModifiedTag;          //围栏是否更新状态标记

@end
