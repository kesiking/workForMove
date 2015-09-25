//
//  EHMapMovingAnnotationPolylineContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/8/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapMovingAnnotationPolylineContainer.h"
#import "EHCoordinationInterpolation.h"
#import "EHPositionAnnotation.h"
#import "EHMovingPointAnnotation.h"
#import "EHMovingAnnotationView.h"
#import "MAAnnotationView+WebCache.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+ImageProcess.h"
#import <MapKit/MapKit.h>

#define coordinationInterpolationDistance (5)
#define coordinationInterpolationMaxCoordinationsNumber (80)
#define coordinationInterpolationMinCoordinationsNumber (2)

@interface EHMapMovingAnnotationPolylineContainer()

@property (nonatomic, strong) EHCoordinationInterpolation *coordinationInterpolation;
@property (nonatomic, strong) EHMovingPointAnnotation     *movingPointAnnotation;
@property (nonatomic, strong) NSArray                     *movingPositions;
@property (nonatomic, strong) UIImage                     *headerViewImage;
@property (nonatomic, strong) UIImage                     *default_baby_map_header_image;
@property (nonatomic, strong) NSTimer                     *timer;
@property (nonatomic, assign) NSUInteger                   movingPointIndex;
@property (nonatomic, assign) BOOL                         isRegionDidChangePostion;

@end

@implementation EHMapMovingAnnotationPolylineContainer

-(void)setupView{
    [super setupView];
    self.coordinationInterpolation = [EHCoordinationInterpolation new];
    self.coordinationInterpolation.distance = coordinationInterpolationDistance;
    self.coordinationInterpolation.maxCoordinationsNumber = coordinationInterpolationMaxCoordinationsNumber;
    self.coordinationInterpolation.minCoordinationsNumber = coordinationInterpolationMinCoordinationsNumber;
    self.isMovingFinished = YES;
    self.default_baby_map_header_image = [UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"];
    self.default_baby_map_header_image = [self.default_baby_map_header_image scaleImage:self.default_baby_map_header_image toScale:0.8];
}

-(void)dealloc{
    [self releaseTimer];
}

- (void)startMoving{
    if (self.annotationArray == nil || [self.annotationArray count] == 0) {
        return;
    }
    self.headerViewImage = ([self.babyUserInfo.babySex integerValue] == EHBabySexType_girl ? [UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"] : [UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]);
    self.headerViewImage = [self.headerViewImage scaleImage:self.headerViewImage toScale:0.8];
    [self releaseTimer];
    [self resetMapMovingPointAnnotation];
    [self setupMapMovingPointAnnotation];
    [self reloadMapMovingPointAnnotation];
    [self movingAnnotationViewDidStart];
    [self initTimer];
}

- (void)initTimer{
    [self releaseTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(movingPointAnnotationEvent:) userInfo:nil repeats:YES];
    self.isMovingFinished = NO;
}

- (void)releaseTimer{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)movingPointAnnotationEvent:(NSTimer*)timer{
    if (self.movingPointIndex >= [self.movingPositions count]) {
        [self releaseTimer];
        [self resetMapMovingPointAnnotation];
        [self movingAnnotationViewDidStop];
        self.isMovingFinished = YES;
        return;
    }
    NSValue* value = [self.movingPositions objectAtIndex:self.movingPointIndex];
    CLLocationCoordinate2D coordinate = [value MKCoordinateValue];
    
    EHMovingAnnotationView*  annotationView = (EHMovingAnnotationView*)[self.mapView viewForAnnotation:self.movingPointAnnotation];
    
    if ([annotationView isKindOfClass:[EHMovingAnnotationView class]]) {
        annotationView.annotation.coordinate = coordinate;
    }
    
    self.movingPointIndex++;
}

-(void)movingAnnotationViewDidStart{
    if (self.doMovingAnnotationViewDidStart) {
        self.doMovingAnnotationViewDidStart(self);
    }
}

-(void)movingAnnotationViewDidStop{
    if (self.doMovingAnnotationViewDidStop) {
        self.doMovingAnnotationViewDidStop(self);
    }
}

-(void)reloadData{
    [super reloadData];
}

-(void)resizeMapRegion{
    [super resizeMapRegion];
    self.isRegionDidChangePostion = YES;
}

-(void)setupMapMovingPointAnnotation{
    NSMutableArray* coordinates = [NSMutableArray array];
    EHMovingPointAnnotation* movingPointAnnotation = [EHMovingPointAnnotation new];
    for (EHPositionAnnotation* positionAnnotation in self.annotationArray) {
        if (![positionAnnotation isKindOfClass:[EHPositionAnnotation class]]) {
            continue;
        }
        NSUInteger index = [self.annotationArray indexOfObject:positionAnnotation];
        if (index == 0) {
            movingPointAnnotation.coordinate = CLLocationCoordinate2DMake([positionAnnotation.position.location_latitude doubleValue], [positionAnnotation.position.location_longitude doubleValue]);//大头针标注坐标
        }
        //设置坐标
        if (index > self.endMovingPositionIndex) {
            break;
        }
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([positionAnnotation.position.location_latitude doubleValue],[positionAnnotation.position.location_longitude doubleValue]);
        [coordinates addObject:[NSValue valueWithMKCoordinate:coordinate]];
    }
    if (self.movingPositions == nil) {
        self.movingPositions = [self.coordinationInterpolation getCoordinationsWithBeginCoordinations:coordinates];
    }
    self.movingPointAnnotation = movingPointAnnotation;
}

-(void)resetMap{
    [super resetMap];
    self.isMovingFinished = YES;
    self.movingPositions = nil;
    self.isRegionDidChangePostion = NO;
    self.doMovingAnnotationViewDidStop = nil;
    self.doMovingAnnotationViewDidStart = nil;
    [self releaseTimer];
    [self resetMapMovingPointAnnotation];
}

-(void)reloadMapMovingPointAnnotation{
    [self resetMapMovingPointAnnotation];
    [self.mapView addAnnotation:self.movingPointAnnotation];
}

-(void)resetMapMovingPointAnnotation{
    self.movingPointIndex = 0;
    [self.mapView removeAnnotation:self.movingPointAnnotation];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MAMapViewDelegate viewForAnnotation 获取annotationView

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[EHMovingPointAnnotation class]])
    {
        static NSString *movingPointReuseIndetifier = @"movingPointAnnotationReuseIndetifier";
        EHMovingAnnotationView*  annotationView = (EHMovingAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:movingPointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[EHMovingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:movingPointReuseIndetifier];
        }
        annotationView.draggable = NO;               //设置标注可以拖动，默认为NO
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, 0);
        /*if ([KSAuthenticationCenter isTestAccount]) {
            [annotationView setImage:self.default_baby_map_header_image];
        }else*/
        {
            __typeof(annotationView) __weak __block weakAnnotationView = annotationView;
            [annotationView sd_setImageWithURL:[NSURL URLWithString:self.babyUserInfo.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUserInfo.babyId newPlaceHolderImagePath:self.babyUserInfo.babyHeadImage defaultHeadImage:self.headerViewImage] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                __typeof(annotationView) __strong strongAnnotationView = weakAnnotationView;
                if (image) {
                    image = [image roundedCornerImage:image.size.width/2 borderSize:0];
                    image = [image getCirleBoaderWithBorderColor:UINAVIGATIONBAR_COMMON_COLOR withBorderWidth:map_header_image_border];
                    strongAnnotationView.image = image;
                }
            } imageSize:self.headerViewImage.size];
        }
        
        
        annotationView.enabled = NO;
        
        return annotationView;
    }
    
    return [super mapView:mapView viewForAnnotation:annotation];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (!self.isRegionDidChangePostion) {
        self.coordinationInterpolation.distance = coordinationInterpolationDistance * [self.mapView metersPerPointForCurrentZoomLevel];
        self.movingPositions = nil;
        [self startMoving];
    }
}

@end
