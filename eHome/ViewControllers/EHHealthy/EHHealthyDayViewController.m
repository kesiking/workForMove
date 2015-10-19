//
//  EHHealthyDayViewController.m
//  eHome
//
//  Created by jweigang on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyDayViewController.h"
#import "CalendarViewController.h"

@interface EHHealthyDayViewController ()<EHHealthyDelegate, iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) EHHealthyDayService *queryDataService;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIImageView *circleImageView;
//当前切换到的日期
@property (strong, nonatomic) NSDate *currentDate;
@property(assign,nonatomic) BOOL show;
@end

@implementation EHHealthyDayViewController

#pragma mark - 生命周期方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self configItemsForDatasource];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    self.healthyView.carousel.dataSource = self;
    self.healthyView.carousel.delegate = self;
    
    //添加选中圆形视图
    [self.healthyView.carousel addSubview:self.circleImageView];
    [_circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.healthyView.carousel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    //柱状图参数配置
    self.healthyView.barChart.labelMarginTop = 0;
    self.healthyView.barChart.backgroundColor = [UIColor clearColor];
    self.healthyView.barChart.showChartBorder = NO;
    self.healthyView.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.currentDate = [NSDate date];
    self.previousIndex = [self.items count]-1;
    //每次进入健康页面显示“今天”数据
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    self.queryDataService.needCache = NO;
    self.queryDataService.onlyUserCache = NO;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self.dateFormatter stringFromDate:[NSDate date]]];
    
    self.show = YES;
}

//视图消失的时候把日历视图移除
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.healthyView.bgView && self.healthyView.calendarView) {
        [self.healthyView.bgView removeFromSuperview];
        [self.healthyView.calendarView removeFromSuperview];
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - EHHealthyDelegate方法
- (void)configDateBtnClick:(EHHealthyBasicView *)healthyView
{
    if (self.show) {
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        UIScrollView *supScrollView = (UIScrollView *)self.view.superview;
        supScrollView.scrollEnabled = NO;
        
        if (!healthyView.calendarVC) {
            healthyView.calendarVC = [CalendarViewController new];
            healthyView.calendarVC.selectedDate = self.currentDate;
        }
        healthyView.calendarVC.babyStartDate = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
        
        WEAKSELF
        [healthyView.calendarVC returnDateText:^(NSString *showSelectedDate){
            STRONGSELF
            NSDate *sdate=[strongSelf.dateFormatter dateFromString:showSelectedDate];
            NSString *selectedDateString = [strongSelf.dateFormatter stringFromDate:sdate];
            strongSelf.healthyView.dateLabel.text = selectedDateString;
            //点击日历返回，日期滚动条更新
            NSTimeInterval secondsInterval= [sdate timeIntervalSinceDate:self.startUserDay];
            NSInteger dayInterval = secondsInterval/(24*60*60)+1;
            [strongSelf.healthyView.carousel scrollToItemAtIndex:dayInterval animated:YES];
            supScrollView.scrollEnabled = YES;
            [strongSelf.healthyView.bgView removeFromSuperview];
            [strongSelf.healthyView.calendarView removeFromSuperview];
            strongSelf.healthyView.calendarVC.selectedDate = sdate;
            self.show = YES;
        }];
        if (!healthyView.bgView) {
            healthyView.bgView = [[UIView alloc]initWithFrame:window.bounds];
            
        }
        healthyView.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        if (!healthyView.calendarView) {
            healthyView.calendarView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, 374.5*SCREEN_SCALE+16.5*SCREEN_SCALE)];
        }
        
        healthyView.calendarView.backgroundColor = [UIColor whiteColor];
        
        UIView *canldara = healthyView.calendarVC.view;
        
        [healthyView.calendarVC.view setFrame:CGRectMake(0, 0, self.view.width, 374.5*SCREEN_SCALE)];
        [healthyView.calendarView addSubview:canldara];
        
        
        healthyView.calendarView.alpha = 0;
        [window addSubview:healthyView.bgView];
        [window addSubview:healthyView.calendarView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideCalendarView)];
        [healthyView.bgView addGestureRecognizer:tap];
        
        CGRect rectBegin = healthyView.calendarView.frame;
        rectBegin.origin.y = 73*SCREEN_SCALE+64;
        [healthyView.calendarView setFrame:rectBegin];
        
        CGRect rect = healthyView.calendarView.frame;
        rect.origin.y = 73*SCREEN_SCALE+64;
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            [healthyView.calendarView setFrame:rect];
            healthyView.calendarView.alpha = (NSUInteger)(1);
            healthyView.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
            
        } completion:nil];
        self.show = NO;

    }else{
        [self hideCalendarView];
//        self.show = YES;
        
        
    }
    
}
- (void)reloadDataWhenHeadBtnClick
{
    //更换宝贝后配置数据源
    self.healthyView.calendarVC = nil;
    [self configItemsForDatasource];
    self.currentDate = [NSDate date];
    [self.healthyView.carousel reloadData];
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    self.queryDataService.needCache = NO;
    self.queryDataService.onlyUserCache = NO;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self.dateFormatter stringFromDate:[NSDate date]]];
    
    //更新日历控件
    self.healthyView.calendarVC = [CalendarViewController new];
}
- (void)reloadDataWhenViewScroll
{
    self.currentDate = [NSDate date];
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    self.queryDataService.needCache = NO;
    self.queryDataService.onlyUserCache = NO;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self.dateFormatter stringFromDate:[NSDate date]]];
}
#pragma mark - 私有方法
//配置items数组
- (void)configItemsForDatasource
{
    self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    NSDate *currentDate = self.startUserDay;
    if(currentDate == nil)
    {
        EHLogError(@"the startUserDay is nil");
    }
    NSAssert(currentDate !=nil, @"startUserDay must not be nil");
    self.items = nil;
    if(!self.items){
        self.items = [[NSMutableArray alloc]init];
    }
    NSString *todayString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *currentDateString = [self.dateFormatter stringFromDate:currentDate];
    while (![currentDateString isEqualToString:todayString]) {
        [self.items addObject:@(currentDate.day)];
        currentDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];
        currentDateString = [self.dateFormatter stringFromDate:currentDate];
    }
    [self.items addObject:@([NSDate date].day)];
}
- (void)updateUIAfterService:(EHHealthyBasicModel *)model withView:(EHHealthyBasicView *)healthyView
{
    EHHealthyDayModel *dayModel=(EHHealthyDayModel *)model;
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self hideLoadingView];
        [self hideErrorView];
        
        static NSDateFormatter *myDateFormatter = nil;
        if (myDateFormatter == nil) {
            myDateFormatter = [[NSDateFormatter alloc]init];
            [myDateFormatter setDateFormat:@"yyyy年MM月"];
        }
        healthyView.dateLabel.text = [myDateFormatter stringFromDate:self.currentDate];
        healthyView.calendarVC.selectedDate = self.currentDate;
        NSString *dateString = [self.dateFormatter stringFromDate:self.currentDate];
        NSString *todayString = [self.dateFormatter stringFromDate:[NSDate date]];
        if ([dateString isEqual:todayString]) {
            healthyView.dateLabel.text = @"今天";
        }
        healthyView.sTargetStepsLabel.text = [NSString stringWithFormat:@"目标：%ld步",dayModel.target_steps];
        healthyView.finishSteps.text=[NSString stringWithFormat:@"%ld",(long)dayModel.steps];
        if (dayModel.mileage == 0) {
            healthyView.distanceLabel.text= @"0米";
        }else{
            if (dayModel.mileage<1000) {
                healthyView.distanceLabel.text=[NSString stringWithFormat:@"%ld米",dayModel.mileage];
            }else{
                healthyView.distanceLabel.text=[NSString stringWithFormat:@"%.3f千米",dayModel.mileage/1000.0];
                
            }
 
        }
        healthyView.energyLabel.text=[NSString stringWithFormat:@"%ld千卡",dayModel.calorie];
        healthyView.ratioLabel.text=[NSString stringWithFormat:@"%@%%",dayModel.percent];
        [healthyView.distanceChart updateChartByCurrent:[NSNumber numberWithInteger:[dayModel.percent integerValue]]];
        [healthyView.energyChart updateChartByCurrent:[NSNumber numberWithInteger:[dayModel.percent integerValue]]];
        [healthyView.ratioChart updateChartByCurrent:[NSNumber numberWithInteger:[dayModel.percent integerValue]]];
        if (!dayModel.responseData) {
            return;
        }
        [healthyView.barChart setYValues:dayModel.responseData];
        NSNumber* max1=[dayModel.responseData valueForKeyPath:@"@max.intValue"];
        
        long maxValue = [max1 integerValue];
        //截断最大值，如果<500,取到500，如果<1000,取到1000(0的话取0)
        if (maxValue <= 500) {
            if (maxValue == 0) {
                maxValue = 0;
            }else{
                maxValue = 500;
            }
            
        }else if (maxValue <= 1000){
            maxValue = 1000;
        }else{
            int trail = maxValue%1000;
            if (trail < 500) {
                maxValue = (maxValue/1000) *1000 +500;
            }else{
                maxValue = (maxValue/1000) *1000 +1000;
            }
        }
        
        if (maxValue == 0) {
            healthyView.maxYValueLabel.text = [NSString stringWithFormat:@"%ld",dayModel.target_steps];
            healthyView.middleValueLabel.text = [NSString stringWithFormat:@"%ld",dayModel.target_steps/2];
        }else{
            healthyView.maxYValueLabel.text = [NSString stringWithFormat:@"%ld",maxValue];
            healthyView.middleValueLabel.text = [NSString stringWithFormat:@"%ld",maxValue/2];
        }
        
        NSMutableArray *colors = [NSMutableArray new];
        int index = 0;
        for (NSNumber *bb in dayModel.responseData) {
            if ([bb intValue] == [max1 intValue]) {
                break;
            }
            else
                index++;
        }
        for (int i=0 ;i<[dayModel.responseData count];i++) {

            UIColor *color = EHCor13;
            [colors addObject:color];
            
        }
        [healthyView.barChart setStrokeColors:colors];
        
        
        double barMargin = 17.5*SCREEN_SCALE;
        double barWidth = ((SCREEN_WIDTH-28*SCREEN_SCALE-31*SCREEN_SCALE) -10*SCREEN_SCALE-(colors.count-1)*barMargin)/(colors.count*1.0);
        
        [healthyView.barChart setDayXLabels:@[@"0-6",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20-24"] andMargin:barMargin andWidth:barWidth];
        [healthyView.barChart strokeChartWeekWithMargin:barMargin andWidth:barWidth];
        
        [healthyView.bgChartView bringSubviewToFront:healthyView.maxYValueLabel];
        [healthyView.bgChartView bringSubviewToFront:healthyView.middleValueLabel];
    });
}
//showErrorView刷新回调方法
-(void)refreshDataRequest{
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self.dateFormatter stringFromDate:self.currentDate]];
}
- (void)hideCalendarView{
    self.show = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.healthyView.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
//        self.healthyView.calendarView.layer.transform = CATransform3DMakeTranslation(0, -CGRectGetHeight(self.healthyView.calendarView.frame), 0);
    } completion:^(BOOL finished) {
        [self.healthyView.bgView removeFromSuperview];
        [self.healthyView.calendarView removeFromSuperview];
        UIScrollView *supRScrollView = (UIScrollView *)self.view.superview;
        supRScrollView.scrollEnabled = YES;
    }];
}
#pragma mark - 懒加载queryDataService,dateFormatter,circleImageView
-(EHHealthyDayService *)queryDataService{
    [self showLoadingView];
    if (!_queryDataService) {
        _queryDataService = [EHHealthyDayService new];
        // service 返回成功 block
        WEAKSELF
        _queryDataService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            EHLogInfo(@"服务器返回数据成功");
            EHHealthyDayModel *healthyDayModel=(EHHealthyDayModel *)service.item;
            strongSelf.dayVCmodel = healthyDayModel;
            dispatch_async( dispatch_get_main_queue(), ^{
                //[strongSelf updateUIwithDataModel:healthyDayModel];
                [strongSelf updateUIAfterService:healthyDayModel withView:strongSelf.healthyView];
            });
        };
        // service 返回失败 block
        _queryDataService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            EHLogInfo(@"服务器返回数据失败");
            [strongSelf hideLoadingView];
            [strongSelf showErrorView:error];
        };
        // cache 返回成功 block
        _queryDataService.serviceCacheDidLoadBlock=^(WeAppBasicService* service, NSArray* cacheData)
        {
            
            EHLogInfo(@"本地返回数据成功");
            STRONGSELF
            if (cacheData) {
                EHHealthyDayModel *model=(EHHealthyDayModel *)cacheData[0];
                strongSelf.dayVCmodel=model;
                dispatch_async( dispatch_get_main_queue(), ^{
                    [strongSelf updateUIAfterService:model withView:strongSelf.healthyView];
                });
            }
            
        };
    }
    return _queryDataService;
}

// NSDateFormatter的创建比较慢，懒加载
- (NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}
- (UIImageView *)circleImageView
{
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"public_date_selected01"]];
    }
    return _circleImageView;
}
#pragma mark - iCarouselDataSource和iCarouselDelegate方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (!self.startUserDay) {
        return 1;
    }else{
        return [self.items count];
    }
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    UILabel *label = nil;
    if (view == nil) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 52*SCREEN_SCALE, 40*SCREEN_SCALE)];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 52*SCREEN_SCALE, 40*SCREEN_SCALE)];
        label.textColor = EHCor1;
        label.font = EH_font3;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    label.text=[self.items[(NSUInteger)index] stringValue];
    return view;
}
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 6;
}
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    UILabel *label = nil;
    if (view == nil) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 52*SCREEN_SCALE, 40*SCREEN_SCALE)];
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 52*SCREEN_SCALE, 40*SCREEN_SCALE)];
        label.textColor = EH_cor12;
        label.font = EH_font3;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    NSMutableArray *placeholderArr = [[NSMutableArray alloc]init];
    for (int i=3; i>=1; i--) {
        NSDate *preDate = [NSDate dateWithTimeInterval:-i*24*60*60 sinceDate:self.startUserDay];
        NSInteger prePlaceholder = preDate.day;
        [placeholderArr addObject:@(prePlaceholder)];
    }
    for (int j=1; j<=3; j++) {
        NSDate *nextDate = [NSDate dateWithTimeInterval:j*24*60*60 sinceDate:[NSDate date]];
        NSInteger nextPlaceholder = nextDate.day;
        [placeholderArr addObject:@(nextPlaceholder)];
    }
    label.text = [NSString stringWithFormat:@"%@",placeholderArr[index]];
    return view;
}
- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.03f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionVisibleItems:
        {
            return 7;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        {
            return value;
        }
    }
}
- (void)carouselWillBeginDragging:(iCarousel * __nonnull)carousel
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.circleImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.circleImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.circleImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    //比较是否和之前在同一位置，如果在同一位置不做刷新操作
    self.currentIndex = carousel.currentItemIndex;
    if (self.currentIndex == self.previousIndex) {
        return;
    }
    self.previousIndex = carousel.currentItemIndex;
    
    //更新currentDate的值
    self.currentDate = [NSDate dateWithTimeInterval:carousel.currentItemIndex*24*60*60 sinceDate:self.startUserDay];
//    self.queryDataService.onlyUserCache=YES;
    self.queryDataService.needCache = NO;
    self.queryDataService.onlyUserCache = NO;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self.dateFormatter stringFromDate:self.currentDate]];
}
@end
