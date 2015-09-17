//
//  EHHealthyShareViewController.h
//  eHome
//
//  Created by 钱秀娟 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface EHHealthyShareViewController : UIViewController
@property(strong,nonatomic)NSNumber *sharedBabyId;
@property(strong,nonatomic)NSString *sharedBabyName;
@property(strong,nonatomic)NSString *sharedDate;
@property(strong,nonatomic)NSString *sharedHeadImage;
@property(strong,nonatomic)NSNumber *babySex;
@property(strong,nonatomic)NSNumber *sharedFinishedSteps;

@property(strong,nonatomic)NSNumber *sharedDistance;
@property (strong,nonatomic) UILabel *distanceDigitLabel;
@property (strong,nonatomic) UILabel *energyDigitLabel;
@property (strong,nonatomic) UILabel *finishDigitRateLabel;

//完成步数
@property (nonatomic,strong) UILabel *finishedSteps;
@property(strong,nonatomic) UILabel *babyTargetSteps;
//提示语
@property(strong,nonatomic)UILabel *markedWordsLabel;






@end
