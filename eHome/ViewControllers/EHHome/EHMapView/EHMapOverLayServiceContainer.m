//
//  EHMapOverLayServiceContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/7/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapOverLayServiceContainer.h"
#import "EHBabyLocationAnnotationView.h"
#import "EHOverLayCenterPointAnnotation.h"
#import "KSToastView.h"

@interface EHMapOverLayServiceContainer(){
    
}

/*!
 *  @brief  geofence数据
 *
 *  @since 1.0
 */
// geofence足迹数据库
@property (nonatomic, strong) NSArray           *            geofenceArray;

@property (nonatomic, assign) BOOL                           isRegionChangePostion;

@end

@implementation EHMapOverLayServiceContainer

-(void)setupView{
    [super setupView];
    self.geofenceOverLayArray = [NSMutableArray new];
    self.geofenceOverLayPointAnnotationArray = [NSMutableArray new];
}

-(void)dealloc{

}

-(void)reloadData{
    [super reloadData];
    [self reloadGeofenceOverLayData];
}

-(void)loadBabyMapListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo{
    [super loadBabyMapListWithBabyUserInfo:babyUserInfo];
    [self loadGeofenceListWithBabyUserInfo:babyUserInfo];
}

-(void)loadGeofenceListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo{
    [self.geofencelistService getGeofenceListWithBabyID:[babyUserInfo.babyId intValue] UserID:[[KSAuthenticationCenter userId] intValue]];
}

-(void)reloadGeofenceOverLayData{
    [self.mapView removeOverlays:self.geofenceOverLayArray];
    [self.mapView addOverlays:self.geofenceOverLayArray];
    [self.mapView removeAnnotations:self.geofenceOverLayPointAnnotationArray];
    [self.mapView addAnnotations:self.geofenceOverLayPointAnnotationArray];
    [self resizeMapRegion];
}

-(void)resizeMapRegion{
    /*
     * 缩放到可以展示围栏展示区域
    CLLocationCoordinate2D currentMapCenterCoordinate = self.mapView.centerCoordinate;
    double radius = 0;
    for (MACircle *circle in self.geofenceOverLayArray) {
        // 在圆形内
        if (MACircleContainsCoordinate(currentMapCenterCoordinate, circle.coordinate, circle.radius)) {
            radius = MAMetersBetweenMapPoints(MAMapPointForCoordinate(currentMapCenterCoordinate), MAMapPointForCoordinate(circle.coordinate)) + circle.radius;
            break;
        }
    }
    if (radius > 0) {
        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(currentMapCenterCoordinate, radius * 2, radius * 2);
        [_mapView setRegion:region animated:YES];
    }
     */
//    [self.mapView showAnnotations:self.annotationArray animated:YES];
}

-(void)setupMapGeoFenceOverLay{
    for (EHGetGeofenceListRsp* geofence in self.geofenceArray) {
        if (![geofence isKindOfClass:[EHGetGeofenceListRsp class]]) {
            continue;
        }
        if (geofence.status_switch == 0) {
            continue;
        }
        //构造圆
        MACircle *geofenceOverLayCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(geofence.latitude, geofence.longitude) radius:geofence.geofence_radius];
        geofenceOverLayCircle.title = geofence.geofence_name;
        [self.geofenceOverLayArray addObject:geofenceOverLayCircle];
        
        //构造圆心点
        EHOverLayCenterPointAnnotation *centerPointAnnotation = [[EHOverLayCenterPointAnnotation alloc] init];
        centerPointAnnotation.coordinate = CLLocationCoordinate2DMake(geofence.latitude, geofence.longitude);//大头针标注坐标
        centerPointAnnotation.title = geofence.geofence_name;
        [self.geofenceOverLayPointAnnotationArray addObject:centerPointAnnotation];
    }
}

-(void)resetMapGeoFenceOverLay{
    [self.mapView removeOverlays:self.geofenceOverLayArray];
    [self.geofenceOverLayArray removeAllObjects];
    [self.mapView removeAnnotations:self.geofenceOverLayPointAnnotationArray];
    [self.geofenceOverLayPointAnnotationArray removeAllObjects];
}

-(void)resetMap{
    [super resetMap];
    [self resetMapGeoFenceOverLay];
}

-(EHGetGeofenceListService *)geofencelistService{
    if (!_geofencelistService) {
        _geofencelistService = [EHGetGeofenceListService new];
        WEAKSELF
        _geofencelistService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            strongSelf.geofenceArray = service.dataList;
            [strongSelf resetMapGeoFenceOverLay];
            [strongSelf setupMapGeoFenceOverLay];
            [strongSelf reloadGeofenceOverLayData];
        };
        _geofencelistService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf resetMapGeoFenceOverLay];
            [strongSelf reloadGeofenceOverLayData];
        };
    }
    return _geofencelistService;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MAMapViewContainer touchMap method
-(void)mapOnClickedWithMapView:(MAMapView*)mapView touchMapCoordinate:(CLLocationCoordinate2D)touchMapCoordinate{
    [super mapOnClickedWithMapView:mapView touchMapCoordinate:touchMapCoordinate];
    for (MACircle *geofenceOverLayCircle in self.geofenceOverLayArray) {
        // 点击范围在圆形内展示文案
        if (MACircleContainsCoordinate(touchMapCoordinate, geofenceOverLayCircle.coordinate, geofenceOverLayCircle.radius)) {
            NSArray* pointAnnotations = [[self.mapView annotationsInMapRect:geofenceOverLayCircle.boundingMapRect] allObjects];
            if ([self isTouchMapCoordinate:touchMapCoordinate containedInPointAnnotations:pointAnnotations]) {
                [self toastGeoFenceNameWithGeofenceOverLayCircle:geofenceOverLayCircle touchMapCoordinate:touchMapCoordinate];
            }
            break;
        }
    }
}

-(BOOL)isTouchMapCoordinate:(CLLocationCoordinate2D)touchMapCoordinate containedInPointAnnotations:(NSArray*)pointAnnotations{
    BOOL shoudToastGeofenceName = YES;
    for (MAPointAnnotation* pointAnnotation in pointAnnotations) {
        MAAnnotationView* annotationView = [self.mapView viewForAnnotation:pointAnnotation];
        if (annotationView == nil || ![annotationView isKindOfClass:[EHBabyLocationAnnotationView class]]) {
            continue;
        }
        EHBabyLocationAnnotationView* locationAnnotationView = (EHBabyLocationAnnotationView*)annotationView;
        
        if (self.isRegionChangePostion) {
            shoudToastGeofenceName = NO;
            break;
        }
        
        if (locationAnnotationView.isSelected) {
            shoudToastGeofenceName = NO;
            break;
        }
        
        MAMapPoint mapPoint = MAMapPointForCoordinate(touchMapCoordinate);
        // 将地图视图的位置转换成地图的位置
        CGFloat locationRange = 12;
        CGRect locationAnnotationViewFrame = locationAnnotationView.frame;
        locationAnnotationViewFrame.origin.x -= locationRange;
        locationAnnotationViewFrame.origin.y -= locationRange;
        locationAnnotationViewFrame.size.width += locationRange * 2;
        locationAnnotationViewFrame.size.height += locationRange * 2;

        MACoordinateRegion mapCoordinateRegion = [self.mapView convertRect:locationAnnotationViewFrame toRegionFromView:self.mapView];
        MAMapRect mapRect = MAMapRectForCoordinateRegion(mapCoordinateRegion);
        
        // 判断mapPoint是否在mapRect中，如果在annotationView范围中
        if (MAMapRectContainsPoint(mapRect,mapPoint)) {
            shoudToastGeofenceName = NO;
            break;
        }
        
        // 如果有气泡则将气泡annotationImageView点击范围也算在内
        if (locationAnnotationView.annotationImageView.image && !locationAnnotationView.annotationImageView.hidden) {
            MACoordinateRegion mapCoordinateRegion = [self.mapView convertRect:locationAnnotationView.annotationImageView.frame toRegionFromView:locationAnnotationView];
            MAMapRect mapRect = MAMapRectForCoordinateRegion(mapCoordinateRegion);
            
            // 判断mapPoint是否在mapRect中，如果在annotationView范围中
            if (MAMapRectContainsPoint(mapRect,mapPoint)) {
                shoudToastGeofenceName = NO;
                break;
            }
        }
        
        // annotationView未被选中则略过
        if (!locationAnnotationView.isSelected) {
            continue;
        }
        
        // 判断mapPoint是否在annotationView的calloutView范围中
        mapCoordinateRegion = [self.mapView convertRect:locationAnnotationView.calloutView.bounds toRegionFromView:locationAnnotationView.calloutView];
        mapRect = MAMapRectForCoordinateRegion(mapCoordinateRegion);
        if (MAMapRectContainsPoint(mapRect,mapPoint)) {
            shoudToastGeofenceName = NO;
            break;
        }
    }
    return shoudToastGeofenceName;
}

-(void)toastGeoFenceNameWithGeofenceOverLayCircle:(MACircle*)geofenceOverLayCircle touchMapCoordinate:(CLLocationCoordinate2D)touchMapCoordinate{
    CGPoint mapPoint = [self.mapView convertCoordinate:touchMapCoordinate toPointToView:self.mapView];

    [KSToastView toast:geofenceOverLayCircle.title toView:self.mapView displaytime:1.0 postion:mapPoint withCallBackBlock:^(UIView *toastView, UILabel *toastLabel) {
        toastLabel.numberOfLines = 1;
        [toastLabel sizeToFit];
        if (toastLabel.width > 230) {
            [toastLabel setWidth:230];
        }
        
        [toastView setFrame:CGRectMake(toastView.origin.x, toastView.origin.y, toastLabel.width + 30, 28)];
        [toastLabel setOrigin:CGPointMake(toastLabel.origin.x, 4)];
        
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:toastView.bounds];
        bgImageView.image = [[UIImage imageNamed:@"bg_map_crawl"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 28, 14, 68)];
        [toastView addSubview:bgImageView];
        toastView.layer.cornerRadius = 0;
        toastView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        toastView.center = CGPointMake(toastView.center.x - toastView.frame.size.width / 2, toastView.center.y - toastView.frame.size.height);
        
        CGRect frame = toastView.frame;
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(_mapView.frame) - (CGRectGetMinX(frame)));
            CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(_mapView.frame) - (CGRectGetMaxX(frame)));
            CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(_mapView.frame) - (CGRectGetMinY(frame)));
            CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(_mapView.frame) - (CGRectGetMaxY(frame)));
            CGSize offset = CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
            CGPoint theCenter = toastView.center;
            toastView.center = CGPointMake(theCenter.x + offset.width, theCenter.y + offset.height);
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MAMapViewDelegate viewForAnnotation 获取annotationView

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[EHOverLayCenterPointAnnotation class]])
    {
        static NSString *overLayCenterPointReuseIndetifier = @"overLayCenterPointReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:overLayCenterPointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:overLayCenterPointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"public_icon_point_fence"];
        annotationView.enabled = NO;
        return annotationView;
    }
    return [super mapView:mapView viewForAnnotation:annotation];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MAMapViewDelegate overLay 刷新
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == mapView.userLocationAccuracyCircle) {
        return nil;
    }
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        circleView.fillColor = RGB_A(0x6c, 0xbb, 0x52, 0.3);
        /*!
         @brief 笔触颜色,默认是kMAOverlayViewDefaultStrokeColor
         */
        circleView.strokeColor = [UIColor whiteColor];
        
        /*!
         @brief 笔触宽度,默认是0
         */
        circleView.lineWidth = 1.0;
        
        return circleView;
    }
    return [super mapView:mapView viewForOverlay:overlay];
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.isRegionChangePostion = YES;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.isRegionChangePostion = NO;
}

@end
