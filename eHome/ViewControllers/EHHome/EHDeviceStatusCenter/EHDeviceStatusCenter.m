//
//  EHDeviceStatusCenter.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDeviceStatusCenter.h"
#import "EHQueryForTopMessage.h"
#import "EHNetworkMessageModel.h"
#import "EHMessageManager.h"

#define default_timer_second (5 * 60.0)

#define kEHShakeNoticeKey @"shakeNoticeKey"     //震动
#define kEHVoiceNoticeKey @"voiceNoticeKey"     //声音
#define kEHNoticeKey @"noticeKey"               //通知提醒

@interface EHDeviceStatusCenter()

@property (nonatomic,strong)  EHQueryForTopMessage*   queryDeviceStatusService;

@property (nonatomic,strong)  NSString            *   babyId;

@property (nonatomic,strong)  NSTimer             *   timer;

@end

@implementation EHDeviceStatusCenter

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
    [self invalidateTimer];
    _queryDeviceStatusService = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)config{
    self.second = default_timer_second;
    [self initTimer];
    [self initNotification];
    [self initNetworkMonitoring];
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundStopTimer)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiveRestartTimer)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}

-(void)initNetworkMonitoring{
     [[AFNetworkReachabilityManager sharedManager] startMonitoring];
     [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusReachableViaWWAN && status != AFNetworkReachabilityStatusReachableViaWiFi) {
            // to do send network message
            [self sendNetWorkMessageWithIsReachable:NO];
        }else{
            [self sendNetWorkMessageWithIsReachable:YES];
        }
     }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - send network message method
-(void)sendNetWorkMessageWithIsReachable:(BOOL)isReachable{
    EHNetworkMessageModel* messageModel = [EHNetworkMessageModel new];
    messageModel.isReachable = isReachable;
    [[EHMessageManager sharedManager] sendMessage:messageModel];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - timer init method

-(void)initTimer{
    if (self.second <= 0 ) {
        self.second = default_timer_second;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.second target:self selector:@selector(centerTimerFunction:) userInfo:nil repeats:YES];
}

- (void)invalidateTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)centerTimerFunction:(NSTimer*)timer{
    if (self.babyId) {
        [self.queryDeviceStatusService queryForTopMessageWithUserPhone:[KSAuthenticationCenter userPhone] babyId:self.babyId];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - queryDeviceStatusService

-(EHQueryForTopMessage *)queryDeviceStatusService{
    if (_queryDeviceStatusService == nil) {
        _queryDeviceStatusService = [EHQueryForTopMessage new];
        WEAKSELF
        _queryDeviceStatusService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            if (service.item) {
                EHLogInfo(@"----> query device status service success: %@",service.item);
                EHDeviceStatusModel* deviceStatusModel = (EHDeviceStatusModel*)service.item;
                if (strongSelf.didGetDeviceStatus) {
                    strongSelf.didGetDeviceStatus(deviceStatusModel);
                }
            }
        };
        _queryDeviceStatusService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError * error){
            STRONGSELF
            EHLogInfo(@"----> query device status service fail");
            if (strongSelf.getDeviceStatusFail) {
                strongSelf.getDeviceStatusFail();
            }
        };
    }
    return _queryDeviceStatusService;
}

- (void)setupDeviceCenterWithBabyId:(NSString*)babyId{
    if (self.babyId != babyId) {
        [self reset];
        self.babyId = babyId;
        [self.queryDeviceStatusService queryForTopMessageWithUserPhone:[KSAuthenticationCenter userPhone] babyId:self.babyId];
    }
}

- (NSString*)getCurrentBabyId{
    if ([[EHBabyListDataCenter sharedCenter] currentBabyId]) {
        return [[EHBabyListDataCenter sharedCenter] currentBabyId];
    }
    return self.babyId;
}

- (BOOL)didGetCurrentLoaction{
    return self.currentLocation != nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- needShakeNotice, needVoiceNotice, neednNoticeNotice
/*!
 *  @brief  needShakeNotice, needVoiceNotice, neednNoticeNotice 返回设置状态
 *
 *  @return 默认为YES
 *
 *  @since 1.0
 */
-(BOOL)needShakeNotice{
    NSNumber *shakeNumber = @YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //震动
    if ([userDefaults objectForKey:kEHShakeNoticeKey]) {
        shakeNumber = [userDefaults objectForKey:kEHShakeNoticeKey];
    }
    return [shakeNumber boolValue];
}

-(BOOL)needVoiceNotice{
    NSNumber *voiceNumber = @YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //声音
    if ([userDefaults objectForKey:kEHVoiceNoticeKey]) {
        voiceNumber = [userDefaults objectForKey:kEHVoiceNoticeKey];
    }
    return [voiceNumber boolValue];
}

-(BOOL)neednNoticeNotice{
    NSNumber *noticeNumber = @YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //声音
    if ([userDefaults objectForKey:kEHNoticeKey]) {
        noticeNumber = [userDefaults objectForKey:kEHNoticeKey];
    }
    return [noticeNumber boolValue];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - timer operation method

- (void)reset{
    [self invalidateTimer];
    [self initTimer];
}

- (void)stop{
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)start{
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method

-(void)backgroundStopTimer{
    [self stop];
}

-(void)becomeActiveRestartTimer{
    [self start];
}

@end
