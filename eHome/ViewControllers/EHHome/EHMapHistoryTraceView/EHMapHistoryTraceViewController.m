//
//  EHMapHistoryTraceViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTraceViewController.h"
#import "EHMapHistoryTraceListView.h"
#import "EHDatePickerSelectControl.h"
#import "EHHomeNavBarTItleView.h"

typedef void(^historyTraceListDidSelectedBlock) (NSArray* dataList, NSUInteger index);

@interface EHMapHistoryTraceViewController (){
    NSDateFormatter         *_outputFormatter;
}

/*!
 *  @brief  view层
 */
// 顶部nav bar titleView
//@property (nonatomic, strong) EHHomeNavBarTItleView       *navBarTitleView;
// 消息列表 messageInfoListView
@property (nonatomic, strong) EHMapHistoryTraceListView       *historyTraceInfoListView;

@property (nonatomic, strong) EHDatePickerSelectControl       *datePickerSelectControl;

@property (nonatomic, strong) EHHomeNavBarTItleView           *navBarTitleView;

/*!
 *  @brief  数据层
 */
@property (nonatomic, strong) NSArray*                         positionListArray;

@property (nonatomic, strong) NSString*                        timerTitle;

@property (nonatomic, strong) NSDate*                          selectDate;

@property (nonatomic,copy)    historyTraceListDidSelectedBlock historyTraceListDidSelectedBlock;

@end

@implementation EHMapHistoryTraceViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.positionListArray = [nativeParams objectForKey:@"positionListArray"];
        self.historyTraceListDidSelectedBlock = [nativeParams objectForKey:@"historyTraceListDidSelectedBlock"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapHistoryTraceDate];
    [self initMapHistoryTraceNavBarViews];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.historyTraceInfoListView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initMapHistoryTraceDate{
    self.selectDate = [NSDate date];
}

-(void)initMapHistoryTraceNavBarViews{
    [self refreshNavigationItemTitleWithDate:self.selectDate];
    UIButton* dataSelectTraceBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [dataSelectTraceBarBtn setImage:[UIImage imageNamed:@"public_icon_calendar"] forState:UIControlStateNormal];
    [dataSelectTraceBarBtn setImageEdgeInsets:UIEdgeInsetsMake((dataSelectTraceBarBtn.height - 22)/2, (dataSelectTraceBarBtn.width - 22)/2, (dataSelectTraceBarBtn.height - 22)/2, (dataSelectTraceBarBtn.width - 22)/2)];
    [dataSelectTraceBarBtn addTarget:self action:@selector(dataSelectNarvigationBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* dataSelectTraceBarItem = [[UIBarButtonItem alloc] initWithCustomView:dataSelectTraceBarBtn];
    
    UIButton* mapHistoryTraceBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [mapHistoryTraceBarBtn setImage:[UIImage imageNamed:@"public_icon_map"] forState:UIControlStateNormal];
    [mapHistoryTraceBarBtn setImageEdgeInsets:UIEdgeInsetsMake((mapHistoryTraceBarBtn.height - 22)/2, (mapHistoryTraceBarBtn.width - 22)/2, (mapHistoryTraceBarBtn.height - 22)/2, (mapHistoryTraceBarBtn.width - 22)/2)];
    [mapHistoryTraceBarBtn addTarget:self action:@selector(mapHistoryNarvigationBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* mapHistoryTraceBarItem = [[UIBarButtonItem alloc] initWithCustomView:mapHistoryTraceBarBtn];
    
    self.navigationItem.rightBarButtonItems = @[mapHistoryTraceBarItem, dataSelectTraceBarItem];
}

-(void)refreshNavigationItemTitleWithDate:(NSDate*)date{
    self.timerTitle = [self getTimerTitleWithDate:date]?:@"宝贝轨迹";
    self.title = self.timerTitle;
}

-(NSString*)getTimerTitleWithDate:(NSDate*)date{
    if (_outputFormatter == nil) {
        _outputFormatter = [[NSDateFormatter alloc] init];
        [_outputFormatter setDateFormat:@"yyyy.MM.dd"];
    }
    return [_outputFormatter stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataSelectNarvigationBarItemClicked:(id)sender{
    [self.datePickerSelectControl showDatePickerSelectViewWithDate:self.selectDate];
}

-(void)mapHistoryNarvigationBarItemClicked:(id)sender{
    TBOpenURLFromSourceAndParams(internalURL(@"EHMapHistoryTracePolylineViewController"), self,@{@"timerTitle":self.timerTitle,@"selectDate":self.selectDate,@"positionArray":self.historyTraceInfoListView.positionArray?:@[],@"endMovingPositionIndex":[NSNumber numberWithUnsignedInteger:MAX([self.historyTraceInfoListView.positionArray count] - 1, 0)]});
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  datePickerSelectControl 日期选择 操作
-(EHDatePickerSelectControl *)datePickerSelectControl{
    if (_datePickerSelectControl == nil) {
        _datePickerSelectControl = [EHDatePickerSelectControl new];
        WEAKSELF
        _datePickerSelectControl.datePickerCancelBlock = ^(){
            STRONGSELF
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        
        _datePickerSelectControl.datePickerSelectControlBlock = ^(EHDatePickerSelectControl* datePickerSelectControl, NSDate* date){
            STRONGSELF
            strongSelf.selectDate = date;
            
            [strongSelf refreshNavigationItemTitleWithDate:date];
            [strongSelf.historyTraceInfoListView refreshDataRequestWithData:date];
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        _datePickerSelectControl.popViewController = self.view.viewController;
    }
    return _datePickerSelectControl;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  historyTraceInfoListView
-(EHMapHistoryTraceListView *)historyTraceInfoListView{
    if (_historyTraceInfoListView == nil) {
        _historyTraceInfoListView = [[EHMapHistoryTraceListView alloc] initWithFrame:self.view.bounds];
        [_historyTraceInfoListView setupPositionArray:self.positionListArray];
        WEAKSELF
        _historyTraceInfoListView.historyTraceListDidSelectedBlock = ^(NSArray* dataList, NSUInteger index){
            STRONGSELF
            TBOpenURLFromSourceAndParams(internalURL(@"EHMapHistoryTracePolylineViewController"), strongSelf,@{@"timerTitle":strongSelf.timerTitle,@"positionArray":strongSelf.historyTraceInfoListView.positionArray?:@[],@"endMovingPositionIndex":[NSNumber numberWithUnsignedInteger:index]});

        };
    }
    return _historyTraceInfoListView;
}

@end
