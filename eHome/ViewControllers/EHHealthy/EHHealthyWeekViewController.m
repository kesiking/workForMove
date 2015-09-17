//
//  EHHealthyWeekViewController2.m
//  eHome
//
//  Created by 钱秀娟 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyWeekViewController.h"
#import "EHGetHealthyWeekInfoService.h"
#import "Masonry.h"
#import "EHHealthWeekInfoModel.h"
#import "CalendarViewController.h"


@interface EHHealthyWeekViewController ()<EHHealthyDelegate,iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong)UIPickerView* weekPicker;
//@property(strong,nonatomic)NSMutableArray* allWeekMargins;
//@property(strong,nonatomic)NSMutableArray* moreWeekMargins;
@property(assign,nonatomic)BOOL stop;
@property(assign,nonatomic)BOOL reachStop;
@property(assign,nonatomic)NSInteger totalWeek;

@property(strong,nonatomic)NSMutableArray* allWeekIndexArray;


@property(strong,nonatomic)UIView* calendarView;
@property(strong,nonatomic)UIView* bgView;
@property(strong,nonatomic)CalendarViewController *calendarVC;

@property(strong,nonatomic)NSDateFormatter *dateFormatter;



@end

@implementation EHHealthyWeekViewController
//{
//
//    EHGetHealthyWeekInfoService* _getWeekInfoList;
//
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentWeek = 0;
    
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
    
//    [self.allWeekMargins removeAllObjects];
//    [self.moreWeekMargins removeAllObjects];
    
    while (!self.stop) {
        [self getWeekBeginAndEndWith:count*(-7)];
        
        count++;
    }
    self.totalWeek = count;
    
    
//    self.allWeekMargins = (NSMutableArray *)[[self.allWeekMargins reverseObjectEnumerator] allObjects];
//    self.moreWeekMargins = (NSMutableArray *)[[self.moreWeekMargins reverseObjectEnumerator] allObjects];
    self.items = (NSMutableArray *)[[self.items reverseObjectEnumerator] allObjects];

    self.allWeekIndexArray = (NSMutableArray *)[[self.allWeekIndexArray reverseObjectEnumerator] allObjects];
    

    [self.healthyView.carousel reloadData];
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    self.healthyView.carousel.dataSource = self;
    self.healthyView.carousel.delegate = self;
    [self loadHealthyWeek];
//    self.allWeekMargins = [[NSMutableArray alloc]init];
//    self.moreWeekMargins = [[NSMutableArray alloc]init];
    self.stop = NO;
    self.totalWeek = 0;
}





-(void)loadHealthyWeek{
    
    _getWeekInfoList = [EHGetHealthyWeekInfoService new];
    //    _getWeekInfoList.onlyUserCache = YES;
    // service 返回成功 block
    WEAKSELF
    _getWeekInfoList.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        //        [WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        STRONGSELF
        
        [strongSelf hideLoadingView];
        if (service.item) {
            
            EHGetHealthyWeekInfoRsp *model = (EHGetHealthyWeekInfoRsp*)service.item;
            strongSelf.weekVCmodel=model;
            dispatch_async( dispatch_get_main_queue(), ^{
                [strongSelf hideErrorView];
                [strongSelf updateUIAfterService:model withView:strongSelf.healthyView];
                //                NSLog(@"\nmodel.steps\n\n%@",model);
                
            });
        }
        
    };
    // service 缓存返回成功 block
    _getWeekInfoList.serviceCacheDidLoadBlock = ^(WeAppBasicService* service,NSArray* componentItems){
        //        [WeAppToast toast:@"数据库缓存访问成功"];
        EHLogInfo(@"数据库缓存访问成功");
        STRONGSELF
        
        [strongSelf hideLoadingView];
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
    _getWeekInfoList.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [strongSelf showErrorView:error];
        //        [WeAppToast toast:@"获取本周运动信息失败"];
    };
    
}

//showErrorView刷新回调方法




//showErrorView刷新回调方法
-(void)refreshDataRequest{
    NSDate *oldDate = [NSDate date];
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*self.currentWeek*7 sinceDate:oldDate];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [myDateFormatter stringFromDate:newDate];
    [self showLoadingView];
    if (self.currentWeek == 0) {
        _getWeekInfoList.needCache = NO;
        _getWeekInfoList.onlyUserCache = NO;
    }else{
        _getWeekInfoList.onlyUserCache = YES;
    }
    
    [_getWeekInfoList getHealthWeekInfowithBabyID:[self.babyId integerValue] date:newDateString type:@"week"];
    
}

#pragma mark - 实现父类指定方法
- (void)updateUIAfterService:(EHGetHealthyWeekInfoRsp *)model withView:(EHHealthyBasicView *)healthyView
{
    EHHealthWeekInfoModel* weekmodel = [[EHHealthWeekInfoModel alloc]init];
    weekmodel = model.responseData;
    
    NSString *beginDate = weekmodel.monday;
    NSString *endDate = weekmodel.sunday;
    NSString *beginString = [beginDate substringFromIndex:5];
    NSString *begina = [beginString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endString = [endDate substringFromIndex:5];
    NSString *enda = [endString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    [healthyView.dateBtn setTitle:[NSString stringWithFormat:@"%@-%@",begina,enda] forState:UIControlStateNormal];
//    healthyView.dateLabel.text = [NSString stringWithFormat:@"%@-%@",begina,enda];
    self.selectedWeek = [NSString stringWithFormat:@"%@-%@",begina,enda];
    
    
    NSMutableArray* stepsdata = [NSMutableArray arrayWithCapacity:[weekmodel.data count]];
    for (int i =1; i<[weekmodel.data count];i++) {
        [stepsdata addObject:weekmodel.data[i]];
    }
    [stepsdata addObject:weekmodel.data[0]];
    //            NSLog(@"stepsData---------%@\n",stepsdata);
    
    //    NSArray * stepsdata= @[@10,@20,@21,@30,@0,@9,@19];
    
    //            [strongSelf.currentWeekView.barChart setYValues:stepsdata];
    [healthyView.barChart setYValues:stepsdata];
    
    healthyView.sTargetStepsLabel.text = [NSString stringWithFormat:@"目标：%ld步",model.targetSteps];
    healthyView.finishSteps.text=[NSString stringWithFormat:@"%ld",(long)model.steps];
    //    NSLog(@"\nmodel.steps\n\n%ld",model.steps);
    healthyView.distanceLabel.text=[NSString stringWithFormat:@"%.0f公里",model.mileage];
    healthyView.energyLabel.text=[NSString stringWithFormat:@"%.0f千卡",model.calorie];
    healthyView.ratioLabel.text=[NSString stringWithFormat:@"%@%%",model.percent];
    [healthyView.distanceChart updateChartByCurrent:[NSNumber numberWithInteger:[model.percent integerValue]]];
    [healthyView.energyChart updateChartByCurrent:[NSNumber numberWithInteger:[model.percent integerValue]]];
    [healthyView.ratioChart updateChartByCurrent:[NSNumber numberWithInteger:[model.percent integerValue]]];
    
    
    NSNumber* max1=[stepsdata valueForKeyPath:@"@max.intValue"];
    NSMutableArray *colors = [NSMutableArray new];
    int index = 0;
    for (NSNumber *bb in stepsdata) {
        if ([bb intValue] == [max1 intValue]) {
            break;
        }
        else
            index++;
    }
    for (NSNumber *aa in stepsdata) {
        int max = [max1 intValue];
        int aaa = [aa intValue];
        if(aaa <= max/3.0) {
            UIColor *color = EH_barcor2;
            [colors addObject:color];
        }
        
        else{
            if (aaa<=(max/3)*2) {
                UIColor *color = EH_barcor3;
                [colors addObject:color];
            }
            else{
                UIColor *color = EH_barcor1;
                [colors addObject:color];
                
            }
        }
        
    }
    //设置不同的颜色
    
    [healthyView.barChart setStrokeColors:colors];
//    if ([max1 integerValue]==0) {
//        healthyView.maxLabel.hidden=YES;
//    }else
//    {
//        healthyView.maxLabel.hidden=NO;
//        healthyView.maxLabel.text = [NSString stringWithFormat:@"%ld",[max1 integerValue]];
//    }
//    
    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz7]forKey:NSFontAttributeName];
//    CGSize sizeForDateLabel2=[healthyView.maxLabel.text boundingRectWithSize:CGSizeMake(800, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    
    
    double barMargin = 30*SCREEN_SCALE;
    double barWidth = ((SCREEN_WIDTH-44.5*SCREEN_SCALE) -10*SCREEN_SCALE-(colors.count-1)*barMargin)/(colors.count*1.0);
    
    [healthyView.barChart setXLabels:@[@"一",@"二",@"三",@"四",@"五",@"六",@"日"] andMargin:barMargin andWidth:barWidth];
    
    
    
    double barXPosition = 5*SCREEN_SCALE+index*(barMargin+barWidth);
    
//    [healthyView.maxLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(healthyView.thirdView.mas_left).with.offset(34.5*SCREEN_SCALE+barXPosition-0.5*(sizeForDateLabel2.width-barWidth));
//    }];
//    
    [healthyView.barChart strokeChartWeekWithMargin:barMargin andWidth:barWidth];
}

#pragma mark - EHHealthyDelegate方法

//做一些初始化工作
- (void)loadUIWhenAppear:(EHHealthyBasicView *)healthyView
{
    healthyView.barChart.labelMarginTop = 0;
    healthyView.barChart.backgroundColor = [UIColor clearColor];
    healthyView.barChart.showChartBorder = NO;
    healthyView.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    
 
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [myDateFormatter stringFromDate:[NSDate date]];
    _getWeekInfoList.needCache = NO;
    _getWeekInfoList.onlyUserCache = NO;
    
    // 页面出现时按钮的隐藏处理
    [self showLoadingView];
    [_getWeekInfoList getHealthWeekInfowithBabyID:[self.babyId integerValue] date:date type:@"week"];
    
    //
    
    
    
}



- (void)reloadDataWhenHeadBtnClick{
    //需要修改
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [myDateFormatter stringFromDate:[NSDate date]];
    _getWeekInfoList.needCache = NO;
    _getWeekInfoList.onlyUserCache = NO;
    [_getWeekInfoList getHealthWeekInfowithBabyID:[self.babyId integerValue] date:date type:@"week"];
    
    
    //重新更新页面的日历数据
    NSInteger count = 0;
    self.stop = NO;
    [self.items removeAllObjects];
    [self.allWeekIndexArray removeAllObjects];
    
    
//    [self.allWeekMargins removeAllObjects];
//    [self.moreWeekMargins removeAllObjects];
    
    while (!self.stop) {
        [self getWeekBeginAndEndWith:count*(-7)];
        
        count++;
    }
    self.totalWeek = count;
    
    
//    self.allWeekMargins = (NSMutableArray *)[[self.allWeekMargins reverseObjectEnumerator] allObjects];
//    self.moreWeekMargins = (NSMutableArray *)[[self.moreWeekMargins reverseObjectEnumerator] allObjects];
    self.items = (NSMutableArray *)[[self.items reverseObjectEnumerator] allObjects];
    
    self.allWeekIndexArray = (NSMutableArray *)[[self.allWeekIndexArray reverseObjectEnumerator] allObjects];
    
    [self.healthyView.carousel reloadData];
    [self.healthyView.carousel scrollToItemAtIndex:[self.items count]-1 animated:NO];
    
    
}
- (void)reloadDataWhenViewScroll
{
    //页面滑动重新更新数据
    
//    self.currentWeek = 0;
//    self.stop = NO;
//    self.totalWeek = 0;
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [myDateFormatter stringFromDate:[NSDate date]];
    _getWeekInfoList.needCache = NO;
    _getWeekInfoList.onlyUserCache = NO;
    //    self.healthyView.nextBtn.hidden = YES;
    //    self.healthyView.lastBtn.hidden = NO;
    
//    [self getTotalWeek];

    [self showLoadingView];
    
    [_getWeekInfoList getHealthWeekInfowithBabyID:[self.babyId integerValue] date:date type:@"week"];
    
    
}

-(void)getTotalWeek{
    NSInteger count = 0;
    self.stop = NO;
//    self.allWeekMargins = [[NSMutableArray alloc]init];
    //    NSLog(@"\nself.startUserDay%@\n\n\n\n",self.startUserDay);
    while (!self.stop) {
        [self getWeekBeginAndEndWith:count*(-7)];
        
        count++;
    }
    self.totalWeek = count;
}

- (void)configDateBtnClick:(EHHealthyBasicView *)healthyView
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    if (!_calendarVC) {
        _calendarVC = [CalendarViewController new];
    }
    _calendarVC.babyStartDate = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    
    WEAKSELF
    [_calendarVC returnDateText:^(NSString *showSelectedDate){
        STRONGSELF
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *sdate=[format dateFromString:showSelectedDate];
        NSString *selectedDateString = [format stringFromDate:sdate];
        strongSelf.healthyView.dateLabel.text = selectedDateString;
        //点击完日历的操作
        NSInteger acount = 0;
        self.reachStop = NO;
        
        while (!self.reachStop) {
            [self getTotalWeeksFromSelectedDate:acount*(-7) andStartDate:sdate];

            acount++;
        }
       
        NSInteger index = [self.items count] - acount;

        [self.healthyView.carousel scrollToItemAtIndex:index animated:YES];
        [_bgView removeFromSuperview];
        [_calendarView removeFromSuperview];
//
//        [self.healthyView.carousel scrollToItemAtIndex:([self.items count]- count) animated:YES];
//
//     
        
        
        
        
    }];
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, window.bounds.size.width, window.bounds.size.height-60)];
        
    }
    _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
    if (!_calendarView) {
        _calendarView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, 374.5*SCREEN_SCALE+16.5*SCREEN_SCALE)];
    }
    
    _calendarView.backgroundColor = [UIColor whiteColor];
    
    UIView *canldara = _calendarVC.view;
    
    [_calendarVC.view setFrame:CGRectMake(0, 0, self.view.width, 374.5*SCREEN_SCALE)];
    //    _calendarVC.view.clipsToBounds = YES;
    //    self.calendarView.clipsToBounds = YES;
    [self.calendarView addSubview:canldara];
    
    
    _calendarView.alpha = 0;
    [self.view addSubview:_bgView];
    [self.view addSubview:_calendarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(atap)];
    [_bgView addGestureRecognizer:tap];
    
    CGRect rect = self.calendarView.frame;
    //日历控件往下偏移60px
    rect.origin.y = 60;
    //    [self.view bringSubviewToFront:self.babyListView];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [self.calendarView setFrame:rect];
        self.calendarView.alpha = (NSUInteger)(1);
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        
    } completion:nil];
    
    
    
}

- (void)getWeekBeginAndEndWith:(NSInteger)count{
    NSDate *oldDate = [NSDate date];
    //    NSLog(@"%@",oldDate);
    
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*count sinceDate:oldDate];
    //    NSLog(@"%@",newDate);
    
    
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
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *beginDateString=[dateFormatter stringFromDate:beginDate];
    self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    if (!self.startUserDay) {
        self.startUserDay=[NSDate dateWithTimeIntervalSinceReferenceDate:0];
    }
    NSString *startDateString=[dateFormatter stringFromDate:self.startUserDay];
    if ([beginDate daysEarlierThan:self.startUserDay]||[beginDateString isEqualToString:startDateString]) {
        self.stop = YES;
        self.reachStop = YES;
        
    }
    
    NSString *weekMargin = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    
    [self.items addObject:weekMargin];
    
    [self.allWeekIndexArray addObject:beginDateString];
//    [self.allWeekMargins addObject:weekMargin];
//    [self.moreWeekMargins addObject:weekMargin];

}


- (void)getTotalWeeksFromSelectedDate:(NSInteger)count andStartDate:(NSDate *)startDate{
    NSDate *oldDate = [NSDate date];
    //    NSLog(@"%@",oldDate);
    
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*count sinceDate:oldDate];
    //    NSLog(@"%@",newDate);
    
    
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
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM.dd"];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginDateString=[dateFormatter stringFromDate:beginDate];
   
    NSString *startDateString=[dateFormatter stringFromDate:startDate];
    if ([beginDate daysEarlierThan:startDate]||[beginDateString isEqualToString:startDateString]) {
        self.reachStop = YES;
        
    }
    
    
    
}




- (NSString *)agetWeekBeginAndEndWith:(NSInteger)count{
    NSDate *oldDate = [NSDate date];
    //    NSLog(@"%@",oldDate);
    
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24 *60 * 60*count sinceDate:oldDate];
    //    NSLog(@"%@",newDate);
    
    
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
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    
    NSString *weekMargin = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    
//    [self.moreWeekMargins addObject:weekMargin];
    
    return weekMargin;
    
}


- (void)atap{
    [self ahide];
}

- (void)ahide{
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        _calendarView.layer.transform = CATransform3DMakeTranslation(0, -CGRectGetHeight(_calendarView.frame), 0);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_calendarView removeFromSuperview];
        //        _bgView = nil;
        //        _calendarView = nil;
    }];
  
}



- (void)updateWeekLabel:(NSString*)weekMargin
{
    //    NSLog(@"\n\nbabyHeight%@\n\n",babyHeight);
//    [self.healthyView.dateBtn setTitle:[NSString stringWithFormat:@"%@",babyHeight] forState:UIControlStateNormal];
    
    
    
    
}

#pragma mark - iCarouselDataSource和iCarouselDelegate方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    if (!self.startUserDay) {
        return 1;
    }else{
        return [self.items count];
        //        NSInteger num = [self calculateAgeFromDate:self.startUserDay toDate:[NSDate date]];
        //        return  num;
    }
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    UILabel *label = nil;
    if (view == nil) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        //        view.backgroundColor=[UIColor blackColor];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        label.textColor = [UIColor whiteColor];
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
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        //        view.backgroundColor=[UIColor blackColor];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        label.textColor = [UIColor greenColor];
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
//        NSDate *nextDate = [NSDate dateWithTimeInterval:j*24*60*60 sinceDate:[NSDate date]];
//        NSInteger nextPlaceholder = nextDate.day;
//        [placeholderArr addObject:@(nextPlaceholder)];
        
        NSString *everyWeekMargin = [self agetWeekBeginAndEndWith:(self.totalWeek+3-j)*(-7)];
        [placeholderArr addObject:everyWeekMargin];
    }
    
    for (int i=1; i<=3; i++) {
        //        NSDate *preDate = [NSDate dateWithTimeInterval:-i*24*60*60 sinceDate:self.startUserDay];
        //        NSInteger prePlaceholder = preDate.day;
        //        [placeholderArr addObject:@(prePlaceholder)];
        
        
        
        NSString *everyWeekMargin = [self agetWeekBeginAndEndWith:(-i)*(-7)];
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

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    self.currentIndex = carousel.currentItemIndex;
    if (self.currentIndex == self.previousIndex) {
        return;
    }
    //    NSLog(@"Index: %@", @(carousel.currentItemIndex));
    //    NSLog(@"carouselDidEndScrollingAnimation was called");
    self.previousIndex = carousel.currentItemIndex;
    NSDate *selectedDate = [NSDate dateWithTimeInterval:carousel.currentItemIndex*24*60*60 sinceDate:self.startUserDay];
    NSString *dateString = [self.dateFormatter stringFromDate:selectedDate];
    NSString *todayString = [self.dateFormatter stringFromDate:[NSDate date]];
    self.healthyView.dateLabel.text = self.items[carousel.currentItemIndex];
    if ([dateString isEqual:todayString]) {
        _getWeekInfoList.needCache = NO;
        _getWeekInfoList.onlyUserCache = NO;
        self.healthyView.dateLabel.text = @"今天";
    }else{
         _getWeekInfoList.onlyUserCache=YES;
    }
    [_getWeekInfoList getHealthWeekInfowithBabyID:[self.babyId integerValue] date:self.allWeekIndexArray[carousel.currentItemIndex] type:@"week"];
}



@end