//
//  HealthMonthViewController.m
//  eHome
//
//  Created by 钱秀娟 on 15/7/21.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyMonthViewController.h"
#import "EHHealthyMonthViewController.h"
#import "EHHealthyMonthView.h"
#import "PNColor.h"
#import "UIMacro.h"
#import "EHGetHealthyMonthInfoService.h"
#import "Masonry.h"
#import "UIBGView.h"
#define _MAXMonth 12//最多显示多少天的运动数据
//和日视图一样的压缩比例
#define HEALTH_HEIGHT (SCREEN_HEIGHT-UI_NAVIGATION_HEIGHT-self.rdv_tabBarController.tabBar.height)
#define HEALTH_BASE_HEIGHT (SCREEN_HEIGHT_BASE-UI_NAVIGATION_HEIGHT-self.rdv_tabBarController.tabBar.height)
#define HEALTH_SCREEN_SCALE (HEALTH_HEIGHT/HEALTH_BASE_HEIGHT)

@interface EHHealthyMonthViewController ()<UIScrollViewDelegate>
@property(strong,nonatomic) UIScrollView *monthScrollView;
@property(strong,nonatomic) UIBGView     *bgView;
@property (assign,nonatomic)NSInteger currentIndex;
@property(strong,nonatomic)NSNumber *currentPage;
@property(strong,nonatomic)NSMutableArray *reusableView;
@property(strong,nonatomic)NSMutableArray *visibleView;
@property(strong,nonatomic)NSNumber* babyId;

@property (strong,nonatomic)EHHealthyMonthView *currentMonthView;


//显示周区间

@end

@implementation EHHealthyMonthViewController
{
    
    EHGetHealthyMonthInfoService* _getMonthInfoList;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHealthyWeek];
    self.view.backgroundColor = EH_bgcor1;
    [self addScrollView];
    [self addLabelsAndImages];

}

-(void)addScrollView{
    //创建滑动视图
    self.bgView = [[UIBGView alloc] initWithFrame:CGRectZero];
    self.monthScrollView=[[UIScrollView alloc]initWithFrame:CGRectZero];
    self.monthScrollView.contentSize=CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds)-50)*_MAXMonth, ((CGRectGetWidth([UIScreen mainScreen].bounds) - 50) *385 / 325));
    self.monthScrollView.showsHorizontalScrollIndicator=NO;
    self.monthScrollView.showsVerticalScrollIndicator=NO;
    self.monthScrollView.pagingEnabled=YES;
    _currentIndex=_MAXMonth-1;
    [self.bgView addSubview:self.monthScrollView];
    self.bgView.weekScrollView = self.monthScrollView;
    [self.view addSubview:self.bgView];
    self.monthScrollView.delegate = self;
    self.monthScrollView.clipsToBounds = NO;

}

-(void)addLabelsAndImages{
    //创建日期标签
    self.monthLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    self.monthLabel.text=@"月";
    self.monthLabel.textAlignment=NSTextAlignmentCenter;
    self.monthLabel.textColor=EH_cor4;
    self.monthLabel.font=[UIFont systemFontOfSize:EH_siz5];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz5]forKey:NSFontAttributeName];
    CGSize sizeForDateLabel=[self.monthLabel.text boundingRectWithSize:CGSizeMake(80, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.monthLabel.size=sizeForDateLabel;
    [self.view addSubview:self.monthLabel];
   

    // 创建头像标签
    EHGetBabyListRsp *babyUserInfo=[[EHBabyListDataCenter sharedCenter]currentBabyUserInfo];
    self.babyHeadImageView = [[UIImageView alloc]init];
    if ([babyUserInfo.babySex integerValue] == 1) {
        [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:babyUserInfo.babyHeadImage] placeholderImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]];
        CALayer *lay = self.babyHeadImageView.layer;//获取ImageView的层
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:20*HEALTH_SCREEN_SCALE];
    }else{
        
        [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:babyUserInfo.babyHeadImage] placeholderImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]];
        CALayer *lay = self.babyHeadImageView.layer;//获取ImageView的层
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:20*HEALTH_SCREEN_SCALE];
    }

    [self.view addSubview:self.babyHeadImageView];
    
    //创建名字标签
    self.babyNameLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    self.babyNameLabel.text=babyUserInfo.babyNickName;
    //    self.babyNameLabel.text = @"";
    
    self.babyNameLabel.textColor=EH_cor3;
    self.babyNameLabel.font=[UIFont systemFontOfSize:EH_siz6];
    
//    NSDictionary *attributes3 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz6]forKey:NSFontAttributeName];
//    CGSize sizeForDateLabel3=[self.babyNameLabel.text boundingRectWithSize:CGSizeMake(80, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;
//    self.babyNameLabel.size=sizeForDateLabel3;
    self.babyNameLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:self.babyNameLabel];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addConstraintsForSubViews];
    EHGetBabyListRsp *babyUserInfo=[[EHBabyListDataCenter sharedCenter]currentBabyUserInfo];
    self.babyId=babyUserInfo.babyId;
    self.babyNameLabel.text = babyUserInfo.babyNickName;
    if ([babyUserInfo.babySex integerValue] == 1) {
        [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:babyUserInfo.babyHeadImage] placeholderImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]];
        CALayer *lay = self.babyHeadImageView.layer;//获取ImageView的层
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:20*HEALTH_SCREEN_SCALE];
    }else{
        
        [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:babyUserInfo.babyHeadImage] placeholderImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]];
        CALayer *lay = self.babyHeadImageView.layer;//获取ImageView的层
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:20*HEALTH_SCREEN_SCALE];
    }
    self.monthScrollView.contentOffset=CGPointMake((CGRectGetWidth([UIScreen mainScreen].bounds)-50)*(_MAXMonth-1),0);
}

-(void)addConstraintsForSubViews{
    UIView *superView=self.view;

    //创建日期标签的约束
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(20*HEALTH_SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
        //make.size.mas_equalTo(CGSizeMake(110*SCREEN_SCALE, 21*SCREEN_SCALE));
    }];
    //创建头像标签的约束
    [self.babyHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(15*HEALTH_SCREEN_SCALE);
        make.left.equalTo(superView.mas_left).with.offset(30*HEALTH_SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(40*SCREEN_SCALE, 40*SCREEN_SCALE));
    }];
    
    //创建名字标签的约束
    [self.babyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.babyHeadImageView.mas_bottom).with.offset(5*HEALTH_SCREEN_SCALE);
        make.left.equalTo(superView.mas_left).with.offset(5*HEALTH_SCREEN_SCALE);
        make.centerX.equalTo(self.babyHeadImageView.mas_centerX);
    }];

    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(75*HEALTH_SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds),(CGRectGetWidth([UIScreen mainScreen].bounds) - 50) *385 / 325));
    }];
    [self.monthScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(75*HEALTH_SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds)-50),(CGRectGetWidth([UIScreen mainScreen].bounds) - 50) *385 / 325));
    }];

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (EHHealthyMonthView *view in self.visibleView) {
        if([view.page integerValue] == [self.currentPage integerValue]){
            self.currentMonthView=view;
            break;
        }
    }
    if (self.currentMonthView) {
        [self addBarChartView];
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [myDateFormatter stringFromDate:[NSDate date]];
        _getMonthInfoList.needCache = NO;
        _getMonthInfoList.onlyUserCache = NO;
        [self showLoadingView];
        [_getMonthInfoList getHealthMonthInfoWithBabyID:[self.babyId integerValue] date:dateString type:@"month"];
        
        [self getMonthInfo:[NSDate date]];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
#pragma mark - UIScrollViewDelegate
//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    NSInteger page = roundf(scrollView.contentOffset.x / (CGRectGetWidth([UIScreen mainScreen].bounds)-50));
    page = MAX(page, 0);
    page = MIN(page, _MAXMonth - 1);
    [self loadPage:page];
}
//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    
    NSLog(@"scrollViewDidEndScrollingAnimation");
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    for (EHHealthyMonthView *view in self.visibleView) {
        if(view.page==self.currentPage){
            self.currentMonthView=view;
            break;
        }
    }
    //替换滑动视图的背景
    for (EHHealthyMonthView *view in self.visibleView) {
        
        if(view.page==self.currentPage){
            self.currentMonthView=view;
            UIImageView* imageViewSame= (UIImageView *)[view viewWithTag:10000];
            imageViewSame.image = [UIImage imageNamed:@"bg_healthhome_weekmonth"];
        }
        if([view.page integerValue]==[self.currentPage integerValue]-1){
            
            //            view.backgroundColor = [UIColor yellowColor];
            UIImageView* imageViewSame= (UIImageView *)[view viewWithTag:10000];
            imageViewSame.image = [UIImage imageNamed:@"bg_healthhome_weekmonth"];
            
        }
        if([view.page integerValue]==[self.currentPage integerValue]+1){
            //            view.backgroundColor = [UIColor yellowColor];
            UIImageView* imageViewSame= (UIImageView *)[view viewWithTag:10000];
            imageViewSame.image = [UIImage imageNamed:@"bg_healthhome_weekmonth"];
        }
    }
    // 重新加载数据
    NSCalendar *cld = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:[self.currentPage integerValue]+1-_MAXMonth];
    [adcomps setDay:0];
    NSDate *newdate = [cld dateByAddingComponents:adcomps toDate:date options:0];
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [myDateFormatter stringFromDate:newdate];
    [self getMonthInfo:newdate];
    [self addBarChartView];
    [self showLoadingView];
    _getMonthInfoList.onlyUserCache = YES;
    
    EHGetBabyListRsp *babyUserInfo=[[EHBabyListDataCenter sharedCenter]currentBabyUserInfo];
    self.babyId=babyUserInfo.babyId;
    [_getMonthInfoList getHealthMonthInfoWithBabyID:[self.babyId integerValue] date: newDateString type:@"month"];
    //    [_getMonthInfoList getHealthMonthInfoWithBabyID:119 date:@"2015-07-12" type:@"month"];
    
    //    self.currentWeekView.totalStepsLabel.text = [NSString stringWithFormat:@"aa%@", self.currentPage];
    
}

-(void)addBarChartView{
    UIColor *labelColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_healthhome_weekmonth_run"]];
    [self.currentMonthView.runBg setBackgroundColor:labelColor];
    self.currentMonthView.barChart.labelMarginTop = 0;
    self.currentMonthView.barChart.backgroundColor = [UIColor clearColor];
    self.currentMonthView.barChart.showChartBorder = NO;
    self.currentMonthView.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    self.currentMonthView.totalStepsLabel.textColor = EH_cor3;
    self.currentMonthView.totalStepsLabel.font = [UIFont systemFontOfSize:EH_siz5];
    self.currentMonthView.everyDaySteps.textColor = EH_cor5;
    self.currentMonthView.everyDaySteps.font = [UIFont systemFontOfSize:EH_siz7];
    self.currentMonthView.everyDaySteps.text = @"每日最多步数12000步";
    
}

- (NSString *)getCurrentShowDate
{
    NSString *date=self.monthLabel.text;
    return date;
}


- (NSMutableArray *)reusableView
{
    if (!_reusableView) {
        _reusableView = [NSMutableArray array];
    }
    return _reusableView;
}

- (NSMutableArray *)visibleView
{
    if (!_visibleView) {
        _visibleView = [NSMutableArray array];
    }
    return _visibleView;
}
- (void)loadPage:(NSInteger)page
{
    if (self.currentPage && page == [self.currentPage integerValue]) {
        return;
    }
    self.currentPage = @(page);
    NSMutableArray *pagesToLoad = [@[@(page), @(page - 1), @(page + 1)] mutableCopy];
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    for (EHHealthyMonthView *view in self.visibleView) {
        if (!view.page || ![pagesToLoad containsObject:view.page]) {
            [vcsToEnqueue addObject:view];
        } else if (view.page) {
            [pagesToLoad removeObject:view.page];
        }
    }
    for (EHHealthyMonthView *view in vcsToEnqueue) {
        [view removeFromSuperview];
        [self.visibleView removeObject:view];
        //        [view setPage:[NSNumber numberWithInt:page]];
        [self enqueueReusableView:view];
    }
    for (NSNumber *page in pagesToLoad) {
        [self addViewForPage:[page integerValue]];
    }
    
}
- (void)enqueueReusableView:(EHHealthyMonthView *)view
{
    [view.barChart setYValues:nil];
    [view.barChart strokeChart];
    view.maxLabel.text = @"";
    
    view.totalStepsLabel.text = @"";
    
    
    [self.reusableView addObject:view];
}

- (EHHealthyMonthView *)dequeueReusableView
{
    static int numberOfInstance = 0;
    EHHealthyMonthView *view = [self.reusableView firstObject];
    if (view) {
        [self.reusableView removeObject:view];
    } else {
        view = [[EHHealthyMonthView alloc]init];
        view.numberOfInstance = numberOfInstance;
        numberOfInstance++;
        [self.view addSubview:view];
    }
    return view;
}

- (void)addViewForPage:(NSInteger)page
{
    if (page < 0 || page >= _MAXMonth) {
        return;
    }
    EHHealthyMonthView *view = [self dequeueReusableView];
    view.page = @(page);
    if (view.page==self.currentPage) {
        if (!self.currentMonthView) {
            self.currentMonthView=[[EHHealthyMonthView alloc]init];
        }
        self.currentMonthView=view;
    }
    view.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)-50) * page, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds)-50, self.monthScrollView.frame.size.height);
    // view.totalStepsLabel.text = [NSString stringWithFormat:@"%@", view.page];
    
    if ([view viewWithTag:10000])
    {
        
    }
    else{
    }
    
    [self.monthScrollView addSubview:view];
    [self.visibleView addObject:view];
}


- (void)loadHealthyWeek{
    _getMonthInfoList = [EHGetHealthyMonthInfoService new];
//    _getMonthInfoList.onlyUserCache = YES;

    // service 返回成功 block
    WEAKSELF
    _getMonthInfoList.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
//        [WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        STRONGSELF
        [strongSelf hideLoadingView];
        if (service.dataList) {
            dispatch_async( dispatch_get_main_queue(), ^{
                NSMutableArray* allWeekSteps = [NSMutableArray arrayWithCapacity:[service.dataList count]];
                NSMutableArray* allWeekMargins = [NSMutableArray arrayWithCapacity:[service.dataList count]];
                
                for (EHGetHealthyMonthInfoRsp *eachWeek in service.dataList ) {
                    NSInteger everyWeekSteps = eachWeek.res
                    everyWeekSteps ;
                    [allWeekSteps addObject:[NSNumber numberWithInteger:everyWeekSteps]];
                    NSString* beginTime = eachWeek.beginTime;
                    NSString* endTime = eachWeek.endTime;
                    
                    NSString *beginString = [beginTime substringFromIndex:8];
                    if (beginString.length == 1) {
                        beginString = [NSString stringWithFormat:@"0%@",beginString];
                    }
                    NSString *endString = [endTime substringFromIndex:8];
                    if (endString.length == 1) {
                        endString = [NSString stringWithFormat:@"0%@",endString];
                    }
                    
                    NSString* weekMargin = [NSString stringWithFormat:@"%@-%@",beginString,endString];
                    [allWeekMargins addObject:weekMargin];
                    
                }
                
                [strongSelf.currentMonthView.barChart setXLabels:allWeekMargins];
                [strongSelf.currentMonthView.barChart setYValues:allWeekSteps];
                
                long totalSteps = 0;
                
                for(NSNumber *num in allWeekSteps)
                {
                    totalSteps = totalSteps +[num intValue];
                    
                    
                }
                //            NSLog(@"totalSteps: %ld",totalSteps);
                NSString *stepsString = [NSString stringWithFormat:@"本月跑步共计%ld步",totalSteps];
                NSNumber* max1=[allWeekSteps valueForKeyPath:@"@max.intValue"];
                int index = 0;
                for (NSNumber *bb in allWeekSteps) {
                    if ([bb intValue] == [max1 intValue]) {
                        break;
                    }
                    else
                        index++;
                }
                
                NSMutableArray *colors = [NSMutableArray new];
                
                
                for (NSNumber *aa in allWeekSteps) {
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
                
                [strongSelf.currentMonthView.barChart setStrokeColors:colors];
                
                strongSelf.currentMonthView.totalStepsLabel.text = stepsString;
                strongSelf.currentMonthView.maxLabel.text = [NSString stringWithFormat:@"%d",[max1 integerValue]];
                
                UILabel *maxLabelW=[[UILabel alloc]initWithFrame:CGRectZero];
                maxLabelW.text= [NSString stringWithFormat:@"%d",[max1 integerValue]];
                maxLabelW.font=[UIFont systemFontOfSize:EH_siz7];
                
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz7]forKey:NSFontAttributeName];
                CGSize sizeForDateLabel2=[maxLabelW.text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                double barWidth = 20*SCREEN_HOR_SCALE;
                
                double barMargin = ((SCREEN_WIDTH-50-75*SCREEN_HOR_SCALE) -15*SCREEN_HOR_SCALE-colors.count*20*SCREEN_HOR_SCALE)/((colors.count-1)*1.0);
                double barXPosition = 7.5*SCREEN_HOR_SCALE+index*(barMargin+barWidth);
                [strongSelf.currentMonthView.maxLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(strongSelf.currentMonthView.mas_left).with.offset(50*SCREEN_HOR_SCALE+barXPosition-0.5*(sizeForDateLabel2.width-barWidth));
                    
                }];
                
                
                [strongSelf.currentMonthView.barChart strokeChartWeek];
            
            });
            
        }
        
    };
    // service 缓存返回成功 block
    _getMonthInfoList.serviceCacheDidLoadBlock = ^(WeAppBasicService* service,NSArray* componentItems){
//        [WeAppToast toast:@"数据库缓存访问成功"];
        EHLogInfo(@"数据库缓存访问成功");
        STRONGSELF
        [strongSelf hideLoadingView];
        if (componentItems) {
//            EHLogInfo(@"\naansarrya %@\n\n\n\n",componentItems);
            NSMutableArray* allWeekSteps = [NSMutableArray arrayWithCapacity:[componentItems count]];
            NSMutableArray* allWeekMargins = [NSMutableArray arrayWithCapacity:[componentItems count]];
            
            for (int i = 0;i < [componentItems count]; i++) {
                
//                EHLogInfo(@"\naansarrya %@\n\n\n\n",componentItems[i]);
                EHGetHealthyMonthInfoRsp *eachWeek = (EHGetHealthyMonthInfoRsp *)componentItems[i];
                NSInteger everyWeekSteps = eachWeek.everyWeekSteps ;
                [allWeekSteps addObject:[NSNumber numberWithInteger:everyWeekSteps]];
                NSString* beginTime = eachWeek.beginTime;
                NSString* endTime = eachWeek.endTime;
                
                NSString *beginString = [beginTime substringFromIndex:8];
                if (beginString.length == 1) {
                    beginString = [NSString stringWithFormat:@"0%@",beginString];
                }
                NSString *endString = [endTime substringFromIndex:8];
                if (endString.length == 1) {
                    endString = [NSString stringWithFormat:@"0%@",endString];
                }
                
                NSString* weekMargin = [NSString stringWithFormat:@"%@-%@",beginString,endString];
                [allWeekMargins addObject:weekMargin];
                
            }
            
            [strongSelf.currentMonthView.barChart setXLabels:allWeekMargins];
            [strongSelf.currentMonthView.barChart setYValues:allWeekSteps];
            
            long totalSteps = 0;
            
            for(NSNumber *num in allWeekSteps)
            {
                totalSteps = totalSteps +[num intValue];
                
                
            }
            NSString *stepsString = [NSString stringWithFormat:@"本周跑步共计%ld步",totalSteps];
            NSNumber* max1=[allWeekSteps valueForKeyPath:@"@max.intValue"];
            int index = 0;
            for (NSNumber *bb in allWeekSteps) {
                if ([bb intValue] == [max1 intValue]) {
                    break;
                }
                else
                    index++;
            }
            
            NSMutableArray *colors = [NSMutableArray new];
            
            
            for (NSNumber *aa in allWeekSteps) {
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
            
            [strongSelf.currentMonthView.barChart setStrokeColors:colors];
            
            strongSelf.currentMonthView.totalStepsLabel.text = stepsString;
            strongSelf.currentMonthView.maxLabel.text = [NSString stringWithFormat:@"%d",[max1 integerValue]];
            
            UILabel *maxLabelW=[[UILabel alloc]initWithFrame:CGRectZero];
            maxLabelW.text= [NSString stringWithFormat:@"%d",[max1 integerValue]];
            //    self.totalStepsLabel.textAlignment=NSTextAlignmentCenter;
            maxLabelW.font=[UIFont systemFontOfSize:EH_siz7];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz7]forKey:NSFontAttributeName];
            CGSize sizeForDateLabel2=[maxLabelW.text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            double barWidth = 20*SCREEN_HOR_SCALE;
            
            double barMargin = ((SCREEN_WIDTH-50-75*SCREEN_HOR_SCALE) -15*SCREEN_HOR_SCALE-colors.count*20*SCREEN_HOR_SCALE)/((colors.count-1)*1.0);
            double barXPosition = 7.5*SCREEN_HOR_SCALE+index*(barMargin+barWidth);
            [strongSelf.currentMonthView.maxLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(strongSelf.currentMonthView.mas_left).with.offset(50*SCREEN_HOR_SCALE+barXPosition-0.5*(sizeForDateLabel2.width-barWidth));
                
            }];
            [strongSelf.currentMonthView.barChart strokeChartWeek];

            
        }
    };
    // service 返回失败 block
    _getMonthInfoList.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"获取本月运动信息失败"];
    };
    
    //    [_getMonthInfoList getHealthMonthInfoWithBabyID:46 date:@"2015-06-17" type:@"month"];
}



//把月份转换成中文
- (void)getMonthInfo:(NSDate *)newDate{
    NSCalendar *cld = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [cld components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:newDate];
    
//    NSInteger year = [cmp year];
    NSInteger month = [cmp month];
//    NSInteger  week = [cmp weekday];
    NSString *monthString = [NSString new];
    switch (month) {
        case 1:
            monthString = @"一月";
            break;
        case 2:
            monthString = @"二月";
            break;
        case 3:
            monthString = @"三月";
            break;
        case 4:
            monthString = @"四月";
            break;
        case 5:
            monthString = @"五月";
            break;
        case 6:
            monthString = @"六月";
            break;
        case 7:
            monthString = @"七月";
            break;
        case 8:
            monthString = @"八月";
            break;
        case 9:
            monthString = @"九月";
            break;
        case 10:
            monthString = @"十月";
            break;
        case 11:
            monthString = @"十一月";
            break;
        case 12:
            monthString = @"十二月";
            break;
        default:
            break;
    }
    self.monthLabel.text = monthString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
