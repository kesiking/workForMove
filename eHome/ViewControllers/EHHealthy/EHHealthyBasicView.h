//
//  EHHealthyBasicView.h
//  eHome
//
//  Created by 钱秀娟 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "PNChart.h"
#import "iCarousel.h"

@interface EHHealthyBasicView : KSView
/**
 *	第一个子视图，包括宝贝头像、昵称、显示日期、日期标签、日历标签、滑动条等
 */
@property(strong,nonatomic) UIView *firstView;

/**
 *	第二个子视图，包括步数、完成步数标签
 */
@property(strong,nonatomic) UIView *secondView;
/**
 *	第三个视图，包括距离比例、热量比例、完成步数比例三个子view
 */
@property(strong,nonatomic) UIView *thirdView;
/**
 *	第四个视图，包括整个柱状图、笑脸图、X坐标上的标签
 */
@property(strong,nonatomic) UIView *fourthView;

/**
 *	firstView包含的内容
 */
@property (strong, nonatomic) UIImageView *firstBgImageView;
@property(strong,nonatomic) UIButton *babyHeadBtn;
@property(strong,nonatomic) UILabel *babyNameLabel;
@property(strong,nonatomic) UILabel *dateLabel;
@property(strong,nonatomic) UIButton *calendarBtn;
@property (nonatomic, strong) iCarousel *carousel;

/**
 *	secondView包含的内容
 */
@property(strong,nonatomic) UILabel *sTargetStepsLabel;
//@property(strong,nonatomic) UILabel *targetStepsLabel;
@property(strong,nonatomic) UILabel *finishSteps;
@property(strong,nonatomic) UILabel *step;
/**
 *	thirdView包含的内容
 */


@property(strong,nonatomic) UILabel *sDistanceLabel;
@property(strong,nonatomic) UILabel *distanceLabel;
@property(strong,nonatomic) PNCircleChart *distanceChart;
@property(strong,nonatomic) UILabel *sEnergyLabel;
@property(strong,nonatomic) UILabel *energyLabel;
@property(strong,nonatomic) PNCircleChart *energyChart;
@property(strong,nonatomic) UILabel *sRatioLabel;
@property(strong,nonatomic) UILabel *ratioLabel;
@property(strong,nonatomic) PNCircleChart *ratioChart;

@property(strong,nonatomic) UIView *lineOne;
@property(strong,nonatomic) UIView *lineTwo;
@property(strong,nonatomic) UIView *lineThree;
@property(strong,nonatomic) UIView *lineFour;


/**
 *	fourthView包含的内容
 */
@property(strong,nonatomic) PNBarChart *barChart;


//y轴的Label
@property(strong,nonatomic)UILabel *maxYValueLabel;
@property(strong,nonatomic)UILabel *middleValueLabel;
@property(strong,nonatomic)UILabel *minYValueLabel;

@property(strong,nonatomic)UIView *bgChartView;
@property(strong,nonatomic)UIImageView *lineViewOne;
@property(strong,nonatomic)UIImageView *lineViewTwo;
@property(strong,nonatomic)UIImageView *lineViewThree;
@property(strong,nonatomic)UIImageView *lineViewFour;
@property (strong, nonatomic)UILabel *totalStepsLabel;


@property(assign,nonatomic)NSInteger numberOfInstance;
@property(strong,nonatomic)NSNumber *page;

//@property (strong, nonatomic)UILabel *maxLabel;

@end
