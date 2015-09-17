//
//  EHMapGeoSearchContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapGeoSearchContainer.h"
#import "EHPositionAnnotation.h"

@implementation EHMapGeoSearchContainer

-(void)setupView{
    [super setupView];
    [self initSearch];
}

- (void)initSearch
{
    _search =  [[AMapSearchAPI alloc] initWithSearchKey:kMAMapAPIKey Delegate:self];
}

#pragma mark - geoAction

- (void)reGeoActionWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    
    [_search AMapReGoecodeSearch:request];
}

#pragma mark - AMapSearchDelegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"request :%@, error :%@", request, error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@", response);
    
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        // 直辖市的city为空，取province
        title = response.regeocode.addressComponent.province;
    }
    
    // 更新我的位置title
    EHPositionAnnotation *pointAnnotation = _mapView.selectedAnnotations[0];   //取得选中的标注
    pointAnnotation.title = title;
    pointAnnotation.subtitle = response.regeocode.formattedAddress;
    pointAnnotation.position.location_Des = response.regeocode.formattedAddress;
    EHBabyLocationAnnotationView *annotationView = (EHBabyLocationAnnotationView*)[_mapView viewForAnnotation:pointAnnotation];
    [annotationView.calloutView reloadData];
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    // 选中定位annotation的时候进行逆地理编码查询
    if (view.annotation)
    {
        [self reGeoActionWithLocation:view.annotation.coordinate];
    }
    [super mapView:mapView didSelectAnnotationView:view];
    
}

@end
