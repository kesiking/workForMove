//
//  EHMAMapViewShareInstance.m
//  eHome
//
//  Created by louzhenhua on 15/10/16.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHMAMapViewShareInstance.h"

@interface EHMAMapViewShareInstance()
{
    
}
@property(nonatomic,assign) CGRect              frame;
@property (nonatomic, strong) MAMapView* mapView;
@end

@implementation EHMAMapViewShareInstance

#pragma mark - singleton

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    [self resetMapWithMapView:_mapView];
}


#pragma mark - 懒加载  mapview、navBarTItleView

- (MAMapView*)getMapViewWithFrame:(CGRect)frame{
    // 无需做清除操作 -- map多实例方案
    self.frame = frame;
    [MAMapServices sharedServices].apiKey = kMAMapAPIKey;   //设置KEY
    _mapView = [[MAMapView alloc] initWithFrame:self.frame];
    return _mapView;
//    [self.mapView setFrame:frame];
//    return self.mapView;
}

-(MAMapView *)mapView{
    if (_mapView == nil) {
        [MAMapServices sharedServices].apiKey = kMAMapAPIKey;   //设置KEY
        _mapView = [[MAMapView alloc] initWithFrame:self.frame];
//        _mapView.showsUserLocation = NO;                       //YES 为打开定位，NO为关闭定位
//        _mapView.showsScale = NO;
//        _mapView.showsCompass = NO;
//        [_mapView setCenterCoordinate:coordinate];              //地图设置中心点
//        [_mapView setZoomLevel:10 animated:YES];                //地图设置缩放级别，3~20
//        [_mapView setUserTrackingMode: MAUserTrackingModeNone]; //地图不跟着位置移动

    }
    return _mapView;
}

-(void)resetMapWithMapView:(MAMapView*)mapView{
    // 多实例可清除 -- map多实例方案
    mapView.delegate = nil;
    mapView = nil;
    _mapView.delegate = nil;
    _mapView = nil;
}

@end
