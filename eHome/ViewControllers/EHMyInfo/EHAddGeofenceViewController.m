//
//  EHAddGeofenceViewController.m
//  eHome
//
//  Created by xtq on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddGeofenceViewController.h"
#import "EHInsertGeofenceService.h"
@implementation EHAddGeofenceViewController
{
    EHInsertGeofenceService *_service;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self checkCoordinate];
}

#pragma mark - Events Response
- (void)sureBtnClick:(id)sender{
    NSLog(@"rightItemClick");
    
    if ([self.existedNameArray containsObject:self.geofenceNameField.text]) {
        [WeAppToast toast:@"该围栏名字已经存在"];
        return;
    }
    
    [self configInsertGeofenceService];
    EHInsertGeofenceReq *req = [self getInsertGeofenceReq];
    [_service insertGeofence:req];
}

#pragma mark - Common Methods
/**
 *  检查baby最近一次的位置，如果为空，则进行一次系统定位到自己的当前位置
 */
- (void)checkCoordinate{
    EHLogInfo(@"self.geofenceCoordinate = %f",self.geofenceCoordinate.latitude);
    if (!self.geofenceCoordinate.latitude && !self.geofenceCoordinate.longitude) {
        self.mapView.showsUserLocation = YES;
    }
}

#pragma mark - MAMapViewDelegate
//定位回调一次，并重新设置地图
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"updatingLocation :latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.geofenceCoordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(self.geofenceCoordinate, self.radius * 2, self.radius * 2);
        [self.mapView setRegion:region animated:YES];
        self.neededZoomLevel = 16.321259;       //默认500米半径的缩放级别
        self.mapView.showsUserLocation = NO;
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [WeAppToast toast:@"定位失败，请检查定位设置"];
}

#pragma mark - Getter And Setters
/**
 *  导航栏
 */
- (void)configNavigationBar{
    self.title = @"创建围栏";
    self.rightItemButton = [self sureBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightItemButton.enabled = NO;
}

- (UIButton *)sureBtn{
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.enabled = NO;
    return sureBtn;
}

/**
 *  配置添加围栏请求服务
 */
- (void)configInsertGeofenceService{
    typeof(self) __weak weakself = self;
    if (!_service) {
        _service = [EHInsertGeofenceService new];
        _service.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            [WeAppToast toast:@"添加成功！"];
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        _service.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"添加失败！"];
        };
    }
}

- (EHInsertGeofenceReq *)getInsertGeofenceReq{
    EHInsertGeofenceReq *req = [[EHInsertGeofenceReq alloc]init];
    
    req.geofence_name = self.geofenceNameField.text;
    req.latitude = self.geofenceCoordinate.latitude;
    req.longitude = self.geofenceCoordinate.longitude;
    req.geofence_radius = (int)self.radius;
    req.creator_id = [[KSLoginComponentItem sharedInstance].userId intValue];
    req.baby_id = [self.babyUser.babyId intValue];
    req.geofence_address = self.addressLabel.text;
    
    return req;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
