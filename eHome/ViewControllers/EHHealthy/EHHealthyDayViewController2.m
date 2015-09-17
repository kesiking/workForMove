//
//  EHHealthyDayViewController2.m
//  eHome
//
//  Created by jweigang on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyDayViewController2.h"
//#import "EHHealthyDayService.h"
#import "EHDatePickerSelectControl.h"
#import "RMDateSelectionViewController.h"
#import "Masonry.h"

@interface EHHealthyDayViewController2 ()<EHHealthyDelegate>

@property(strong,nonatomic)EHHealthyDayService *queryDataService;
@property(strong,nonatomic)EHDatePickerSelectControl *datePickerSelectControl;
@property(strong,nonatomic)NSDate *selectDate;
@end

@implementation EHHealthyDayViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - EHHealthyDelegate方法
- (void)loadUIWhenAppear:(EHHealthyView *)healthyView
{
    healthyView.barChart.labelMarginTop = 0;
    healthyView.barChart.backgroundColor = [UIColor clearColor];
    healthyView.barChart.showChartBorder = NO;
    healthyView.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    

    [healthyView.dateBtn setTitle:@"今天" forState:UIControlStateNormal];
    self.healthyView.nextBtn.hidden=YES;
    self.queryDataService.needCache=NO;
    self.queryDataService.onlyUserCache=NO;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self getCurrentShowDateString]];
}
- (void)configDateBtnClick:(EHHealthyView *)healthyView
{
    [self.datePickerSelectControl showDatePickerSelectViewWithDate:[self getCurrentShowDate] andTitle:@"去这一天"];
}
- (void)configLastBtnClick:(EHHealthyView *)healthyView
{
    [self changeDisplayDate:healthyView.lastBtn];
    self.queryDataService.onlyUserCache=YES;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self getCurrentShowDateString]];
}
- (void)configNextBtnClick:(EHHealthyView *)healthyView
{
    [self changeDisplayDate:healthyView.nextBtn];
    self.queryDataService.onlyUserCache=YES;
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self getCurrentShowDateString]];
}
- (void)reloadDataWhenHeadBtnClick
{
    [self reloadHealthyDayData];
}
- (void)reloadDataWhenViewScroll
{
    [self reloadHealthyDayData];
}
#pragma mark - queryDataService查询服务器返回数据更新UI操作

-(EHHealthyDayService *)queryDataService{
    if (!_queryDataService) {
        _queryDataService = [EHHealthyDayService new];
        [self showLoadingView];
        // service 返回成功 block
        WEAKSELF
        _queryDataService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            EHLogInfo(@"服务器返回数据成功");
            EHHealthyDayModel *healthyDayModel=(EHHealthyDayModel *)service.item;
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
                dispatch_async( dispatch_get_main_queue(), ^{
                    [strongSelf updateUIAfterService:model withView:strongSelf.healthyView];
                });
            }
            
        };
    }
    return _queryDataService;
}
//showErrorView刷新回调方法
-(void)refreshDataRequest{
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:[self getCurrentShowDateString]];
}

#pragma mark - 实现父类指定方法
- (void)updateUIAfterService:(EHHealthyBasicModel *)model withView:(EHHealthyView *)healthyView
{
    EHHealthyDayModel *dayModel=(EHHealthyDayModel *)model;
    self.dayVCmodel = dayModel;
    if (dayModel.target_steps==0) {
        dispatch_async( dispatch_get_main_queue(), ^{
            [self updateUIWithInit];
        });
        return;
    }
    dispatch_async( dispatch_get_main_queue(), ^{
        healthyView.finishSteps.text=[NSString stringWithFormat:@"%ld",(long)dayModel.steps];
        healthyView.distanceLabel.text=[NSString stringWithFormat:@"%.0f千米",dayModel.mileage];
        healthyView.energyLabel.text=[NSString stringWithFormat:@"%ld卡",dayModel.calorie];
        healthyView.ratioLabel.text=dayModel.percent;
        
        
        
        
        [healthyView.barChart setYValues:dayModel.responseData];
        NSNumber* max1=[dayModel.responseData valueForKeyPath:@"@max.intValue"];
        NSMutableArray *colors = [NSMutableArray new];
        int index = 0;
        for (NSNumber *bb in dayModel.responseData) {
            if ([bb intValue] == [max1 intValue]) {
                break;
            }
            else
                index++;
        }
        for (NSNumber *aa in dayModel.responseData) {
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
        
        healthyView.maxLabel.text = [NSString stringWithFormat:@"%ld",[max1 integerValue]];
        
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz7]forKey:NSFontAttributeName];
        CGSize sizeForDateLabel2=[healthyView.maxLabel.text boundingRectWithSize:CGSizeMake(800, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        
        double barMargin = 17.5*SCREEN_SCALE;
        double barWidth = ((SCREEN_WIDTH-44.5*SCREEN_SCALE) -10*SCREEN_SCALE-(colors.count-1)*barMargin)/(colors.count*1.0);
        
        [healthyView.barChart setDayXLabels:@[@"0-6",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20-24"] andMargin:barMargin andWidth:barWidth];
        
        
        
        double barXPosition = 5*SCREEN_SCALE+index*(barMargin+barWidth);
        
        [healthyView.maxLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(healthyView.mas_left).with.offset(34.5*SCREEN_SCALE+barXPosition-0.5*(sizeForDateLabel2.width-barWidth));
            make.bottom.equalTo(healthyView.bgChartView.mas_top).with.offset(5*SCREEN_SCALE);
            //        make.size.width.mas_equalTo(sizeForDateLabel2.width);
            
        }];
        [healthyView.barChart strokeChartWeekWithMargin:barMargin andWidth:barWidth];

    });
}
#pragma mark - 私有方法
- (void)changeDisplayDate:(id)sender
{
    NSDate *displayDay=[[NSDate alloc]init];
    NSDate *currentDay=[self getCurrentShowDate];
    if (sender==self.healthyView.lastBtn) {
        displayDay=[NSDate dateWithTimeInterval:-24*60*60 sinceDate:currentDay];
    }
    else if(sender==self.healthyView.nextBtn)
    {
        displayDay=[NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDay];
    }
    else if([sender isKindOfClass:[NSDate class]])
    {
        displayDay=sender;
    }
    if (displayDay.daysAgo&&![displayDay isEqualToDate:self.startUserDay]) {
        self.healthyView.lastBtn.hidden=NO;
        self.healthyView.nextBtn.hidden=NO;
    }else if (displayDay.daysAgo&&[displayDay isEqualToDate:self.startUserDay])
    {
        self.healthyView.lastBtn.hidden=YES;
        self.healthyView.nextBtn.hidden=NO;
    }else if (!displayDay.daysAgo&&![displayDay isEqualToDate:self.startUserDay])
    {
        self.healthyView.lastBtn.hidden=NO;
        self.healthyView.nextBtn.hidden=YES;
        [self.healthyView.dateBtn setTitle:@"今天" forState:UIControlStateNormal];
        return;
    }
    else{
        self.healthyView.lastBtn.hidden=YES;
        self.healthyView.nextBtn.hidden=YES;
    }
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.healthyView.dateBtn setTitle:[dateFormatter stringFromDate:displayDay] forState:UIControlStateNormal];
}
- (NSString *)getCurrentShowDateString
{
    NSString *dateString=self.healthyView.dateBtn.titleLabel.text;
    if([dateString isEqualToString:@"今天"])
    {
        NSDate *now=[NSDate date];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateString=[dateFormatter stringFromDate:now];
    }
    return dateString;
}
- (NSDate *)getCurrentShowDate
{
    NSDate *currentDate=[EHUtils convertDateFromString:[self getCurrentShowDateString] withFormat:@"yyyy-MM-dd"];
    return currentDate;
}
- (void)reloadHealthyDayData
{
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [myDateFormatter stringFromDate:[NSDate date]];
    self.queryDataService.needCache=NO;
    self.queryDataService.onlyUserCache=NO;
    [self changeDisplayDate:date];
    [self.queryDataService queryBabyHealthyDataWithBabyId:[self.babyId integerValue] AndDate:date];
}
#pragma mark - 懒加载  datePickerSelectControl 日期选择 操作
-(EHDatePickerSelectControl *)datePickerSelectControl{
    if (_datePickerSelectControl == nil) {
        _datePickerSelectControl = [EHDatePickerSelectControl new];
        WEAKSELF
        _datePickerSelectControl.datePickerSelectControlBlock = ^(EHDatePickerSelectControl* datePickerSelectControl, NSDate* date){
            STRONGSELF
            strongSelf.selectDate = date;
            [strongSelf changeDisplayDate:date];
            [strongSelf.queryDataService queryBabyHealthyDataWithBabyId:[strongSelf.babyId integerValue] AndDate:[EHUtils stringFromDate:date withFormat:@"yyyy-MM-dd"]];
        };
        //        _datePickerSelectControl.datePickerCancelBlock = ^(){
        //            STRONGSELF
        //        };
        _datePickerSelectControl.popViewController = self.view.viewController;
    }
    return _datePickerSelectControl;
}
@end
