//
//  EHMapHistoryTracePolylineViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTracePolylineViewController.h"
#import "EHMapViewShareInstence.h"
#import "EHMapHistoryTraceHeaderView.h"
#import "EHMapHistoryTraceBottomView.h"
#import "EHDatePickerSelectControl.h"
#import "EHHomeNavBarTItleView.h"

#define mapHistoryTraceHeaderView_width  (85)
#define mapHistoryTraceHeaderView_height (86)
#define mapHistoryTraceHeaderView_right_border   (-12)
#define mapHistoryTraceHeaderView_bottom_border  (-5)

#define mapHistoryTraceBottomView_height (100)

@interface EHMapHistoryTracePolylineViewController(){
    NSDateFormatter         *_outputFormatter;
}

@property (nonatomic, strong) NSArray                        *positionArray;

@property (nonatomic, strong) NSString                       *timerTitle;

@property (nonatomic, strong) EHDatePickerSelectControl       *datePickerSelectControl;

@property (nonatomic, strong) EHHomeNavBarTItleView           *navBarTitleView;

@property (nonatomic, strong) NSDate*                          selectDate;

@property (nonatomic, strong) EHLocationService *            listService;

// 地图展示层
@property (nonatomic, strong) EHMapMovingAnnotationPolylineContainer  *mapView;

@property (nonatomic, strong) EHMapHistoryTraceHeaderView    *mapHistoryTraceHeaderView;

@property (nonatomic, strong) EHMapHistoryTraceBottomView    *mapHistoryTraceBottomView;

/*!
 *  @brief  position数据
 *
 *  @since 1.0
 */
// 当前位置position数据index
@property (nonatomic, assign) NSUInteger                     endMovingPositionIndex;
@property (nonatomic, strong) EHUserDevicePosition          *position;

@end

@implementation EHMapHistoryTracePolylineViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.endMovingPositionIndex = [[nativeParams objectForKey:@"endMovingPositionIndex"] unsignedIntegerValue];
        self.positionArray = [nativeParams objectForKey:@"positionArray"];
        self.timerTitle = [nativeParams objectForKey:@"timerTitle"];
        self.selectDate = [nativeParams objectForKey:@"selectDate"];
        if (self.positionArray && [self.positionArray count] > self.endMovingPositionIndex) {
            id positionObj = [self.positionArray objectAtIndex:self.endMovingPositionIndex];
            if ([positionObj isKindOfClass:[EHUserDevicePosition class]]) {
                self.position = positionObj;
            }
        }
    }
    return self;
}

-(void)dealloc{
    [self.mapView removeFromSuperview];
    [self.mapView resetMap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initHistoryMapVCNavBarViews];
    [self initMapHistoryTraceDate];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapHistoryTraceBottomView];
    [self.view addSubview:self.mapHistoryTraceHeaderView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    EHGetBabyListRsp* currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    [self.mapView setBabyUserInfo:currentBabyUserInfo];
    [self.mapView setEndMovingPositionIndex:self.endMovingPositionIndex];
    if (self.positionArray == nil) {
        [self.mapView loadBabyMapListWithBabyUserInfo:currentBabyUserInfo];
    }else{
        [self.mapView setPositionArray:self.positionArray];
        [self.mapView reloadData];
    }
}

-(void)initMapHistoryTraceDate{

}


-(void)initHistoryMapVCNavBarViews{
    self.navigationItem.title = self.timerTitle;
    UIButton* dataSelectTraceBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [dataSelectTraceBarBtn setImage:[UIImage imageNamed:@"public_icon_calendar"] forState:UIControlStateNormal];
    [dataSelectTraceBarBtn setImageEdgeInsets:UIEdgeInsetsMake((dataSelectTraceBarBtn.height - 22)/2, (dataSelectTraceBarBtn.width - 22)/2, (dataSelectTraceBarBtn.height - 22)/2, (dataSelectTraceBarBtn.width - 22)/2)];
    [dataSelectTraceBarBtn addTarget:self action:@selector(dataSelectNarvigationBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* dataSelectTraceBarItem = [[UIBarButtonItem alloc] initWithCustomView:dataSelectTraceBarBtn];
    self.navigationItem.rightBarButtonItem = dataSelectTraceBarItem;
}

-(void)dataSelectNarvigationBarItemClicked:(id)sender{
    [self.datePickerSelectControl showDatePickerSelectViewWithDate:self.selectDate];
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
            //日历选完后刷新页面
            [strongSelf refreshDataRequest];
            
//            [strongSelf.historyTraceInfoListView refreshDataRequestWithData:date];
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        _datePickerSelectControl.popViewController = self;
    }
    return _datePickerSelectControl;
}


-(void)refreshDataRequest{
    [self refreshDataRequestWithData:self.selectDate];
}

-(void)refreshDataRequestWithData:(NSDate*)date{
    [self refreshDataRequestWithBabyId:[[EHBabyListDataCenter sharedCenter] currentBabyId] withData:date];
}

-(void)refreshDataRequestWithBabyId:(NSString*)babyId withData:(NSDate*)date{
    if (date == nil) {
        self.selectDate = [NSDate date];
    }else if (self.selectDate != date){
        self.selectDate = date;
    }
    /*
     NSInteger daysAgo = self.selectDate.daysAgo;
     // 同一天或是更晚
     if (daysAgo == 0) {
     self.tableViewShouldClicked = YES;
     }else{
     self.tableViewShouldClicked = NO;
     }
     */
    [self.listService loadLocationTraceHistoryWithBabyId:babyId withData:date];

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



-(EHMapMovingAnnotationPolylineContainer *)mapView{
    if (_mapView == nil) {
        _mapView = [[EHMapViewShareInstence sharedCenter] getMapViewWithFrame:self.view.bounds];
        WEAKSELF
        _mapView.doMovingAnnotationViewDidStart = ^(EHMapMovingAnnotationPolylineContainer* mapContainer){
            STRONGSELF
            [strongSelf setMapHistoryTraceHeaderViewViewShow:NO];
        };
        _mapView.doMovingAnnotationViewDidStop = ^(EHMapMovingAnnotationPolylineContainer* mapContainer){
            STRONGSELF
            [strongSelf setMapHistoryTraceHeaderViewViewShow:YES];
        };
    }
    return _mapView;
}

-(void)setMapHistoryTraceHeaderViewViewShow:(BOOL)show{
    CGRect rect = self.mapHistoryTraceBottomView.frame;
    if (show) {
        rect.origin.y = self.view.height - rect.size.height;
    }else{
        rect.origin.y = self.view.height;
    }
    [self.view bringSubviewToFront:self.mapHistoryTraceBottomView];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [self.mapHistoryTraceBottomView setFrame:rect];
        self.mapHistoryTraceBottomView.alpha = (NSUInteger)(show?1:0);
    } completion:nil];
}

-(EHMapHistoryTraceHeaderView *)mapHistoryTraceHeaderView{
    if (_mapHistoryTraceHeaderView == nil) {
        _mapHistoryTraceHeaderView = [[EHMapHistoryTraceHeaderView alloc] initWithFrame:CGRectMake(self.view.width - mapHistoryTraceHeaderView_width - mapHistoryTraceHeaderView_right_border, self.view.height - mapHistoryTraceHeaderView_height - mapHistoryTraceHeaderView_bottom_border - mapHistoryTraceBottomView_height, mapHistoryTraceHeaderView_width, mapHistoryTraceHeaderView_height)];
        WEAKSELF
        _mapHistoryTraceHeaderView.historyTraceHeaderBtnClickedBlock = ^(EHMapHistoryTraceHeaderView* headerView){
            STRONGSELF
            if ([strongSelf.mapView respondsToSelector:@selector(startMoving)]) {
                if (strongSelf.mapView.isMovingFinished) {
                    [strongSelf.mapView startMoving];
                }
            }
        };
    }
    return _mapHistoryTraceHeaderView;
}

-(EHMapHistoryTraceBottomView *)mapHistoryTraceBottomView{
    if (_mapHistoryTraceBottomView == nil) {
        _mapHistoryTraceBottomView = [[EHMapHistoryTraceBottomView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, mapHistoryTraceBottomView_height)];
        [_mapHistoryTraceBottomView setPosition:self.position];
        _mapHistoryTraceBottomView.alpha = 0;
    }
    return _mapHistoryTraceBottomView;
}

-(EHLocationService *)listService{
    if (_listService == nil) {
        _listService = [EHLocationService new];
        WEAKSELF
        _listService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _listService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            strongSelf.positionArray = service.dataList;
            [strongSelf.mapView resetMap];
            strongSelf.mapView = nil;
            [strongSelf.mapView setPositionArray:strongSelf.positionArray];
            [strongSelf.mapView reloadData];
            if (!strongSelf.positionArray) {
                [strongSelf setMapHistoryTraceHeaderViewViewShow:NO];
            }
            [strongSelf.mapHistoryTraceBottomView setPosition:[strongSelf.positionArray lastObject]];
        };
        _listService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
     
        };
    }
    return _listService;
}


@end
