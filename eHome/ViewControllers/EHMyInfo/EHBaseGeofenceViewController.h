//
//  EHBaseGeofenceViewController.h
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGetBabyListRsp.h"

@interface EHBaseGeofenceViewController : KSViewController

@property (nonatomic, strong)EHGetBabyListRsp *babyUser;        //baby信息

@property (nonatomic, strong)MAMapView *mapView;                //地图

@property(nonatomic, assign)CLLocationCoordinate2D centerCoordinate;    //中心坐标

@property(nonatomic, assign)CLLocationCoordinate2D geofenceCoordinate;  //围栏坐标

@property (nonatomic, strong)UIView *topView;                   //顶部视图

@property (nonatomic, strong)UIView *sliderView;                //底部滑动视图

@property (nonatomic, strong)UITextField *geofenceNameField;    //围栏名称视图

@property (nonatomic, strong)CAShapeLayer *lineLayer;           //名称视图底部横线图层

@property (nonatomic, strong)UILabel *addressLabel;             //围栏地址视图

@property (nonatomic, assign)NSInteger radius;                  //围栏半径

@property (nonatomic, strong)UIButton *rightItemButton;         //导航栏右按钮

@property (nonatomic, assign)CGFloat neededZoomLevel;           //根据围栏设定的所需缩放级别

@property (nonatomic, assign)BOOL geofenceModifiedTag;          //围栏是否更新状态标记

- (void)setGeofenceRadius:(NSInteger)radius;                    //设置围栏半径（包含UI）

- (void)updateRightItemStatus;                                  //更新导航栏右按钮状态

@end
