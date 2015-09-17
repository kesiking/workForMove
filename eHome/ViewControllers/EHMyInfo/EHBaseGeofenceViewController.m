//
//  EHBaseGeofenceViewController.m
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseGeofenceViewController.h"
#import "EHGeofenceAddressSearchViewController.h"

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
    [self.view addSubview:[self topView]];
    [self.view addSubview:[self sliderView]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    self.mapView.delegate = self;

}

//结束时要将代理设为nil，防止地图回调崩溃
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    self.mapView.delegate = nil;
}

#pragma mark - Events Response
/**
 *  搜索地址
 */
- (void)searchBtnClick:(id)sender{
    NSLog(@"searchBtnClick");
    EHGeofenceAddressSearchViewController *gasVC = [[EHGeofenceAddressSearchViewController alloc]init];
    gasVC.searchFinishedBlock = ^(NSString *address,CLLocationCoordinate2D coordinate){
        _searchFinishTag = YES;
        NSLog(@"address = %@",address);
        NSLog(@"coordinate: %f,%f",coordinate.latitude,coordinate.longitude);
        self.addressLabel.text = address;
        self.geofenceCoordinate = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
        [_mapView setCenterCoordinate:coordinate];
        [self updateRightItemStatus];
    };
    [self.navigationController pushViewController:gasVC animated:YES];
}

/**
 *  滑动视图更改半径，重新规划UI
 */
- (void)sliderValueChange:(id)sender{
    UISlider *slider = (UISlider *)sender;
    [slider setValue:(slider.value - ((int)slider.value % 100)) animated:YES];
    NSLog(@"sliderValueChange = %f",slider.value);
    _radiusUpdated = YES;
    self.radius = slider.value;
    
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(_mapView.centerCoordinate, self.radius * 2, self.radius * 2);
    [_mapView setRegion:region animated:YES];
    
    UILabel *radiusLabel = (UILabel *)[self.sliderView viewWithTag:104];
    radiusLabel.text = [NSString stringWithFormat:@"%dm",(int)slider.value];
    CGRect frame = radiusLabel.frame;
    frame.origin.x = (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue) * CGRectGetWidth(slider.frame) + 10 - 50;
    radiusLabel.textAlignment = NSTextAlignmentCenter;

    if (slider.value == slider.minimumValue) {
        frame.origin.x = 10;
        radiusLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (slider.value == slider.maximumValue) {
        frame.origin.x = CGRectGetWidth(slider.superview.frame)- 10 - CGRectGetWidth(radiusLabel.frame);
        radiusLabel.textAlignment = NSTextAlignmentRight;
    }
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        radiusLabel.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self updateRightItemStatus];
}

/**
 *  更新导航栏右按钮状态
 */
- (void)updateRightItemStatus{
    UITextField *textField = self.geofenceNameField;
    if (textField.text.length > 0 && textField.text.length <= 20) {
        self.rightItemButton.enabled = YES;
        self.lineLayer.fillColor = EH_linecor2.CGColor;
    }
    else {
        self.rightItemButton.enabled = NO;
        self.lineLayer.fillColor = EH_linecor1.CGColor;
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
    //    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

/**
 *  设置围栏半径（包含UI）
 */
- (void)setGeofenceRadius:(NSInteger)radius{
    self.radius = radius;
    UISlider *slider = (UISlider *)[self.sliderView viewWithTag:103];
    slider.value = radius;
    UILabel *radiusLabel = (UILabel *)[self.sliderView viewWithTag:104];
    radiusLabel.text = [NSString stringWithFormat:@"%ldm",self.radius];
    
    CGRect frame = radiusLabel.frame;
    frame.origin.x = (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue) * CGRectGetWidth(slider.frame) + 10 - 50;
    radiusLabel.frame = frame;
}


#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self.view endEditing:YES];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //通过滑动条更改了半径
    if (_radiusUpdated) {
        self.neededZoomLevel = mapView.zoomLevel;
        EHLogInfo(@"self.neededZoomLevel = %f",self.neededZoomLevel);
        _radiusUpdated = NO;
    }
    
    //中心位置自动回正代码块
    void (^returnCenterBlock)() = ^(){
        if (!self.geofenceModifiedTag) {
            if ((mapView.centerCoordinate.latitude != self.geofenceCoordinate.latitude) || (mapView.centerCoordinate.longitude != self.geofenceCoordinate.longitude)) {
                _scaleTag = YES;
                [self performSelector:@selector(reCenterMap) withObject:nil afterDelay:0.1];
            }
        }
    };
    
    //防死循环回调
    if (_scaleTag) {
        _scaleTag = NO;
        return;
    }
    
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
//        NSLog(@"me = %f",mapView.metersPerPointForCurrentZoomLevel * CGRectGetWidth(_mapView.frame));
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

- (void)resetMap{
    [_mapView setZoomLevel:self.neededZoomLevel animated:YES];
    [_mapView setRotationDegree:0 animated:YES duration:0.5];
}

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
        NSString *result = [NSString stringWithFormat:@"\n %@\n%@", response.regeocode.formattedAddress,response.regeocode.addressComponent];
        NSLog(@"ReGeo: %@", result);
        AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
        NSMutableString *address = [NSMutableString stringWithFormat:@"%@%@%@%@",addressComponent.city,addressComponent.district,addressComponent.streetNumber.street,addressComponent.streetNumber.number];
//        if (![addressComponent.streetNumber.number isEqualToString:@""] && ![addressComponent.streetNumber.number containsString:@"号"]) {
//            [address appendString:@"号"];
//        }
        self.addressLabel.text = address;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldValueChanged:(NSNotification *)notification{
    [self updateRightItemStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark - Getter And Setters
/**
 *  地图
 */
- (void)configMapView{
        self.mapView.frame = self.view.bounds;
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = NO;
        [self.view addSubview:self.mapView];
        
        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(self.geofenceCoordinate, self.radius * 2, self.radius * 2);
        [self.mapView setRegion:region animated:YES];
        self.neededZoomLevel = _mapView.zoomLevel;
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
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 85)];
        _topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        UILabel *geofenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 75, 15)];
        geofenceLabel.font = EH_font5;
        geofenceLabel.textColor = EH_cor3;
        geofenceLabel.textAlignment = NSTextAlignmentLeft;
        geofenceLabel.text = @"围栏名称：";
        
        UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 59, 75, 15)];
        centerLabel.font = EH_font5;
        centerLabel.textColor = EH_cor3;
        centerLabel.textAlignment = NSTextAlignmentLeft;
        centerLabel.text = @"中心点：";
        
        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_topView.frame) - 20 - 15, 59, 15, 15)];
        [searchBtn setImage:[UIImage imageNamed:@"ico_createfence_search"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:geofenceLabel];
        [_topView addSubview:centerLabel];
        [_topView addSubview:self.geofenceNameField];
        [_topView addSubview:self.addressLabel];
        [_topView addSubview:searchBtn];
    }
    
    return _topView;
}

/**
 *  围栏名称视图
 */
- (UITextField *)geofenceNameField{
    if (!_geofenceNameField) {
        _geofenceNameField = [[UITextField alloc]initWithFrame:CGRectMake(95, 5, CGRectGetWidth(self.view.frame) - 95 - 20, 34)];
        _geofenceNameField.placeholder = @"输入围栏名称";
        _geofenceNameField.returnKeyType = UIReturnKeyDone;
        _geofenceNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _geofenceNameField.delegate = self;
        
        UIBezierPath *bp = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(_geofenceNameField.frame), 1)];
        self.lineLayer = [CAShapeLayer layer];
        self.lineLayer.path = bp.CGPath;
        self.lineLayer.frame = CGRectMake(0, CGRectGetHeight(_geofenceNameField.frame) - 1, CGRectGetWidth(_geofenceNameField.frame), 1);
        self.lineLayer.strokeColor = [UIColor clearColor].CGColor;
        self.lineLayer.fillColor = EH_linecor1.CGColor;
        
        [_geofenceNameField.layer addSublayer:self.lineLayer];
    }
    return _geofenceNameField;
}

/**
 *  围栏地址视图
 */
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 59, CGRectGetWidth(_geofenceNameField.frame) - 20, 15)];
        _addressLabel.font = EH_font5;
        _addressLabel.textColor = EH_cor4;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

/**
 *  底部滑动视图
 */
- (UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame), 60)];
        _sliderView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        
        UISlider *radiusSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 25, CGRectGetWidth(_sliderView.frame) - 20, 10)];
        
        [radiusSlider setThumbImage:[UIImage imageNamed:@"radiusgauge_bbar_createfence_pointer"] forState:UIControlStateNormal];
        radiusSlider.minimumTrackTintColor = RGB(90, 179, 59);
        radiusSlider.maximumTrackTintColor = RGB(255, 255, 255);
        radiusSlider.minimumValue = 300;
        radiusSlider.maximumValue = 2000;
        radiusSlider.value = self.radius;
        radiusSlider.tag = 103;
        [radiusSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(_sliderView.frame) - 19, 100, 10)];
        leftLabel.font = EH_font8;
        leftLabel.textColor = EH_cor1;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.text = @"300m";
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_sliderView.frame) - 100 - 10, CGRectGetHeight(_sliderView.frame) - 19, 100, 10)];
        rightLabel.font = EH_font8;
        rightLabel.textColor = EH_cor1;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = @"2000m";
        
        UILabel *radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_sliderView.frame) - 100 - 10, 9, 100, 10)];
        radiusLabel.font = EH_font8;
        radiusLabel.textColor = EH_cor1;
        radiusLabel.textAlignment = NSTextAlignmentCenter;
        radiusLabel.text = [NSString stringWithFormat:@"%ldm",self.radius];
        CGRect frame = radiusLabel.frame;
        frame.origin.x = (radiusSlider.value - radiusSlider.minimumValue) / (radiusSlider.maximumValue - radiusSlider.minimumValue) * CGRectGetWidth(radiusSlider.frame) + 10 - 50;
        radiusLabel.frame = frame;
        radiusLabel.tag = 104;
        
        [_sliderView addSubview:radiusSlider];
        [_sliderView addSubview:leftLabel];
        [_sliderView addSubview:rightLabel];
        [_sliderView addSubview:radiusLabel];
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
