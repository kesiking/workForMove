//
//  EHMapMovingAnnotationPolylineContainer.h
//  eHome
//
//  Created by 孟希羲 on 15/8/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapPolylineContainer.h"

@class EHMapMovingAnnotationPolylineContainer;

typedef void (^doMovingAnnotationViewDidStartBlock)       (EHMapMovingAnnotationPolylineContainer* mapContainer);

typedef void (^doMovingAnnotationViewDidStopBlock)        (EHMapMovingAnnotationPolylineContainer* mapContainer);

@interface EHMapMovingAnnotationPolylineContainer : EHMapPolylineContainer

@property (nonatomic, copy)   doMovingAnnotationViewDidStartBlock      doMovingAnnotationViewDidStart;

@property (nonatomic, copy)   doMovingAnnotationViewDidStopBlock       doMovingAnnotationViewDidStop;

@property (nonatomic, assign) BOOL                                     isMovingFinished;

- (void)startMoving;

@end
