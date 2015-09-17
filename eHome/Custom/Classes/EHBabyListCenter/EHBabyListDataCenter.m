//
//  EHBabyListDataCenter.m
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyListDataCenter.h"
#import "EHGetBabyListService.h"
#import "EHUserDefaultData.h"

@interface EHBabyListDataCenter()

@property (nonatomic, strong) EHGetBabyListService *babyListService;

@end

@implementation EHBabyListDataCenter

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)dealloc{
    _babyListService = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)config{
    [self initBabyDeviceStatus];
    [self initNotification];
}

-(void)initBabyDeviceStatus{
    self.currentBabyDeviceStatus = [EHBabyDeviceStatus new];
    self.currentBabyDeviceStatus.device_status = [NSNumber numberWithInteger:EHDeviceStatus_OnLine];
    self.currentBabyDeviceStatus.device_kwh = [NSNumber numberWithInteger:EHDeviceHighKwhNumber];
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyDidChangedNotification:) name:EHBindBabySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyDidChangedNotification:) name:EHUNBindBabySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyDidChangedNotification:) name:EHUNBabyRelationChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginNotification:) name:kUserLoginSuccessNotification object:nil];
}

-(void)setCurrentBabyUserInfo:(EHGetBabyListRsp *)currentBabyUserInfo{
    _currentBabyUserInfo = currentBabyUserInfo;
    _currentBabyDeviceStatus.babyId = currentBabyUserInfo.babyId;
    _currentBabyDeviceStatus.device_status = currentBabyUserInfo.device_status;
}

-(void)setCurrentBabyPosition:(EHUserDevicePosition *)currentBabyPosition{
    _currentBabyPosition = currentBabyPosition;
    _currentBabyDeviceStatus.device_kwh = currentBabyPosition.device_kwh;
}

- (void)setCurrentSelectBabyId:(NSNumber *)currentSelectBabyId{
    if (currentSelectBabyId == nil) {
        return;
    }
    
    NSNumber* currentSelectBabyIdNumber = nil;
    
    if ([currentSelectBabyId isKindOfClass:[NSString class]]) {
        currentSelectBabyIdNumber = [NSNumber numberWithInteger:[currentSelectBabyId integerValue]];
    }else if ([currentSelectBabyId isKindOfClass:[NSNumber class]]){
        currentSelectBabyIdNumber = currentSelectBabyId;
    }else{
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EHCurrentSelectBabyChangedNotification object:nil userInfo:@{EHSELEC_BABY_ID_DATA:currentSelectBabyIdNumber}];
}

- (EHGetBabyListRsp*)getBabyListRspWithBabyId:(NSNumber *)babyId{
    if (babyId == nil) {
        return nil;
    }
    
    NSNumber* babyIdNumber = nil;
    
    if ([babyId isKindOfClass:[NSString class]]) {
        babyIdNumber = [NSNumber numberWithInteger:[babyId integerValue]];
    }else if ([babyId isKindOfClass:[NSNumber class]]){
        babyIdNumber = babyId;
    }else{
        return nil;
    }
    EHGetBabyListRsp *babyListRsp = nil;
    for (EHGetBabyListRsp *babyListRspTmp in self.babyList) {
        if ([babyListRspTmp.babyId integerValue] == [babyIdNumber integerValue]) {
            babyListRsp = babyListRspTmp;
            break;
        }
    }
    return babyListRsp;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - refreshDataRequest 刷新数据
-(void)refreshDataRequest{
    // 如果isViewAppeared则表示当前VC正在展示，收到消息则直接刷新，如果不在展示则_needRefreshBabyList置为YES
//    [self.babyListService loadData];
}

-(void)setupBabyDataWithDataList:(NSArray*)dataList{
    NSInteger preSelectBabyId = [EHUserDefaultData getCurrentSelectBabyId];
    BOOL fineBaby = NO;
    for (EHGetBabyListRsp *babyUser in dataList) {
        if (![babyUser isKindOfClass:[EHGetBabyListRsp class]]) {
            continue;
        }
        // 设置存储的选中的宝贝，如果没有则选为默认
        if ([babyUser.babyId integerValue] == preSelectBabyId) {
            self.currentBabyId = [NSString stringWithFormat:@"%@",babyUser.babyId];
            self.currentBabyUserInfo = babyUser;
            fineBaby = YES;
            break;
        }
    }
    // 没有默认选择的宝贝则设置第一个宝贝为选中的宝贝
    if (!fineBaby && dataList && [dataList count] > 0) {
        EHGetBabyListRsp *babyUser = [dataList objectAtIndex:0];
        self.currentBabyId = [NSString stringWithFormat:@"%@",babyUser.babyId];
        self.currentBabyUserInfo = babyUser;
    }
}

-(void)resetBabyData{
    self.currentBabyId = nil;
    self.currentBabyUserInfo = nil;
    self.babyList = nil;
}

#pragma mark - babyListService  宝贝列表数据获取

-(EHGetBabyListService *)babyListService{
    if (!_babyListService) {
        _babyListService = [EHGetBabyListService new];
        // service 返回成功 block
        WEAKSELF
        _babyListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            strongSelf.isServiceFailed = NO;
            strongSelf.babyList = service.dataList;
            [strongSelf setupBabyDataWithDataList:strongSelf.babyList];
        };
        // service 返回失败 block
        _babyListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            strongSelf.isServiceFailed = YES;
        };
    }
    return _babyListService;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 登陆相关 登录消息

-(void)userDidLoginNotification:(NSNotification*)notification{
    [self refreshDataRequest];
}

-(void)userDidLogoutNotification:(NSNotification*)notification{
    [self resetBabyData];
    [self refreshDataRequest];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 添加或是接触宝贝消息响应

-(void)babyDidChangedNotification:(NSNotification*)notification{
    [self refreshDataRequest];
}

@end
