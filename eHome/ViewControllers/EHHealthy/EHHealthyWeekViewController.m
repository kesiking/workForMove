//
//  EHHealthyWeekViewController2.m
//  eHome
//
//  Created by 钱秀娟 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyWeekViewController.h"
#import "EHGetHealthyWeekInfoService.h"
#import "EHHealthWeekInfoModel.h"



@interface EHHealthyWeekViewController ()<EHHealthyDelegate,iCarouselDataSource, iCarouselDelegate>
@property(assign,nonatomic)BOOL stop;
@property(assign,nonatomic)BOOL reachStop;
@property(assign,nonatomic)NSInteger totalWeek;
@property(strong,nonatomic)NSMutableArray* allWeekIndexArray;

@property(strong,nonatomic)NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIImageView *ellipseImageView;
@property(assign,nonatomic) BOOL show;
@end

@implementation EHHealthyWeekViewController

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
    self.stop = NO;
    self.totalWeek = 0;
    self.healthyView.calendarBtn.hidden = YES;
    
    //添加选中椭圆视图
    [self.healthyView.carousel addSubview:self.ellipseImageView];
    [self.ellipseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.healthyView.carousel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 30));
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
    self.currentWeek = 0;
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    self.previousIndex = [self.items count]-1;
    NSString *date = [self.dateFormatter stringFromDate:[NSDate date]];
    [self configDateLabelText];
    self.queryWeekInfoListService.needCache = NO;
    self.queryWeekInfoListService.onlyUserCache = NO;
    [self.queryWeekInfoListService getHealthWeekInfowithBabyID:[self.babyId integerValue] date:date type:@"week"];
    self.show = YES;
    
}


#pragma mark - 私有方法
- (void)configDateLabelText
{
    static NSDateFormatter *myDateFormatter = nil;
    if (!myDateFormatter) {
        myDateFormatter = [[NSDateFormatter alloc]init];
        [myDateFormatter setDateFormat:@"yyyy年"];
    }
    self.healthyView.dateLabel.text = [myDateFormatter stringFromDate:[NSDate date]];
}
- (void)configItemsForDatasource
{
    self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    
    self.items = nil;
    if(!self.items){
        self.items = [[NSMutableArray alloc]init];
    }
    if (!self.allWeekIndexArray) {
        self.allWeekIndexArray = [[NSMutableArray alloc]init];
    }
    
    NSInteger count = 0;
    self.stop = NO;
    [self.items removeAllObjects];
    [self.allWeekIndexArray removeAllObjects];
    
    while (!self.stop) {
        [self getWeekBeginAndEndWith:count*(-7)];
        
        count++;
    }
    self.totalWeek = count;
    
    self.items = (NSMutableArray *)[[self.items reverseObjectEnumerator] allObjects];
    self.allWeekIndexArray = (NSMutableArray *)[[self.allWeekIndexArray reverseObjectEnumerator] allObjects];
}

-(void)getTotalWeek{
    NSInteger count = 0;
    self.stop = NO;
    while (!self.stop) {
        [self getWeekBeginAndEndWith:count*(-7)];
        
        count++;
    }
    self.totalWeek = count;
}
- (void)getWeekBeginAndEndWith:(NSInteger)count{
    NSDate *oldDate = [NSDate date];
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*count sinceDate:oldDate];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return;
    }
    static NSDateFormatter *myDateFormatter = nil;
    if (!myDateFormatter) {
        myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"MM.dd"];
    }
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSString *beginDateString=[self.dateFormatter stringFromDate:beginDate];
    self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    if (!self.startUserDay) {
        self.startUserDay=[NSDate dateWithTimeIntervalSinceReferenceDate:0];
    }
    NSString *startDateString=[self.dateFormatter stringFromDate:self.startUserDay];
    if ([beginDate daysEarlierThan:self.startUserDay]||[beginDateString isEqualToString:startDateString]) {
        self.stop = YES;
        self.reachStop = YES;
        
    }
    NSString *weekMargin = [NSString stringWithFormat:@"%@~%@",beginString,endString];
    [self.items addObject:weekMargin];
    [self.allWeekIndexArray addObject:beginDateString];
}


- (void)getTotalWeeksFromSelectedDate:(NSInteger)count andStartDate:(NSDate *)startDate{
    NSDate *oldDate = [NSDate date];
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*count sinceDate:oldDate];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return;
    }
    static NSDateFormatter *myDateFormatter = nil;
    if (!myDateFormatter) {
        myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"MM.dd"];
    }
    NSString *beginDateString=[self.dateFormatter stringFromDate:beginDate];
    NSString *startDateString=[self.dateFormatter stringFromDate:startDate];
    if ([beginDate daysEarlierThan:startDate]||[beginDateString isEqualToString:startDateString]) {
        self.reachStop = YES;
        
    }
}


- (NSString *)getSingleWeekBeginAndEndWith:(NSInteger)count{
    NSDate *oldDate = [NSDate date];
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*count sinceDate:oldDate];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return 0;
    }
    static NSDateFormatter *myDateFormatter = nil;
    if (!myDateFormatter) {
        myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"MM.dd"];
    }
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *weekMargin = [NSString stringWithFormat:@"%@~%@",beginString,endString];
    return weekMargin;
    
}

- (void)updateUIAfterService:(EHGetHealthyWeekInfoRsp *)model withView:(EHHealthyBasicView *)healthyView
{
    [self hideLoadingView];
    EHHealthWeekInfoModel* weekmodel = [[EHHealthWeekInfoModel alloc]init];
    weekmodel = model.responseData;
    
    NSString *beginDate = weekmodel.monday;
    NSString *endDate = weekmodel.sunday;
    NSString *beginString = [beginDate substringFromIndex:5];
    NSString *begina = [beginString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endString = [endDate substringFromIndex:5];
    NSString *enda = [endString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.selectedWeek = [NSString stringWithFormat:@"%@~%@",begina,enda];
    
    
    NSMutableArray* stepsdata = [NSMutableArray arrayWithCapacity:[weekmodel.data count]];
    for (int i =1; i<[weekmodel.data count];i++) {
        [stepsdata addObject:weekmodel.data[i]];
    }
    [stepsdata addObject:weekmodel.data[0]];
    [healthyView.barChart setYValues:stepsdata];
    healthyView.sTargetStepsLabel.text = [NSString stringWithFormat:@"目标：%ld步",model.targetSteps];
    healthyView.finishSteps.text=[NSString stringWithFormat:@"%ld",(long)model.steps];
    if(model.mileage == 0){
         healthyView.distanceLabel.text= @"0米";
        
    }else{
        if(model.mileage < 1000){
            healthyView.distanceLabel.text=[NSString stringWithFormat:@"%ld米",model.mileage];
        }else{
            healthyView.distanceLabel.text=[NSString stringWithFormat:@"%.3f千米",model.mileage/1000.0];
        }
    }
    healthyView.energyLabel.text=[NSString stringWithFormat:@"%ld千卡",model.calorie];
    healthyView.ratioLabel.text=[NSString stringWithFormat:@"%@%%",model.percent];
    [healthyView.distanceChart updateChartByCurrent:[NSNumber numberWithInteger:[model.percent integerValue]]];
    [healthyView.energyChart updateChartByCurrent:[NSNumber numberWithInteger:[model.percent integerValue]]];
    [healthyView.ratioChart updateChartByCurrent:[NSNumber numberWithInteger:[model.percent integerValue]]];
    
    
    NSNumber* max1=[stepsdata valueForKeyPath:@"@max.intValue"];
    
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
        healthyView.maxYValueLabel.text = [NSString stringWithFormat:@"%ld",model.targetSteps];
        healthyView.middleValueLabel.text = [NSString stringWithFormat:@"%ld",model.targetSteps/2];
        
    }else{
        healthyView.maxYValueLabel.text = [NSString stringWithFormat:@"%ld",maxValue];
        healthyView.middleValueLabel.text = [NSString stringWithFormat:@"%ld",maxValue/2];
    }

    
    NSMutableArray *colors = [NSMutableArray new];
    int index = 0;
    for (NSNumber *bb in stepsdata) {
        if ([bb intValue] == [max1 intValue]) {
            break;
        }
        else
            index++;
    }
    for (int i=0 ;i<[stepsdata count];i++) {
        
        UIColor *color = EHCor13;
        [colors addObject:color];
        
    }
        
    [healthyView.barChart setStrokeColors:colors];
    double barMargin = 30*SCREEN_SCALE;
    double barWidth = ((SCREEN_WIDTH-28*SCREEN_SCALE-31*SCREEN_SCALE) -10*SCREEN_SCALE-(colors.count-1)*barMargin)/(colors.count*1.0);
    
    [healthyView.barChart setXLabels:@[@"一",@"二",@"三",@"四",@"五",@"六",@"日"] andMargin:barMargin andWidth:barWidth];
    [healthyView.barChart strokeChartWeekWithMargin:barMargin andWidth:barWidth];
}




//showErrorView刷新回调方法
-(void)refreshDataRequest{
    NSDate *oldDate = [NSDate date];
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*self.currentWeek*7 sinceDate:oldDate];
    NSString *newDateString = [self.dateFormatter stringFromDate:newDate];
    self.queryWeekInfoListService.needCache = NO;
    self.queryWeekInfoListService.onlyUserCache = NO;
    [self.queryWeekInfoListService getHealthWeekInfowithBabyID:[self.babyId integerValue] date:newDateString type:@"week"];
    
}

#pragma mark - EHHealthyDelegate方法
- (void)reloadDataWhenHeadBtnClick{
    NSInteger count = 0;
    self.stop = NO;
    [self.items removeAllObjects];
    [self.allWeekIndexArray removeAllObjects];
    
    while (!self.stop) {
        [self getWeekBeginAndEndWith:count*(-7)];
        
        count++;
    }
    self.totalWeek = count;
    self.items = (NSMutableArray *)[[self.items reverseObjectEnumerator] allObjects];
    self.allWeekIndexArray = (NSMutableArray *)[[self.allWeekIndexArray reverseObjectEnumerator] allObjects];
    
    [self.healthyView.carousel reloadData];
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    
    NSString *date = [self.dateFormatter stringFromDate:[NSDate date]];
    [self configDateLabelText];
    self.queryWeekInfoListService.needCache = NO;
    self.queryWeekInfoListService.onlyUserCache = NO;
    [self.queryWeekInfoListService getHealthWeekInfowithBabyID:[self.babyId integerValue] date:date type:@"week"];
}
- (void)reloadDataWhenViewScroll
{
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    [self configDateLabelText];
    self.queryWeekInfoListService.needCache = NO;
    self.queryWeekInfoListService.onlyUserCache = NO;
    NSString *date = [self.dateFormatter stringFromDate:[NSDate date]];
    [self.queryWeekInfoListService getHealthWeekInfowithBabyID:[self.babyId integerValue] date:date type:@"week"];
}
- (void)configDateBtnClick:(EHHealthyBasicView *)healthyView
{
    if (self.show) {
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        
        UIScrollView *supScrollView = (UIScrollView *)self.view.superview;
        supScrollView.scrollEnabled = NO;
        if (!healthyView.calendarVC) {
            healthyView.calendarVC = [CalendarViewController new];
        }
        healthyView.calendarVC.babyStartDate = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
        
        WEAKSELF
        [healthyView.calendarVC returnDateText:^(NSString *showSelectedDate){
            STRONGSELF
            NSDate *sdate=[strongSelf.dateFormatter dateFromString:showSelectedDate];
            NSString *selectedDateString = [strongSelf.dateFormatter stringFromDate:sdate];
            strongSelf.healthyView.dateLabel.text = selectedDateString;
            //点击完日历的操作
            NSInteger acount = 0;
            strongSelf.reachStop = NO;
            
            while (!strongSelf.reachStop) {
                [strongSelf getTotalWeeksFromSelectedDate:acount*(-7) andStartDate:sdate];
                
                acount++;
            }
            
            NSInteger index = [self.items count] - acount;
            
            [strongSelf.healthyView.carousel scrollToItemAtIndex:index animated:YES];
            supScrollView.scrollEnabled = YES;
            [strongSelf.healthyView.bgView removeFromSuperview];
            [strongSelf.healthyView.calendarView removeFromSuperview];
            self.show = YES;
            
            
        }];
        if (!self.healthyView.bgView) {
            self.healthyView.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, window.bounds.size.width, window.bounds.size.height-60)];
            
        }
        self.healthyView.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        if (!self.healthyView.calendarView) {
            self.healthyView.calendarView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, 374.5*SCREEN_SCALE+16.5*SCREEN_SCALE)];
        }
        
        self.healthyView.calendarView.backgroundColor = [UIColor whiteColor];
        
        UIView *canldara = self.healthyView.calendarVC.view;
        
        [self.healthyView.calendarVC.view setFrame:CGRectMake(0, 0, self.view.width, 374.5*SCREEN_SCALE)];
        [self.healthyView.calendarView addSubview:canldara];
        self.healthyView.calendarView.alpha = 0;
        [self.view addSubview:self.healthyView.bgView];
        [self.view addSubview:self.healthyView.calendarView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(atap)];
        [self.healthyView.bgView addGestureRecognizer:tap];
        
        CGRect rect = self.healthyView.calendarView.frame;
        //日历控件往下偏移60px
        rect.origin.y = 60;
        //    [self.view bringSubviewToFront:self.babyListView];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            [self.healthyView.calendarView setFrame:rect];
            self.healthyView.calendarView.alpha = (NSUInteger)(1);
            self.healthyView.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
            
        } completion:nil];
        self.show = NO;
    }else{
        [self ahide];
        
    }
}

- (void)atap{
    [self ahide];
}

- (void)ahide{
    self.show = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.healthyView.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        self.healthyView.calendarView.layer.transform = CATransform3DMakeTranslation(0, -CGRectGetHeight(self.healthyView.calendarView.frame), 0);
    } completion:^(BOOL finished) {
        [self.healthyView.bgView removeFromSuperview];
        [self.healthyView.calendarView removeFromSuperview];
        UIScrollView *supRScrollView = (UIScrollView *)self.view.superview;
        supRScrollView.scrollEnabled = YES;
    }];
    
}




#pragma mark - iCarouselDataSource和iCarouselDelegate方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
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
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*SCREEN_SCALE, 40*SCREEN_SCALE)];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*SCREEN_SCALE, 40*SCREEN_SCALE)];
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
    label.text= self.items[(NSUInteger)index];
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
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*SCREEN_SCALE, 40*SCREEN_SCALE)];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*SCREEN_SCALE, 40*SCREEN_SCALE)];
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

    for (int j=1; j<=3; j++) {
        NSString *everyWeekMargin = [self getSingleWeekBeginAndEndWith:(self.totalWeek+3-j)*(-7)];
        [placeholderArr addObject:everyWeekMargin];
    }
    
    for (int i=1; i<=3; i++) {
        NSString *everyWeekMargin = [self getSingleWeekBeginAndEndWith:(-i)*(-7)];
        [placeholderArr addObject:everyWeekMargin];
        
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
            return value * 1.05f;
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
            return 3;
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
        self.ellipseImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.ellipseImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.ellipseImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    self.currentIndex = carousel.currentItemIndex;
    if (self.currentIndex == self.previousIndex) {
        return;
    }
    self.previousIndex = carousel.currentItemIndex;
    NSString *yearAndMonth = self.allWeekIndexArray[carousel.currentItemIndex];
    NSString *yearString = [yearAndMonth substringToIndex:4];
    NSString *monthString = [yearAndMonth substringWithRange:NSMakeRange(5, 2)];
    if ([monthString characterAtIndex:0]=='0') {
        monthString =[monthString substringFromIndex:1];
    }
    self.healthyView.dateLabel.text = [NSString stringWithFormat:@"%@年",yearString];

//    self.queryWeekInfoListService.onlyUserCache=YES;
    self.queryWeekInfoListService.needCache = NO;
    self.queryWeekInfoListService.onlyUserCache = NO;
    [self.queryWeekInfoListService getHealthWeekInfowithBabyID:[self.babyId integerValue] date:self.allWeekIndexArray[carousel.currentItemIndex] type:@"week"];
}
#pragma mark - 懒加载
// NSDateFormatter的创建比较慢，懒加载
- (NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}
- (UIImageView *)ellipseImageView
{
    if (!_ellipseImageView) {
        _ellipseImageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"icon_week_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 20)]];
    }
    return _ellipseImageView;
}
- (EHGetHealthyWeekInfoService *)queryWeekInfoListService
{
    [self showLoadingView];
    if (!_queryWeekInfoListService) {
        _queryWeekInfoListService = [EHGetHealthyWeekInfoService new];
        // service 返回成功 block
        WEAKSELF
        _queryWeekInfoListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            //        [WeAppToast toast:@"服务器访问成功"];
            EHLogInfo(@"服务器访问成功");
            STRONGSELF
            if (service.item) {
                EHGetHealthyWeekInfoRsp *model = (EHGetHealthyWeekInfoRsp*)service.item;
                strongSelf.weekVCmodel=model;
                dispatch_async( dispatch_get_main_queue(), ^{
                    [strongSelf hideErrorView];
                    [strongSelf updateUIAfterService:model withView:strongSelf.healthyView];
                    
                });
            }
            
        };
        // service 缓存返回成功 block
        _queryWeekInfoListService.serviceCacheDidLoadBlock = ^(WeAppBasicService* service,NSArray* componentItems){
            //        [WeAppToast toast:@"数据库缓存访问成功"];
            EHLogInfo(@"数据库缓存访问成功");
            STRONGSELF
            
            if (componentItems) {
                EHGetHealthyWeekInfoRsp *model = (EHGetHealthyWeekInfoRsp*)componentItems[0];
                strongSelf.weekVCmodel=model;
                dispatch_async( dispatch_get_main_queue(), ^{
                    [strongSelf hideErrorView];
                    [strongSelf updateUIAfterService:model withView:strongSelf.healthyView];
                    
                });
                
            }
            
        };
        // service 返回失败 block
        _queryWeekInfoListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [strongSelf showErrorView:error];
            //        [WeAppToast toast:@"获取本周运动信息失败"];
        };

    }
        return _queryWeekInfoListService;
}
@end
