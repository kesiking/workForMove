//
//  EHPositionAnnotation.h
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "EHUserDevicePosition.h"

@interface EHPositionAnnotation : MAPointAnnotation

@property (nonatomic, strong) EHUserDevicePosition      *position;

@end
