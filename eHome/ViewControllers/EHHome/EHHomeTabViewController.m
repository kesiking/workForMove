//
//  EHHomeTabbarViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHomeTabViewController.h"
#import "EHMapOverLayWithOutLineServiceContainer.h"
#import "EHHomeOperationLayerView.h"
#import "EHRefreshLocationLayerView.h"
#import "EHAleatView.h"
#import "EHDeviceStatusCenter.h"
#import "EHMessageHeader.h"

//#define DEBUG_SEND_MESSAGE

#ifdef DEBUG_SEND_MESSAGE
#import "EHMessageInfoListService.h"
#endif

#define rightOperationLayerView_Number          (4)

#define rightOperationLayerView_width           (35.0)
#define rightOperationLayerView_height          (rightOperationLayerView_width * rightOperationLayerView_Number + 20 * (rightOperationLayerView_Number - 1))
#define rightOperationLayerView_rightBorder     (20.0)
#define rightOperationLayerView_bottomBorder    (rightOperationLayerView_rightBorder)

#define leftRefreshLocationLayerView_width          (50.0)
#define leftRefreshLocationLayerView_height         (leftRefreshLocationLayerView_width)
#define leftRefreshLocationLayerView_leftBorder     (15.0)
#define leftRefreshLocationLayerView_bottomBorder   (leftRefreshLocationLayerView_leftBorder)

@interface EHHomeTabViewController(){
    BOOL                _needRefreshBabyList;
    BOOL                _needRefreshGeofengList;
}

/*!
 *  @brief  view层
 */
// 地图展示层
@property (nonatomic, strong) EHMapOverLayWithOutLineServiceContainer *mapView;
// 右下角操作图层
@property (nonatomic, strong) EHHomeOperationLayerView     *rightOperationLayerView;
// 左下角刷新图层
@property (nonatomic, strong) EHRefreshLocationLayerView   *leftRefreshLocationLayerView;

/*!
 *  @brief  数据层
 */
// 当前选中的宝贝
@property (nonatomic, strong) EHGetBabyListRsp             *currentBabyUserInfo;

@property (nonatomic, assign) BOOL                          didSendDeviceBindingMessage;

// sos消息中宝贝收到的地理位置
@property (nonatomic, strong) NSString*                     babySOSMessagTimer;

@end

@implementation EHHomeTabViewController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerKSNavigator protocol method
- (void)setupNavigatorURL:(NSURL*)URL query:(NSDictionary*)query nativeParams:(NSDictionary *)nativeParams{
    [super setupNavigatorURL:URL query:query nativeParams:nativeParams];
    if ([self needSwitchToBabyWithNativeParams:nativeParams]) {
        [self switchToBabyWithNativeParams:nativeParams];
    }else if ([self needLoginWithNativeParams:nativeParams]){
        [self loginWithNativeParams:nativeParams];
    }
}

-(BOOL)needSwitchToBabyWithNativeParams:(NSDictionary *)nativeParams{
    BOOL needSwitchToBaby = [[nativeParams objectForKey:kEHOMETabHomeSwitchToBaby] boolValue];
    NSNumber* babyId = [nativeParams objectForKey:kEHOMETabHomeGetBabyId];
    if (needSwitchToBaby && babyId) {
        return YES;
    }
    return NO;
}

-(BOOL)needLoginWithNativeParams:(NSDictionary *)nativeParams{
    return [[nativeParams objectForKey:kEHOMETabHomeNeedLogin] boolValue];
}

-(void)switchToBabyWithNativeParams:(NSDictionary *)nativeParams{
    NSNumber* babyId = [nativeParams objectForKey:kEHOMETabHomeGetBabyId];
    self.babySOSMessagTimer = [nativeParams objectForKey:kEHOMETabHomeGetBabyTimer];
    [self switchToBabyWithBabyId:babyId];
    if ([self isBabyIdEquelCurrentBabyIdWithBabyId:babyId] && self.babySOSMessagTimer) {
        [self.mapView loadBabyMapListWithBabyUserInfo:self.currentBabyUserInfo];
    }
}

-(void)loginWithNativeParams:(NSDictionary *)nativeParams{
    WEAKSELF
    dispatch_block_t block = ^(){
        [weakSelf checkLogin];
    };
    
    if (IOS_VERSION >= 8.0) {
        if (block) {
            block();
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    }
}

-(void)switchToBabyWithBabyId:(NSNumber *)babyId{
    if (babyId == nil) {
        return;
    }
    // 与当前的宝贝相同，则不切换
    if ([self isBabyIdEquelCurrentBabyIdWithBabyId:babyId]) {
        return;
    }
    // 与当前的宝贝不同，则切换到指定的宝贝
    [self.babyHorizontalListView switchToBabyWithBabyId:babyId];
}

-(BOOL)isBabyIdEquelCurrentBabyIdWithBabyId:(NSNumber *)babyId{
    return [babyId integerValue] == [self.currentBabyUserInfo.babyId integerValue];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化
    [self initHomeSubViews];
    [self initStatusCenter];
    [self initMessageManager];
    [self initNotification];
    [self initBabyHorizontalListViewBlock];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initHomeSubViews{
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.rightOperationLayerView];
    [self.view addSubview:self.leftRefreshLocationLayerView];
}

-(void)initStatusCenter{
    [EHDeviceStatusCenter sharedCenter].didGetDeviceStatus = ^(EHDeviceStatusModel* deviceStatusModel){
        EHDeviceStatusMessageModel* messageModel = [EHDeviceStatusMessageModel new];
        messageModel.deviceStatusModel = deviceStatusModel;
        [[EHMessageManager sharedManager] sendMessage:messageModel];
        if (deviceStatusModel.message_number) {
            [self.navBarRightView setupPointImageStatusWithNumber:deviceStatusModel.message_number];
        }
    };
    
    [EHDeviceStatusCenter sharedCenter].getDeviceStatusFail = ^(void){
        EHNoneMessageModel* messageModel = [EHNoneMessageModel new];
        [[EHMessageManager sharedManager] sendMessage:messageModel];
    };
    
}

-(void)initMessageManager{
    [EHMessageManager sharedManager].sourceTarget = self.view;
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyDidChangedNotification:) name:EHBindBabySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyDidChangedNotification:) name:EHUNBindBabySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyDidChangedNotification:) name:EHBabyInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geofenceDidChangedNotification:) name:EHGeofenceChangeNotification object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 设备状态管理器控制 method
-(void)resetStatusCenter{
    [[EHDeviceStatusCenter sharedCenter] stop];
}

-(void)configStatusCenter{
    if ([EHBabyListDataCenter sharedCenter].currentBabyUserInfo.babyId) {
        [[EHDeviceStatusCenter sharedCenter] setupDeviceCenterWithBabyId:[NSString stringWithFormat:@"%@",[EHBabyListDataCenter sharedCenter].currentBabyUserInfo.babyId]];
    }
    else
    {
        [[EHDeviceStatusCenter sharedCenter] setupDeviceCenterWithBabyId:nil];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override method refreshDataRequest 刷新数据
-(void)refreshDataRequest{
    // 如果isViewAppeared则表示当前VC正在展示，收到消息则直接刷新，如果不在展示则_needRefreshBabyList置为YES
    if (self.isViewAppeared) {
        [self refreshBabyList];
    }else{
        _needRefreshBabyList = YES;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - refresh baby list method

-(void)refreshBabyList{
    [self.babyHorizontalListView refreshDataRequest];
}

-(void)refreshMaoGeofenceList{
    [self.mapView loadGeofenceListWithBabyUserInfo:self.currentBabyUserInfo];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 收到登录、登出、添加宝贝等消息后标记需要刷新
    if (_needRefreshBabyList) {
        _needRefreshBabyList = NO;
        [self refreshBabyList];
    }else if (_needRefreshGeofengList) {
        _needRefreshGeofengList = NO;
        [self refreshMaoGeofenceList];
    }
}

-(BOOL)needSetupBabyData{
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  mapview、navBarTItleView
-(EHMapOverLayWithOutLineServiceContainer *)mapView{
    if (_mapView == nil) {
        _mapView = [[EHMapOverLayWithOutLineServiceContainer alloc] initWithFrame:self.view.bounds];
        WEAKSELF
        _mapView.shouldSelectAnnotationViewAfterRefreshMap = ^(EHMapServiceContainer* mapService){
            STRONGSELF
            if (strongSelf.babySOSMessagTimer == nil) {
                return YES;
            }else{
                return NO;
            }
        };
        
        _mapView.finishedRefreshService = ^(EHMapServiceContainer* mapService){
            STRONGSELF
            if (strongSelf.babySOSMessagTimer == nil) {
                return;
            }
            NSUInteger index = mapService.currentPositionIndex;
            for (EHUserDevicePosition* position in mapService.positionArray) {
                if (![position isKindOfClass:[EHUserDevicePosition class]]) {
                    continue;
                }
                NSRange range = [position.location_time rangeOfString:strongSelf.babySOSMessagTimer];
                if (range.location != NSNotFound) {
                    index = [mapService.positionArray indexOfObject:position];
                    break;
                }
            }
            [mapService selectAnnotationViewWithIndex:index];
            
            strongSelf.babySOSMessagTimer = nil;
        };
    }
    return _mapView;
}

-(void)navBarTitleViewDidSelect:(EHHomeNavBarTItleView*)navBarTitleView{
    [super navBarTitleViewDidSelect:navBarTitleView];
#ifdef DEBUG_SEND_MESSAGE
    [self sendSOSMessage];
#endif
}

#ifdef DEBUG_SEND_MESSAGE
-(void)sendSOSMessage{
    static EHMessageInfoListService* messageService = nil;
    if (messageService == nil) {
        messageService = [EHMessageInfoListService new];
        messageService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            EHLogInfo(@"-----> message send success");
        };
    }
    [messageService sendSOSMessageInfoListWithDeviceCode:[NSString stringWithFormat:@"%@",self.currentBabyUserInfo.device_code] address:nil];
}
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 操作图层  rightOperationLayerView（电子围栏、电话）、leftRefreshLocationLayerView(刷新按钮)
-(EHHomeOperationLayerView *)rightOperationLayerView{
    if (_rightOperationLayerView == nil) {
        _rightOperationLayerView = [[EHHomeOperationLayerView alloc] initWithFrame:CGRectMake(self.view.width - rightOperationLayerView_width - rightOperationLayerView_rightBorder, self.view.height - rightOperationLayerView_height - rightOperationLayerView_bottomBorder, rightOperationLayerView_width, rightOperationLayerView_height)];
        WEAKSELF
        _rightOperationLayerView.historyTraceListBtnClickedBlock = ^(UIButton* historyListBtn){
            STRONGSELF
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            if (strongSelf.mapView.positionArray) {
                [params setObject:strongSelf.mapView.positionArray forKey:@"positionListArray"];
            }
            void(^historyTraceListDidSelectedBlock)(NSArray* dataList, NSUInteger index) = ^(NSArray* dataList, NSUInteger index) {
                STRONGSELF
                NSUInteger dataListCount = [dataList count];
                if (dataListCount == 0 || dataListCount <= index) {
                    return;
                }
                EHUserDevicePosition* oldLastposition = [[strongSelf.mapView positionArray] lastObject];
                EHUserDevicePosition* newLastposition = [dataList lastObject];
                
                BOOL needRefreshMapViewWithDataList = NO;
                
                if (oldLastposition != nil
                    && newLastposition != nil
                    && ![newLastposition.location_time isEqualToString:oldLastposition.location_time]) {
                    needRefreshMapViewWithDataList = YES;
                }

                if ([[strongSelf.mapView positionArray] count] == dataListCount && !needRefreshMapViewWithDataList) {
                    [strongSelf.mapView selectAnnotationViewWithIndex:index];
                }else{
                    [strongSelf.mapView selectAnnotationViewWithPositionList:dataList withIndex:index];
                }
            };
            if (historyTraceListDidSelectedBlock) {
                [params setObject:historyTraceListDidSelectedBlock forKey:@"historyTraceListDidSelectedBlock"];
            }
            TBOpenURLFromSourceAndParams(internalURL(@"EHMapHistoryTraceViewController"), strongSelf,params);
        };
    }
    return _rightOperationLayerView;
}

-(EHRefreshLocationLayerView *)leftRefreshLocationLayerView{
    if (_leftRefreshLocationLayerView == nil) {
        _leftRefreshLocationLayerView = [[EHRefreshLocationLayerView alloc] initWithFrame:CGRectMake(leftRefreshLocationLayerView_leftBorder, self.view.height - leftRefreshLocationLayerView_bottomBorder - leftRefreshLocationLayerView_height, leftRefreshLocationLayerView_width, leftRefreshLocationLayerView_height)];
        WEAKSELF
        _leftRefreshLocationLayerView.refreshLocationBlock = ^(BOOL needRefreshLocation){
            STRONGSELF
            // 根据当前选择的宝贝刷新轨迹
            if (needRefreshLocation && strongSelf.currentBabyUserInfo && strongSelf.currentBabyUserInfo.babyId > 0) {
                [strongSelf.mapView loadBabyMapListWithBabyUserInfo:strongSelf.currentBabyUserInfo];
            }else{
                [strongSelf showLoadingViewAfterDelay:0.3];
                [strongSelf.mapView selectAnnotationViewWithIndex:strongSelf.mapView.currentPositionIndex];
            }
        };
    }
    return _leftRefreshLocationLayerView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  babyHorizontalListViewBlock（下拉宝贝列表）及动画操作
-(void)initBabyHorizontalListViewBlock{
    [self refreshBabyList];
    WEAKSELF
    self.babyHorizontalListView.babyListViewClickedBlock = ^(EHBabyHorizontalBasicListView* babyListView,NSInteger index, NSInteger preIndex, EHGetBabyListRsp* babyUserInfo){
        STRONGSELF
        if (preIndex != index && babyUserInfo && babyUserInfo.babyId > 0) {
            // 重置message展示
            EHNoneMessageModel* messageModel = [EHNoneMessageModel new];
            [[EHMessageManager sharedManager] sendMessage:messageModel];
            // 更新当前选中的宝贝
            strongSelf.currentBabyUserInfo = babyUserInfo;
            // 更新宝贝数据中心的数据
            [[EHBabyListDataCenter sharedCenter] setCurrentBabyUserInfo:babyUserInfo];
            [[EHBabyListDataCenter sharedCenter] setCurrentBabyId:[NSString stringWithFormat:@"%@",babyUserInfo.babyId]];
            // 选中后更新各层数据并调整样式
            [strongSelf.mapView loadBabyMapListWithBabyUserInfo:babyUserInfo];
            [strongSelf.navBarTitleView setBtnTitle:babyUserInfo.babyNickName];
            [strongSelf.rightOperationLayerView setBabyUserInfo:babyUserInfo];
            [strongSelf.leftRefreshLocationLayerView setBabyUserInfo:babyUserInfo];
            [strongSelf.leftRefreshLocationLayerView setHidden:NO];
            // 重置设备状态管理中心
            [strongSelf configStatusCenter];
        }
        if (preIndex != EHBabyNonFoundNum) {
            [strongSelf.navBarTitleView setButtonSelected:YES];
        }
    };
    
    self.babyHorizontalListView.hasBabyDataBlock = ^(EHBabyHorizontalBasicListView* babyListView, BOOL hasBabyData){
        STRONGSELF
        if (!hasBabyData) {
            [strongSelf.navBarTitleView setBtnTitle:@"暂无用户"];
            [strongSelf.mapView resetMapAnnotation];
            [strongSelf.mapView resetMapGeoFenceOverLay];
            [strongSelf.rightOperationLayerView setBabyUserInfo:nil];
            [strongSelf.leftRefreshLocationLayerView setHidden:YES];
            // 更新宝贝数据中心的数据
            [[EHBabyListDataCenter sharedCenter] setCurrentBabyUserInfo:nil];
            [[EHBabyListDataCenter sharedCenter] setCurrentBabyId:nil];
            [[EHBabyListDataCenter sharedCenter] setBabyList:nil];
            strongSelf.currentBabyUserInfo = nil;
            // 重置设备状态管理中心
            [strongSelf configStatusCenter];
            
            // 重置message展示
            EHNoneMessageModel* messageModel = [EHNoneMessageModel new];
            [[EHMessageManager sharedManager] sendMessage:messageModel];
            // 重置消息提示小红点
            [[NSNotificationCenter defaultCenter] postNotificationName:EHClearRemoteMessageAttentionNotification object:nil userInfo:nil];
            // to do show 未绑定 提醒
            if (!strongSelf.didSendDeviceBindingMessage) {
                strongSelf.didSendDeviceBindingMessage = YES;
                EHDeviceBindingMessageModel* messageModel = [EHDeviceBindingMessageModel new];
                [[EHMessageManager sharedManager] sendMessage:messageModel];
            }
        }else{
            [[EHBabyListDataCenter sharedCenter] setBabyList:((EHHomeBabyHorizontalListView*)babyListView).babyListArray];
        }
    };
}

-(void)setBabyHorizontalListViewShow:(BOOL)show{
    EHAttentionMessageModel* messageModel = [EHAttentionMessageModel new];
    messageModel.hideAttentionView = show;
    [[EHMessageManager sharedManager] sendMessage:messageModel];
    [super setBabyHorizontalListViewShow:show];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 登录相关操作

-(void)userDidLogin:(NSDictionary*)userInfo{
    [super userDidLogin:userInfo];
    /*!
     *  @brief  正常逻辑是先调用userDidLogin，设置_needRefreshBabyList然后再调用viewWillAppear刷新，
     *          异常情况：可能会出现userDidLogin调用顺序在viewWillAppear之后的情况。
     *          解决方案：如果发现有则使用[self.babyHorizontalListView refreshDataRequest];
     *
     *  @solve [self.babyHorizontalListView refreshDataRequest];
     */
    self.currentBabyUserInfo = nil;
    _didSendDeviceBindingMessage = NO;
    [self refreshBabyList];
}

-(void)userDidLogout:(NSDictionary*)userInfo{
    [super userDidLogout:userInfo];
    // 清除数据
    [self resetHomeVCData];
    [self refreshDataRequest];
}

-(void)currentSelectBabyChanged:(NSDictionary*)userInfo{
    NSNumber* babyId = [userInfo objectForKey:EHSELEC_BABY_ID_DATA];
    [self switchToBabyWithBabyId:babyId];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 添加或是接触宝贝消息响应

-(void)babyDidChangedNotification:(NSNotification*)notification{
    BOOL isNeedForceRefreshData = [[notification.userInfo objectForKey:EHFORCE_REFRESH_DATA] boolValue];
    if (isNeedForceRefreshData) {
        [self refreshBabyList];
    }else{
        [self refreshDataRequest];
    }
}

-(void)geofenceDidChangedNotification:(NSNotification*)notification{
    BOOL isNeedForceRefreshGeofence = [[notification.userInfo objectForKey:EHFORCE_REFRESH_DATA] boolValue];
    if (isNeedForceRefreshGeofence || self.isViewAppeared) {
        [self refreshMaoGeofenceList];
    }else{
        _needRefreshGeofengList = YES;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 重置HomeVC的数据

-(void)resetHomeVCData{
    /*!
     *  @brief 清除map数据，清除宝贝列表数据
     *
     *  @solve
     */
    [self resetStatusCenter];
    [self.mapView resetMapAnnotation];
    [self.navBarTitleView setBtnTitle:@"暂无用户"];
    [self.babyHorizontalListView resetBabyHorizontailListView];
    self.currentBabyUserInfo = nil;
    // 重置message展示
    EHNoneMessageModel* messageModel = [EHNoneMessageModel new];
    [[EHMessageManager sharedManager] sendMessage:messageModel];
    
}

@end
