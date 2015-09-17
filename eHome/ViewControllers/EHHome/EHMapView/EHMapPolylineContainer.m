//
//  EHMapPolylineContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapPolylineContainer.h"
#import "EHPositionAnnotation.h"
#import "MAAnnotationView+WebCache.h"

@interface EHMapPolylineContainer()

@property (nonatomic, strong) UIImage           *            footprint_common_point_image;

@property (nonatomic, strong) UIImage           *            baby_map_current_point_image;

@end

@implementation EHMapPolylineContainer

-(void)setupView{
    [super setupView];
    self.baby_map_current_point_image = [UIImage imageNamed:@"footpoint_finish"];
    self.footprint_common_point_image = [UIImage imageNamed:@"footpoint_common"];
    self.mapView.showsUserLocation = NO;
}

-(void)reloadData{
    [self resetMapAnnotation];
    [self setupMapAnnotation];
    [super reloadData];
    [self resetMapPolylineOverLay];
    [self setupMapPolylineOverLay];
    [self reloadPolylineOverLayData];
    [self performSelector:@selector(resizeMapRegion) withObject:nil afterDelay:0.3];
}

-(void)setupMapPolylineOverLay{
    // create a c array of points.
    if ([self.annotationArray count] == 0) {
        self.polylineOverLay = nil;
        return;
    }
    NSUInteger annotationPolyLineCount = self.annotationArray.count > self.endMovingPositionIndex + 1 ? self.endMovingPositionIndex + 1 : self.annotationArray.count;
    MAMapPoint* pointArray = malloc(sizeof(MAMapPoint) * annotationPolyLineCount);
    for (EHPositionAnnotation* positionAnnotation in self.annotationArray) {
        if (![positionAnnotation isKindOfClass:[EHPositionAnnotation class]]) {
            continue;
        }
        NSUInteger index = [self.annotationArray indexOfObject:positionAnnotation];
        //设置坐标
        if (index > self.endMovingPositionIndex) {
            break;
        }
        //构造折线
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([positionAnnotation.position.location_latitude doubleValue],[positionAnnotation.position.location_longitude doubleValue]);
        MAMapPoint point = MAMapPointForCoordinate(coordinate);
        pointArray[index] = point;
    }
    self.polylineOverLay = [MAPolyline polylineWithPoints:pointArray count:annotationPolyLineCount];
}

-(void)resetMapPolylineOverLay{
    [self.mapView removeOverlay:self.polylineOverLay];
}

-(void)resetMap{
    [super resetMap];
    [self resetMapPolylineOverLay];
}

-(void)reloadPolylineOverLayData{
    [self.mapView removeOverlay:self.polylineOverLay];
    [self.mapView addOverlay:self.polylineOverLay];
}

-(void)resizeMapRegion{
    [self.mapView showAnnotations:self.annotationArray animated:NO];
}

-(void)selectAnnotationViewWithIndex:(NSUInteger)index{
    // override
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MAMapViewDelegate viewForAnnotation 获取annotationView

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    EHBabyLocationAnnotationView* annotationView = (EHBabyLocationAnnotationView*)[super mapView:mapView viewForAnnotation:annotation];
    
    if ([annotationView isKindOfClass:[EHBabyLocationAnnotationView class]] && [annotation isKindOfClass:[EHPositionAnnotation class]])
    {
        EHPositionAnnotation* pointAnnotation = (EHPositionAnnotation*)annotation;
        annotationView.position = pointAnnotation.position;
        if([pointAnnotation.position.locationType isEqualToString:current_LocationType]){
            // 当前位置展示头像
            [annotationView.annotationImageView sd_cancelCurrentAnimationImagesLoad];
            [annotationView.annotationImageView setImage:nil];
            annotationView.annotationImageView.hidden = YES;
            // 去掉足迹中当前点的概念，变为普通点
            [annotationView sd_cancelCurrentImageLoad];
            [annotationView setAnnotationImage:[UIImage imageNamed:@"footpoint_common"]];
#ifndef MAP_USE_WEB_HEADER_IMAGE
            // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
//            annotationView.centerOffset = CGPointMake(0, -10);
#endif
        }
    }
    
    NSUInteger index = [self.annotationArray indexOfObject:annotation];
    
    if (index != NSNotFound && index == self.endMovingPositionIndex) {
        [annotationView setAnnotationImage:self.baby_map_current_point_image];
    }

    annotationView.enabled = NO;
    
    return annotationView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MAMapViewDelegate overLay 刷新
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        UIColor *boyLineColor = RGB_A(0x23, 0x74, 0xfa, 1.0);
        UIColor *girlLineColor = RGB_A(0x23, 0x74, 0xfa, 1.0);

        polylineView.lineWidth = 3.0f;
        if ([KSAuthenticationCenter isTestAccount]) {
            polylineView.strokeColor = boyLineColor;
        }else{
            polylineView.strokeColor = [self.babyUserInfo.babySex integerValue] == EHBabySexType_girl ? girlLineColor : boyLineColor;
        }
        
        return polylineView;
    }
    return [super mapView:mapView viewForOverlay:overlay];
}

@end
