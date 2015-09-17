//
//  EHMovingPointAnnotation.h
//  eHome
//
//  Created by 孟希羲 on 15/8/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface EHMovingPointAnnotation : MAPointAnnotation

@property (nonatomic, strong) NSArray      *movingPositions;

@end
