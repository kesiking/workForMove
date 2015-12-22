//
//  EHMapViewContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapViewContainer.h"
#import "EHDeviceStatusCenter.h"
#import "EHMAMapViewShareInstance.h"
#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8

@interface EHMapViewContainer()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)  UITapGestureRecognizer  *mapTapGesture;

@end

@implementation EHMapViewContainer

-(void)setupView{
    [super setupView];
    _annotationArray = [NSMutableArray array];
    [self configMapView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_mapView setFrame:self.bounds];
}

-(void)dealloc{
    [self resetMap];
    // 多实例可清除 -- map多实例方案
    [[EHMAMapViewShareInstance sharedCenter] resetMapWithMapView:_mapView];
    _mapView.delegate = nil;
    _mapView = nil;
}

- (void)configMapView{
    _mapView = [[EHMAMapViewShareInstance sharedCenter] getMapViewWithFrame:self.bounds] ; //需要注意！3D高德地图不支持多实例，推荐使用一个公共地图对象。不过地图对象一初始化后就会使内存的使用提升30M左右大小，这里需要再斟酌。
    _mapView.delegate = self;
    
    _mapView.showsUserLocation = YES;                       //YES 为打开定位，NO为关闭定位
    _mapView.pausesLocationUpdatesAutomatically = YES;      //是否自动暂停位置更新
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;

    _mapView.showsLabels = YES;
    
    _mapView.showsCompass = NO;
    _mapView.showsScale = YES;
    _mapView.scaleOrigin = CGPointMake(70, _mapView.height - 25);
    _mapView.rotateEnabled = NO;                            //不支持旋转
    _mapView.rotateCameraEnabled = NO;                      //不支持相机角度旋转
    _mapView.touchPOIEnabled = NO;
    
    [_mapView setZoomLevel:MAP_DEFAULT_ZOOM_SCALE animated:YES];                //地图设置缩放级别，3~20
    [_mapView setUserTrackingMode:MAUserTrackingModeNone];    //地图不跟着位置移动
    
    // 为地图增加点击方法
    _mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapGesturePress:)];
    // 添加手势依赖
    UIGestureRecognizer* zoomInGesture = [_mapView valueForKey:@"_zoomInGestureRecognizer"];
    UIGestureRecognizer* zoomOutGesture = [_mapView valueForKey:@"_zoomOutGestureRecognizer"];
    UIGestureRecognizer* panGesture = [_mapView valueForKey:@"_panGestureRecognizer"];
    if (zoomInGesture) {
        [_mapTapGesture requireGestureRecognizerToFail:zoomInGesture];
    }
    if (zoomOutGesture) {
        [_mapTapGesture requireGestureRecognizerToFail:zoomOutGesture];
    }
    if (panGesture) {
        [_mapTapGesture requireGestureRecognizerToFail:panGesture];
    }
    // 添加手势代理为当前container
    _mapTapGesture.delegate = self;
    [_mapView addGestureRecognizer:_mapTapGesture];
    
    [self addSubview:_mapView];
}

-(void)reloadData{
    // 无需做清除操作 -- map多实例方案
//    [self configMapView];
    [_mapView removeAnnotations:self.annotationArray];
    [_mapView addAnnotations:self.annotationArray];   //在地图上添加标注
}

-(void)resetMap{
    [_mapView removeAnnotations:self.annotationArray];
}

#pragma mark - rect Helpers

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark - mapTapGesturePress gesture method

-(void)mapTapGesturePress:(UIGestureRecognizer*)gestureRecognizer {
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
//    CLLocationCoordinate2D touchMapCoordinate =
//    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
//    EHLogInfo(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
//    [self mapOnClickedWithMapView:self.mapView touchMapCoordinate:touchMapCoordinate];
}

-(void)mapOnClickedWithMapView:(MAMapView*)mapView touchMapCoordinate:(CLLocationCoordinate2D)touchMapCoordinate{
    
}

- (BOOL)gestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    EHLogInfo(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    [self mapOnClickedWithMapView:self.mapView touchMapCoordinate:touchMapCoordinate];
    return YES;
}

#pragma mark - userLocation Delegate
/**
 *  定位回调
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    /*!
     *  @brief  需定位手机
     *
     *  @since 1.0
     */
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        EHLogInfo(@"userLocation -- latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [[EHDeviceStatusCenter sharedCenter] setCurrentLocation:userLocation.location];
        [[EHDeviceStatusCenter sharedCenter] setCurrentPhoneCoordinate:userLocation.coordinate];
    }
}

/**
 *  定位回调失败
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    EHLogInfo(@"FailToLocateUserWithError");
    [[EHDeviceStatusCenter sharedCenter] setCurrentLocation:nil];
}

/**
 *  标注视图配置。通常需要自定义配置。
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"annotationReuseIndetifier";
        EHBabyLocationAnnotationView*  annotationView = (EHBabyLocationAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[EHBabyLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.draggable = NO;               //设置标注可以拖动，默认为NO
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, 0);
        
        annotationView.calloutOffset = CGPointMake(0, -5);
        
        return annotationView;
    }else if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = nil;
        annotationView.hidden = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    
    return nil;
}


/**
 *  点击大头针标注
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    // 调整自定义callout的位置，使其可以完全显示
    if ([view isKindOfClass:[EHBabyLocationAnnotationView class]]) {
        EHBabyLocationAnnotationView *cusView = (EHBabyLocationAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:_mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kDefaultCalloutViewMargin, kDefaultCalloutViewMargin, kDefaultCalloutViewMargin, kDefaultCalloutViewMargin));
        
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            CGSize offset = [self offsetToContainRect:frame inRect:_mapView.frame];
            
            CGPoint theCenter = _mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
    }
}

/*!
 @brief 当取消选中一个annotation views时，调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    
}

/*!
 @brief 当touchPOIEnabled == YES时，单击地图使用该回调获取POI信息
 @param mapView 地图View
 @param pois 获取到的poi数组(由MATouchPoi组成)
 */
- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    
}

@end
