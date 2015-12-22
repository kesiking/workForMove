//
//  EHChatTabViewController.m
//  eHome
//
//  Created by jweigang on 15/11/16.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHChatTabViewController.h"
#import "EHDeviceStatusCenter.h"
#import "EHMessageHeader.h"
#import "EHBabySingleChatMessageViewController.h"

@interface EHChatTabViewController ()

// 当前选中的宝贝
@property (nonatomic, strong) EHGetBabyListRsp                      *currentBabyUserInfo;
@property (nonatomic, strong) EHBabySingleChatMessageViewController *chatVC;
@property (nonatomic, strong) NSMutableArray                        *unSelectedbabyIdArray;
@end

@implementation EHChatTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    self.unSelectedbabyIdArray = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveUnselectedBabyChatMessage:) name:EHRecieveUnselectedBabyChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveSelectedBabyChatMessage:) name:EHRecieveSelectedBabyChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clearTabBarRedPoint];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"before: childViewControllers:%@",self.childViewControllers);
//    [self.chatVC willMoveToParentViewController:nil];
//    [self.chatVC removeFromParentViewController];
//    [self.chatVC.view removeFromSuperview];
//    NSLog(@"after : childViewControllers:%@",self.childViewControllers);
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EHRecieveUnselectedBabyChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EHRecieveSelectedBabyChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserLogoutSuccessNotification object:nil];
}
-(void)babyHorizontalListViewBabyCliced:(EHGetBabyListRsp*)babyUserInfo
{
    if ([babyUserInfo.babyId integerValue] == [self.currentBabyUserInfo.babyId integerValue] && babyUserInfo != nil) {
        // the same， do not switch
        return;
    }
    if (self.unSelectedbabyIdArray && [self.unSelectedbabyIdArray containsObject:babyUserInfo.babyId]) {
        [self.unSelectedbabyIdArray removeObject:babyUserInfo.babyId];
        if ([self rdv_tabBarController].selectedIndex != EHTabBarViewControllerType_Home) {
            [self setTabBarWithRedPoint];
        }
        if (self.unSelectedbabyIdArray == nil || [self.unSelectedbabyIdArray count] == 0) {
            self.navBarTitleView.redPointImageView.hidden = YES;
        }
    }
    if (babyUserInfo) {
        if (self.currentBabyUserInfo != nil) {
            [self.navBarTitleView setButtonSelected:YES];
        }
    }else{
        [self.navBarTitleView setBtnTitle:@"暂无宝贝"];
        self.currentBabyUserInfo = nil;
    }
    self.currentBabyUserInfo = babyUserInfo;
    [self.chatVC viewWillAppear:YES];
    [self.chatVC reloadDataWithBabyId:self.currentBabyUserInfo.babyId];
}

- (EHBabySingleChatMessageViewController *)chatVC
{
    if (!_chatVC) {
    _chatVC = [[EHBabySingleChatMessageViewController alloc]init];
    _chatVC.view.frame = self.view.frame;
    }
    return _chatVC;
}
- (void) appDidBecomeActive
{
    [self.chatVC reloadDataWithBabyId:self.currentBabyUserInfo.babyId];
}
- (void) recieveUnselectedBabyChatMessage:(NSNotification *)notification
{
    NSNumber *unselectedBabyId = [notification.userInfo objectForKey:@"baby_id"];
    if (!_unSelectedbabyIdArray) {
        _unSelectedbabyIdArray = [[NSMutableArray alloc]init];
    }
    if (![_unSelectedbabyIdArray containsObject:unselectedBabyId]) {
        [_unSelectedbabyIdArray addObject:unselectedBabyId];
    }
    self.navBarTitleView.redPointImageView.hidden = NO;
    [self.babyHorizontalListView hasUnselectedBabyChatMessageWithBabyId:unselectedBabyId];
}
- (void) recieveSelectedBabyChatMessage: (NSNotification *)notification
{
    if ([self rdv_tabBarController].selectedIndex != EHTabBarViewControllerType_Home) {
        [self setTabBarWithRedPoint];
    }
}
- (void) userDidLogoutNotification:(NSNotification*)notification
{
    [self.unSelectedbabyIdArray removeAllObjects];
    self.unSelectedbabyIdArray = nil;
    self.currentBabyUserInfo = nil;
    self.navBarTitleView.redPointImageView.hidden = YES;
    [self.babyHorizontalListView clearListViewRedPoints];
}
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
    NSNumber* babyId = [nativeParams objectForKey:kEHOMETabHomeGetBabyId];
    if (babyId) {
        return YES;
    }
    return NO;
}

-(BOOL)needLoginWithNativeParams:(NSDictionary *)nativeParams{
    return [[nativeParams objectForKey:kEHOMETabHomeNeedLogin] boolValue];
}

-(void)switchToBabyWithNativeParams:(NSDictionary *)nativeParams{
    NSNumber* babyId = [nativeParams objectForKey:kEHOMETabHomeGetBabyId];
    [self switchToBabyWithBabyId:babyId];
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
        EHLogError(@"babyid is nil");
        return;
    }
    // 与当前的宝贝相同，则不切换
    if ([self isBabyIdEquelCurrentBabyIdWithBabyId:babyId]) {
        EHLogInfo(@"babyid is the same as current");
        return;
    }
    EHLogInfo(@"babyid  = %@", babyId);
    // 与当前的宝贝不同，则切换到指定的宝贝
    [self.babyHorizontalListView switchToBabyWithBabyId:babyId];
}

-(BOOL)isBabyIdEquelCurrentBabyIdWithBabyId:(NSNumber *)babyId{
    return [babyId integerValue] == [self.currentBabyUserInfo.babyId integerValue];
}
@end
