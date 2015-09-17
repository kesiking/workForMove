//
//  EHMapViewControllerDemo.m
//  eHome
//
//  Created by xtq on 15/6/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapViewControllerDemo.h"

@interface EHMapViewControllerDemo ()<MAMapViewDelegate>

@end

@implementation EHMapViewControllerDemo
{
    MAMapView *_mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMapView];
    

    
    // Do any additional setup after loading the view.
}

-(void)dealloc{
    _mapView.delegate = self;
    _mapView = nil;
}

- (void)configMapView{
    [MAMapServices sharedServices].apiKey = kMAMapAPIKey;   //设置KEY
    _mapView = [[MAMapView alloc]initWithFrame:self.view.frame];    //需要注意！3D高德地图不支持多实例，推荐使用一个公共地图对象。不过地图对象一初始化后就会使内存的使用提升30M左右大小，这里需要再斟酌。
    _mapView.delegate = self;
    
    _mapView.showsUserLocation = YES;                       //YES 为打开定位，NO为关闭定位
    _mapView.pausesLocationUpdatesAutomatically = NO;       //是否自动暂停位置更新

    CLLocationCoordinate2D coordinate;                      //设置坐标
    coordinate.latitude = 30.280261;                        //经度
    coordinate.longitude = 120.016320;                      //纬度
    
    [_mapView setCenterCoordinate:coordinate];              //地图设置中心点
    [_mapView setZoomLevel:12 animated:YES];                //地图设置缩放级别，3~20
    [_mapView setUserTrackingMode: MAUserTrackingModeNone]; //地图不跟着位置移动

    [self.view addSubview:_mapView];
    
    [self addAnnotation];                                   //添加标注
}

/**
 *  添加大头针标注。通常标注和弹出气泡的样式需要自定义
 */
- (void)addAnnotation{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(30.280261, 120.016320);//大头针标注坐标
    pointAnnotation.title = @"海创园";     //点击大头针标注出现的弹框的标题
    pointAnnotation.subtitle = @"中移";   //子标题
    
    [_mapView addAnnotation:pointAnnotation];   //在地图上添加标注
}

#pragma mark - Delegate
/**
 *  定位回调
 */
static int staticIndex = 0;
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        EHLogInfo(@"userLocation -- latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        if (staticIndex++ == 0) {
            [_mapView setCenterCoordinate:userLocation.coordinate];
        }
    }
}

/**
 *  定位回调失败
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    EHLogInfo(@"FailToLocateUserWithError");
}

/**
 *  标注视图配置。通常需要自定义配置。
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }

    return nil;
}

/**
 *  点击大头针标注
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    MAPointAnnotation *pointAnnotation = _mapView.selectedAnnotations[0];   //取得选中的标注
    EHLogInfo(@"latitude : %f,longitude: %f",pointAnnotation.coordinate.latitude,pointAnnotation.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
