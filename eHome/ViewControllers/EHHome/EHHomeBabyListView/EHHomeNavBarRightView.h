//
//  EHHomeNavBarRightView.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

@class EHHomeNavBarRightView;

typedef void (^doNavBarRightButtonClicedBlock)        (EHHomeNavBarRightView* EHHomeNavBarRightView);

@interface EHHomeNavBarRightView : KSView

@property (nonatomic, strong) UIButton              *btn;

@property (nonatomic, strong) UIImageView           *pointImage;

@property (nonatomic, copy  ) doNavBarRightButtonClicedBlock    buttonClickedBlock;

-(void)setupPointImageStatusWithNumber:(NSNumber*)number;

@end
