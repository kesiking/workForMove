//
//  EHHealthyBasicView.m
//  eHome
//
//  Created by 钱秀娟 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicView.h"
#import "Masonry.h"

@implementation EHHealthyBasicView
- (void)setupView
{
    [self setupFirstView];
    [self setupSecondView];
    [self setupThirdView];
    [self setupFourthView];
}

- (void)setupFirstView
{
    if (!self.firstView) {
        self.firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105*SCREEN_SCALE)];
    }
    [self addSubview:self.firstView];

    self.firstBgImageView = [[UIImageView alloc]initWithFrame:self.firstView.frame];
    self.firstBgImageView.image = [UIImage imageNamed:@"bg_date"];
    [self.firstView addSubview:self.firstBgImageView];
    
    self.babyHeadBtn=[[UIButton alloc]init];
    self.babyHeadBtn.userInteractionEnabled = NO;
    self.babyHeadBtn.layer.masksToBounds=YES;
    self.babyHeadBtn.layer.cornerRadius=13*SCREEN_SCALE;
    [self.firstView addSubview:_babyHeadBtn];
    [self.babyHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstView.mas_top).offset(18*SCREEN_SCALE);
        make.left.equalTo(_firstView.mas_left).offset(12*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(26*SCREEN_SCALE, 26*SCREEN_SCALE));
    }];
    
//    self.babyNameLabel=[[UILabel alloc]init];
//    self.babyNameLabel.font=EH_font6;
//    self.babyNameLabel.textColor=EH_cor1;
//    self.babyNameLabel.textAlignment=NSTextAlignmentCenter;
//    [self.firstView addSubview:_babyNameLabel];
//    [self.babyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_babyHeadBtn.mas_centerX);
//        make.top.equalTo(_babyHeadBtn.mas_bottom).offset(5*SCREEN_SCALE);
//        make.size.mas_equalTo(CGSizeMake(75*SCREEN_SCALE, 15*SCREEN_SCALE));
//    }];
    
    
    self.dateLabel=[[UILabel alloc]init];
    self.dateLabel.textColor = [UIColor whiteColor];
    
    [self.dateLabel sizeToFit];
    [self.firstView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(_lastBtn.mas_right).offset(15*SCREEN_SCALE);
        ////        make.right.equalTo(_nextBtn.mas_right).offset(-15);
        make.centerY.equalTo(self.babyHeadBtn.mas_centerY);
        make.height.mas_equalTo(44.0);
        //        make.top.equalTo(_firstView.mas_top).offset(18*SCREEN_SCALE);
        make.centerX.equalTo(_firstView.mas_centerX);
    }];
    
    self.calendarBtn = [[UIButton alloc]init];
//    self.calendarBtn.backgroundColor = [UIColor redColor];
    [self.calendarBtn setBackgroundImage:[UIImage imageNamed:@"icon_calendar"] forState:UIControlStateNormal];
    
    [self.firstView addSubview:_calendarBtn];
    [self.calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstView.mas_top).offset(18*SCREEN_SCALE);
        make.right.equalTo(_firstView.mas_right).offset(-12*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(26*SCREEN_SCALE, 26*SCREEN_SCALE));
    }];
    
    //create carousel
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 60, 375, 40)];
    _carousel.type = iCarouselTypeLinear;
    
    UIImageView *circleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_tbar_dayweekmonth"]];
    circleImage.frame = CGRectMake(_carousel.width/2-15, 4, 31, 31);
    [_carousel addSubview:circleImage];
    //add carousel to view
    [self addSubview:_carousel];
    
}

- (void)setupSecondView
{
    
    if (!self.secondView) {
        self.secondView=[[UIView alloc]initWithFrame:CGRectMake(0, 105*SCREEN_SCALE, SCREEN_WIDTH, 152.5*SCREEN_SCALE)];
    }
    [self addSubview:self.secondView];
    
    self.sTargetStepsLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    self.sTargetStepsLabel.text=@"目标：8000步";
    self.sTargetStepsLabel.textColor= EH_cor9;
    self.sTargetStepsLabel.font=[UIFont systemFontOfSize:EH_siz4];
    self.sTargetStepsLabel.textAlignment=NSTextAlignmentCenter;
    [self.sTargetStepsLabel sizeToFit];
    [self.secondView addSubview:self.sTargetStepsLabel];
    [self.sTargetStepsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom).offset(39*SCREEN_SCALE);
        make.centerX.equalTo(self.mas_centerX);
       
    
    }];

    
    self.finishSteps=[[UILabel alloc]initWithFrame:CGRectZero];
    self.finishSteps.text=@"3";
    self.finishSteps.textColor=[UIColor redColor];
    self.finishSteps.font=[UIFont systemFontOfSize:EH_size10];
    self.finishSteps.textAlignment=NSTextAlignmentCenter;
//     [self.finishSteps sizeToFit];

    //UiLabel自适应
    NSDictionary *attributesq = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_size10]forKey:NSFontAttributeName];
    CGSize sizeForLabelq = [self.finishSteps.text boundingRectWithSize:CGSizeMake(380, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributesq context:nil].size;
    self.finishSteps.size = sizeForLabelq;
//    CGFloat height = sizeForLabelq.height;
//    self.finishSteps.height = 75.0;
//    self.finishSteps.width = 380.0;
    
    [self.secondView addSubview:self.finishSteps];
    [self.finishSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.sTargetStepsLabel.mas_bottom).offset(17*SCREEN_SCALE);
//        make.size.mas_equalTo(CGSizeMake(sizeForLabelq.width, sizeForLabelq.height));
      
    }];
    
    self.step=[[UILabel alloc]initWithFrame:CGRectZero];
    self.step.text=@"步";
    self.step.font=[UIFont systemFontOfSize:EH_siz2];
    self.step.textColor= EH_cor9;
    [self.step sizeToFit];
    [self.secondView addSubview:self.step];
    [self.step mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishSteps.mas_right).offset(13*SCREEN_SCALE);
        make.bottom.equalTo(self.finishSteps.mas_bottom);

    }];

    
    
}



- (void)setupThirdView
{
    if (!self.thirdView) {
        self.thirdView=[[UIView alloc]initWithFrame:CGRectMake(0, 257.5*SCREEN_SCALE, SCREEN_WIDTH, 62*SCREEN_SCALE)];
    }
//    self.thirdView.backgroundColor=[UIColor grayColor];
    [self addSubview:self.thirdView];
    
    
    //距离
    self.sDistanceLabel=[[UILabel alloc]init];
    self.sDistanceLabel.text=@"距离";
    self.sDistanceLabel.textColor=EH_cor3;
    self.sDistanceLabel.font=EH_font6;
    self.sDistanceLabel.textAlignment=NSTextAlignmentCenter;
    [self.sDistanceLabel sizeToFit];
    [self.thirdView addSubview:_sDistanceLabel];
    [self.sDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom).offset(14*SCREEN_SCALE);
        make.left.equalTo(self.mas_left).offset(42*SCREEN_SCALE);
//        make.size.mas_equalTo(CGSizeMake(50*SCREEN_SCALE, 15*SCREEN_SCALE));
    }];
    
    self.distanceLabel=[[UILabel alloc]init];
    self.distanceLabel.text=@"0千米";
    self.distanceLabel.textColor=EH_cor14;
    self.distanceLabel.font=EH_font4;
    self.distanceLabel.textAlignment=NSTextAlignmentCenter;
    [self.distanceChart sizeToFit];
    [self.thirdView addSubview:_distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sDistanceLabel.mas_bottom).offset(7*SCREEN_SCALE);
        make.centerX.equalTo(self.sDistanceLabel.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(50*SCREEN_SCALE, 15*SCREEN_SCALE));
    }];

    //热量
    self.sEnergyLabel=[[UILabel alloc]init];
    self.sEnergyLabel.text=@"热量";
    self.sEnergyLabel.textColor=EH_cor3;
    self.sEnergyLabel.font=EH_font6;
    self.sEnergyLabel.textAlignment=NSTextAlignmentCenter;
    [self.sEnergyLabel sizeToFit];
    [self.thirdView addSubview:_sEnergyLabel];
    [self.sEnergyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom).offset(14*SCREEN_SCALE);
        make.centerX.equalTo(self.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(50*SCREEN_SCALE, 15*SCREEN_SCALE));
    }];
    
    self.energyLabel=[[UILabel alloc]init];
    self.energyLabel.text=@"0千卡";
    self.energyLabel.textColor=EH_cor15;
    self.energyLabel.font=EH_font4;
    self.energyLabel.textAlignment=NSTextAlignmentCenter;
    [self.energyChart sizeToFit];
    [self.thirdView addSubview:_energyLabel];
    [self.energyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sEnergyLabel.mas_bottom).offset(7*SCREEN_SCALE);
        make.centerX.equalTo(_sEnergyLabel.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(50*SCREEN_SCALE, 15*SCREEN_SCALE));
    }];

    //完成率
    self.sRatioLabel=[[UILabel alloc]init];
    self.sRatioLabel.text=@"完成";
    self.sRatioLabel.textColor=EH_cor3;
    self.sRatioLabel.font=EH_font6;
    self.sRatioLabel.textAlignment=NSTextAlignmentCenter;
    [self.sRatioLabel sizeToFit];
    [self.thirdView addSubview:_sRatioLabel];
    [self.sRatioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom).offset(14*SCREEN_SCALE);
        make.right.equalTo(self.mas_right).offset(-42*SCREEN_SCALE);
//        make.size.mas_equalTo(CGSizeMake(50*SCREEN_SCALE, 15*SCREEN_SCALE));
    }];
    
    self.ratioLabel=[[UILabel alloc]init];
    self.ratioLabel.text=@"90%";
    self.ratioLabel.textColor=EH_cor16;
    self.ratioLabel.font=EH_font4;
    self.ratioLabel.textAlignment=NSTextAlignmentCenter;
    [self.ratioLabel sizeToFit];
    [self.thirdView addSubview:_ratioLabel];
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sRatioLabel.mas_bottom).offset(7*SCREEN_SCALE);
        make.centerX.equalTo(_sRatioLabel.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(50*SCREEN_SCALE, 15*SCREEN_SCALE));
    }];
    
    self.lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.lineOne.backgroundColor = EH_cor17;
    [self.thirdView addSubview:self.lineOne];
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.mas_top).offset(0*SCREEN_SCALE);
        make.centerX.equalTo(self.thirdView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
//    
    self.lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.lineTwo.backgroundColor = EH_cor17;
    [self.thirdView addSubview:self.lineTwo];
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thirdView.mas_bottom).offset(0*SCREEN_SCALE);
        make.centerX.equalTo(self.thirdView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    self.lineThree = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 34*SCREEN_SCALE)];
    self.lineThree.backgroundColor = EH_cor17;
    [self.thirdView addSubview:self.lineThree];
    [self.lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdView.mas_left).offset(SCREEN_WIDTH/3.0);
        make.centerY.equalTo(self.thirdView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 34*SCREEN_SCALE));
    }];
    
    self.lineFour = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 34*SCREEN_SCALE)];
    self.lineFour.backgroundColor = EH_cor17;
    [self.thirdView addSubview:self.lineFour];
    [self.lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.thirdView.mas_right).offset(-SCREEN_WIDTH/3.0);
        make.centerY.equalTo(self.thirdView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 34*SCREEN_SCALE));
    }];
    
    
    
    
    
}

- (void)setupFourthView
{
    if (!self.fourthView) {
        self.fourthView=[[UIView alloc]initWithFrame:CGRectMake(0, 319.5*SCREEN_SCALE, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height-319.5*SCREEN_SCALE-49-64)];
    }
    
    [self addSubview:self.fourthView];
    
    //添加柱状图
    
    //   3个笑脸
    
    self.badSmileView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_healthhome_weekmonth_bad"]];
    [self.fourthView addSubview:self.badSmileView];
    self.sosoSmileView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_healthhome_weekmonth_soso"]];
    [self.fourthView addSubview:self.sosoSmileView];
    self.bgChartView = [[UIView alloc]initWithFrame:CGRectMake(34.5*SCREEN_SCALE, 50*SCREEN_SCALE, SCREEN_WIDTH-44.5*SCREEN_SCALE, 201*SCREEN_SCALE)];
    [self.fourthView addSubview:self.bgChartView];
    
    self.lineViewOne = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_histogram_line"]];
    [self.bgChartView addSubview:self.lineViewOne];
    self.lineViewTwo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_histogram_line"]];
    [self.bgChartView addSubview:self.lineViewTwo];
    self.lineViewThree = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_histogram_line"]];
    [self.bgChartView addSubview:self.lineViewThree];
    self.lineViewFour = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_histogram_line"]];
    [self.bgChartView addSubview:self.lineViewFour];
    self.barChart=[[PNBarChart alloc]initWithFrame:CGRectMake(0,0,self.bgChartView.size.width,self.bgChartView.size.height)];
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.clipsToBounds = NO;
    [self.bgChartView addSubview:self.barChart];
    
//    self.maxLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.maxLabel.text = @"";
//    self.maxLabel.textColor=EH_cor5;
//    self.maxLabel.font=[UIFont systemFontOfSize:EH_siz7];
//    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz7]forKey:NSFontAttributeName];
//    CGSize sizeForDateLabel=[@"100" boundingRectWithSize:CGSizeMake(200, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    self.maxLabel.height = sizeForDateLabel.height;
//    
//    [self.fourthView addSubview:self.maxLabel];
    
    
    
    self.maxYValueLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.maxYValueLabel.text = @"0";
    self.maxYValueLabel.textColor=EH_cor5;
    self.maxYValueLabel.font=[UIFont systemFontOfSize:EH_siz7];
    
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz7]forKey:NSFontAttributeName];
    CGSize sizeForDateLabel2=[self.maxYValueLabel.text boundingRectWithSize:CGSizeMake(400, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
    self.maxYValueLabel.height = sizeForDateLabel2.height;
    
    [self.barChart addSubview:self.maxYValueLabel];
    
    //添加约束
    [self.maxYValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barChart.mas_top).offset(0*SCREEN_SCALE);
        make.left.equalTo(self.barChart.mas_left).offset(0*SCREEN_SCALE);
    }];
    
    [self.sosoSmileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maxYValueLabel.mas_bottom).offset(40*SCREEN_SCALE);
        make.left.equalTo(self.fourthView.mas_left).offset(10*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(17*SCREEN_SCALE, 17*SCREEN_SCALE));
    }];
    [self.badSmileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sosoSmileView.mas_bottom).offset(40*SCREEN_SCALE);
        make.left.equalTo(self.fourthView.mas_left).offset(10*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(17*SCREEN_SCALE, 17*SCREEN_SCALE));
    }];
    //    [self.bgChartView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.thirdView.mas_top).offset(50*SCREEN_SCALE);
    //        make.left.equalTo(self.thirdView.mas_left).offset(34.5*SCREEN_SCALE);
    //        //        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-75)*SCREEN_SCALE, 201*SCREEN_SCALE));
    //    }];
    [self.lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fourthView.mas_top).offset(50*SCREEN_SCALE-1);
        make.left.equalTo(self.fourthView.mas_left).offset(34.5*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-44.5*SCREEN_SCALE, 1));
    }];
    [self.lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewOne.mas_bottom).offset(57*SCREEN_SCALE-1);
        make.left.equalTo(self.fourthView.mas_left).offset(34.5*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-44.5*SCREEN_SCALE, 1));
    }];
    [self.lineViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewTwo.mas_bottom).offset(57*SCREEN_SCALE-1);
        make.left.equalTo(self.fourthView.mas_left).offset(34.5*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-44.5*SCREEN_SCALE, 1));
    }];
    [self.lineViewFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fourthView.mas_top).offset(57*3*SCREEN_SCALE+50*SCREEN_SCALE-1);
        make.left.equalTo(self.fourthView.mas_left).offset(34.5*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-44.5*SCREEN_SCALE, 1));
    }];
    
    
//    [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.fourthView.mas_left).with.offset(34.5*SCREEN_SCALE);
//        make.bottom.equalTo(self.lineViewOne.mas_top).with.offset(-5*SCREEN_SCALE);
//        //        make.size.mas_equalTo(CGSizeMake(110*SCREEN_SCALE, 21*SCREEN_SCALE));
//    }];
    
    
    
}



@end
