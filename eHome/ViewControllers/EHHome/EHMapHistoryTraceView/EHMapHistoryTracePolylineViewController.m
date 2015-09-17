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

#define mapHistoryTraceHeaderView_width  (85)
#define mapHistoryTraceHeaderView_height (86)
#define mapHistoryTraceHeaderView_right_border   (-12)
#define mapHistoryTraceHeaderView_bottom_border  (-5)

#define mapHistoryTraceBottomView_height (100)

@interface EHMapHistoryTracePolylineViewController()

@property (nonatomic, strong) NSArray                        *positionArray;

@property (nonatomic, strong) NSString                       *timerTitle;

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
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapHistoryTraceBottomView];
    [self.view addSubview:self.mapHistoryTraceHeaderView];
}

-(void)initHistoryMapVCNavBarViews{
    self.navigationItem.title = self.timerTitle;
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

@end
