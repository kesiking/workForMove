//
//  EHMapViewShareInstence.m
//  eHome
//
//  Created by 孟希羲 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapViewShareInstence.h"

@interface EHMapViewShareInstence()

@property(nonatomic,assign) CGRect              frame;

@end

@implementation EHMapViewShareInstence

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

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
    [self resetMapWithMapContainter:_mapView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  mapview、navBarTItleView

- (EHMapMovingAnnotationPolylineContainer*)getMapViewWithFrame:(CGRect)frame{
    self.frame = frame;
    [self.mapView setFrame:frame];
    return self.mapView;
}

- (EHMapMovingAnnotationPolylineContainer *)mapView{
    if (_mapView == nil) {
        _mapView = [[EHMapMovingAnnotationPolylineContainer alloc] initWithFrame:self.frame];
    }
    return _mapView;
}

- (void)resetMapWithMapContainter:(EHMapViewContainer*)mapContainer{
    // 多实例可清除 -- map多实例方案
    mapContainer = nil;
}


@end
