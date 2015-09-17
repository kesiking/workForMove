//
//  EHBabyLocationAnnotationView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "EHBabyLocationCalloutView.h"
#import "EHUserDevicePosition.h"

#define MAP_SOS_ANNOTATION_IMAGE_VIEW_WIDTH     (27.0)
#define MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH  (30.0)
#define MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT (MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH)

@interface EHBabyLocationAnnotationView : MAAnnotationView

@property (nonatomic, strong) EHBabyLocationCalloutView *calloutView;

@property (nonatomic, strong) UIImageView               *selectImageView;

@property (nonatomic, strong) UIImageView               *annotationImageView;

@property (nonatomic, strong) EHUserDevicePosition      *position;

-(void)setAnnotationImage:(UIImage *)annotationImage;

@end
