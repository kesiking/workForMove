//
//  EHRadiusSliderView.h
//  eHome
//
//  Created by xtq on 15/9/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RadiusChangedBlock)(NSInteger radius);

@interface EHRadiusSliderView : UIView

@property (nonatomic, assign) NSInteger radius;

@property (nonatomic, assign) CGFloat minimumValue;

@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, strong) RadiusChangedBlock radiusChangedBlock;

@end
