//
//  EHBaseGeofenceViewController.m
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseGeofenceViewController.h"
#import "EHGeofenceAddressSearchViewController.h"
#import "NSString+StringSize.h"

@interface EHBaseGeofenceViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate>

@end

@implementation EHBaseGeofenceViewController
{
    AMapSearchAPI *_search;         //地图搜索服务
    
    CAShapeLayer *_overlayLayer;    //地图中间覆盖物图层
    
    BOOL _scaleTag;                 //缩放标记（防地图死循环回调）
    BOOL _radiusUpdated;            //滑动条更新标记，用来重设当前缩放级别判定
    BOOL _searchFinishTag;          //搜索返回标记
}

#pragma mark - Life Circle

- (instancetype)init{
    self = [super init];
    if (self) {
        self.radius = 500;          //默认500
        _scaleTag = NO;
        _radiusUpdated = YES;
        _searchFinishTag = NO;
        self.geofenceModifiedTag = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configMapView];
    [self.view.layer addSublayer:[self overlayLayer]];
    [self.view addSubview:[self centerImageView]];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.sliderView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

/**
 *  初次setRegion显示时需要在viewDidAppear中进行操作，不然显示半径不正确
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(self.geofenceCoordinate, self.radius * 2, self.radius * 2);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}
/**
 *  结束时要将代理设为nil，防止地图回调崩溃
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - Events Response
/**
 *  搜索地址
 */
- (void)showAddressSearchVC {
    EHGeofenceAddressSearchViewController *gasVC = [[EHGeofenceAddressSearchViewController alloc]init];
    gasVC.searchFinishedBlock = ^(NSString *address,CLLocationCoordinate2D coordinate){
        _searchFinishTag = YES;
        NSLog(@"address = %@",address);
        NSLog(@"coordinate: %f,%f",coordinate.latitude,coordinate.longitude);
        self.topView.address = address;
        self.geofenceCoordinate = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
        [_mapView setCenterCoordinate:coordinate];
        [self updateRightItemStatus];
    };
    [self.navigationController pushViewController:gasVC animated:YES];
}

/**
 *  更新导航栏右按钮状态
 */
- (void)updateRightItemStatus{
    NSString *geofenceName = self.topView.geofenceName;
    if (geofenceName.length > 0 && geofenceName.length <= 10) {
        self.rightItemButton.enabled = YES;
    }
    else {
        self.rightItemButton.enabled = NO;
    }
}

#pragma mark - Common Methods
/**
 *  逆地理编码
 */
-(void)reGoecodeSearchWithCoordinate:(CLLocationCoordinate2D)coordinate{
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //    regeoRequest.radius = 10000;
    //        regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self.view endEditing:YES];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CGFloat r = [mapView metersPerPointForCurrentZoomLevel] * CGRectGetWidth(self.view.frame) / 2.0;
    EHLogInfo(@"r = %f",r);
    
    //通过滑动条更改了半径，重设需要的zoomLevel
    if (_radiusUpdated) {
        self.neededZoomLevel = mapView.zoomLevel;
        EHLogInfo(@"self.neededZoomLevel = %f",self.neededZoomLevel);
        _radiusUpdated = NO;
    }
    
    //防死循环回调
    if (_scaleTag) {
        _scaleTag = NO;
        return;
    }
    
    //检测地图的缩放情况，并对UI做处理
    [self checkMapViewZoomLevel:mapView];
    
    //搜索结束返回后无需再逆地理编码
    if (_searchFinishTag) {
        _searchFinishTag = NO;
        return;
    }
    
    //围栏可编辑状态，可进行逆地理编码操作
    if (self.geofenceModifiedTag) {
        self.geofenceCoordinate = mapView.centerCoordinate;
        [self reGoecodeSearchWithCoordinate:mapView.centerCoordinate];
    }
}

- (void)checkMapViewZoomLevel:(MAMapView *)mapView {
    
    //中心位置自动回正代码块（处于围栏详情状态(非可编辑)时应在操作地图后自动回正）
    void (^returnCenterBlock)() = ^(){
        if (!self.geofenceModifiedTag) {
            if ((mapView.centerCoordinate.latitude != self.geofenceCoordinate.latitude) || (mapView.centerCoordinate.longitude != self.geofenceCoordinate.longitude)) {
                _scaleTag = YES;
                [self performSelector:@selector(reCenterMap) withObject:nil afterDelay:0.1];
            }
        }
    };
    
    //地图放大超界
    if (mapView.zoomLevel > self.neededZoomLevel) {
        _scaleTag = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _overlayLayer.transform = CATransform3DIdentity;
        }];
        [self performSelector:@selector(resetMap) withObject:nil afterDelay:0.1];
    }
    //地图缩小
    else if (mapView.zoomLevel < self.neededZoomLevel){
        CGFloat scale =  self.radius * 2 / (mapView.metersPerPointForCurrentZoomLevel * CGRectGetWidth(_mapView.frame));
        scale = MIN(scale, 1);
        [UIView animateWithDuration:0.5 animations:^{
            _overlayLayer.transform = CATransform3DMakeScale(scale, scale, 1);
        }];
        returnCenterBlock();
    }
    //地图无缩放（平移）
    else{
        returnCenterBlock();
        if (self.geofenceModifiedTag) {
            [self updateRightItemStatus];
        }
    }
}

//缩放级别回正，旋转角度回正
- (void)resetMap{
    [_mapView setZoomLevel:self.neededZoomLevel animated:YES];
    [_mapView setRotationDegree:0 animated:YES duration:0.5];
}

//中心回正
- (void)reCenterMap{
    [_mapView setCenterCoordinate:self.geofenceCoordinate animated:YES];
}

#pragma mark - AMapSearchDelegate
/**
 *  实现逆地理编码的回调函数，并设置标注的标题为获取的地理信息
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //        NSString *result = [NSString stringWithFormat:@"\n %@\n%@", response.regeocode.formattedAddress,response.regeocode.addressComponent];
        //        NSLog(@"ReGeo: %@", result);
        AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
        NSMutableString *address = [NSMutableString stringWithFormat:@"%@%@%@%@",addressComponent.city,addressComponent.district,addressComponent.streetNumber.street,addressComponent.streetNumber.number];
        //        if (![addressComponent.streetNumber.number isEqualToString:@""] && ![addressComponent.streetNumber.number containsString:@"号"]) {
        //            [address appendString:@"号"];
        //        }
        self.topView.address = address;
    }
}

#pragma mark - Getter And Setters
/**
 *  地图
 */
- (void)configMapView{
    self.mapView.frame = self.view.bounds;
    EHLogInfo(@"self.mapView = %@",self.mapView);
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.mapView.showsScale= YES;   //设置成NO表示不显示比例尺；YES表示显示比例尺
    self.mapView.scaleOrigin= CGPointMake(self.mapView.scaleOrigin.x, CGRectGetHeight(self.mapView.frame) - 40);  //设置比例尺位置
    self.mapView.touchPOIEnabled = NO;
    [self.view addSubview:self.mapView];
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:kMAMapAPIKey Delegate:self];
    
}

/**
 *  覆盖圆形图层
 */
- (CAShapeLayer *)overlayLayer{
    CGFloat length = CGRectGetWidth(_mapView.frame);
    CGRect rect = CGRectMake(0, (CGRectGetHeight(_mapView.frame) - length) / 2.0, length, length);
    UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:length / 2.0];
    if (!_overlayLayer) {
        _overlayLayer = [CAShapeLayer layer];
        _overlayLayer.path = bp.CGPath;
        _overlayLayer.strokeColor = [UIColor clearColor].CGColor;
        _overlayLayer.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2].CGColor;
        _overlayLayer.frame = _mapView.bounds;
    }
    return _overlayLayer;
}

/**
 *  中心原点
 */
- (UIImageView *)centerImageView{
    UIImageView *imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_createfence_map"]];;
    imv.frame = CGRectMake(0, 0, 40, 40);
    imv.center = _mapView.center;
    imv.userInteractionEnabled = YES;
    return imv;
}

/**
 *  顶部视图
 */
- (UIView *)topView{
    if (!_topView) {
        CGFloat topViewHeight = 85;
        
        WEAKSELF
        _topView = [[EHGeofenceTopView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), topViewHeight)];
        
        _topView.searchBtnClickBlock = ^(){
            [weakSelf showAddressSearchVC];
        };
        
        _topView.geofenceNameFieldChangedBlock = ^(){
            [weakSelf updateRightItemStatus];
        };
    }
    
    return _topView;
}

/**
 *  底部滑动视图
 */
- (UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[EHRadiusSliderView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame), 60)];
        
        _sliderView.radius = self.radius;
        WEAKSELF
        _sliderView.radiusChangedBlock = ^(NSInteger radius){
            STRONGSELF
            strongSelf.radius = radius;
            EHLogInfo(@"self.radius = %ld",radius);
            _radiusUpdated = YES;
            
            MACoordinateRegion region = MACoordinateRegionMakeWithDistance(strongSelf.mapView.centerCoordinate, radius * 2, radius * 2);
            region = [strongSelf.mapView regionThatFits:region];
            [strongSelf.mapView setRegion:region animated:YES];
            [strongSelf updateRightItemStatus];
        };
    }
    return _sliderView;
}

- (void)dealloc{
    [self.mapView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
