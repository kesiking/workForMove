//
//  EHMapViewContainer.h
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHBabyLocationAnnotationView.h"

#define MAP_DEFAULT_ZOOM_SCALE (17.5)

@interface EHMapViewContainer : KSView <MAMapViewDelegate>
{
    MAMapView *_mapView;
}

@property (nonatomic, strong) MAMapView      *            mapView;

@property (nonatomic, strong) NSMutableArray *            annotationArray;

-(void)reloadData;

-(void)resetMap;

-(void)mapOnClickedWithMapView:(MAMapView*)mapView touchMapCoordinate:(CLLocationCoordinate2D)touchMapCoordinate;

@end
