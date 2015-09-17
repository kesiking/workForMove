//
//  EHMapPolylineContainer.h
//  eHome
//
//  Created by 孟希羲 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapServiceContainer.h"

@interface EHMapPolylineContainer : EHMapServiceContainer

@property (nonatomic, assign) NSUInteger              endMovingPositionIndex;

@property (nonatomic, strong) MAPolyline *            polylineOverLay;

-(void)resetMapPolylineOverLay;

-(void)resizeMapRegion;

@end
