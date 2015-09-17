//
//  EHBabyLocationCalloutView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHUserDevicePosition.h"

#define kCalloutWidthWithNavBtn    (kCalloutWidth + kCalloutNavBtnWidth)
#define kCalloutWidth              (255.0)
#define kCalloutHeight             (60.0)
#define kCalloutNavBtnWidth        (44)

@interface EHBabyLocationCalloutView : KSView

@property (nonatomic, strong) UIImageView          *bgImageView;

@property (nonatomic, strong) UIImageView          *timerImageView;
@property (nonatomic, strong) UILabel              *timerLabel;

@property (nonatomic, strong) UIImageView          *batteryImageView;
@property (nonatomic, strong) UILabel              *batteryLabel;

@property (nonatomic, strong) UIImageView          *statusImageView;
@property (nonatomic, strong) UILabel              *locationLabel;

@property (nonatomic, strong) UIImageView          *babyHeadImageView;

@property (nonatomic, strong) UIButton             *navigationBtn;

@property (nonatomic, strong) EHUserDevicePosition *position;

-(void)reloadData;

@end
