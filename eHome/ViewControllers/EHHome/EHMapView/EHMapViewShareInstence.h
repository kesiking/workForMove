//
//  EHMapViewShareInstence.h
//  eHome
//
//  Created by 孟希羲 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHMapMovingAnnotationPolylineContainer.h"

@interface EHMapViewShareInstence : NSObject

+ (instancetype)sharedCenter;

- (EHMapMovingAnnotationPolylineContainer*)getMapViewWithFrame:(CGRect)frame;

@property (nonatomic, strong) EHMapMovingAnnotationPolylineContainer        *mapView;

- (void)resetMapWithMapContainter:(EHMapViewContainer*)mapContainer;

@end
