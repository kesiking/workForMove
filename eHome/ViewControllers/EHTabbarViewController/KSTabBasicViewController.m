//
//  KSMainViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSTabBasicViewController.h"
#import "EHAleatView.h"
#import "EHDeviceStatusCenter.h"

#define babyHorizontalListViewHeight (self.view.height)

@interface KSTabBasicViewController ()

@property(nonatomic,assign) BOOL                 isLoginLoading;

@end

@implementation KSTabBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBasicNavBarViews];
    [self initBasicSubViews];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginNotification:) name:kUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentSelectBabyChangedNotification:) name:EHCurrentSelectBabyChangedNotification object:nil];
}

-(void)initBasicNavBarViews{
    //    self.titleView = self.navBarTitleView;
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarTitleView];
    self.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarRightView];
    self.rightBarButtonItem = rightBarButtonItem;
}

-(void)initBasicSubViews{
    [self.view addSubview:self.babyHorizontalListView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self.navBarTitleView setButtonSelected:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIViewController *rdv_tabBarController = self.rdv_tabBarController;
    [rdv_tabBarController setTitle:self.title];
    if (self.needLogin && IOS_VERSION >= 8.0) {
        // 查看是否登陆，如果未登陆则跳出登陆
        [self checkLogin];
    }
    // 设置bar颜色
//    UINavigationController* navigationController = self.navigationController;
//    if([navigationController.navigationBar respondsToSelector:@selector(barTintColor)]){
//        navigationController.navigationBar.barTintColor = RGB(0xed, 0x65, 0x65);
//    }else if([navigationController.navigationBar respondsToSelector:@selector(tintColor)]){
//        navigationController.navigationBar.tintColor = RGB(0xed, 0x65, 0x65);
//    }
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.titleView = self.titleView;
    self.navigationController.navigationBarHidden = NO;
    
    if ([self needSetupBabyData]) {
        [self switchToBabyWithBabyId:[NSNumber numberWithInteger:[[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]]];
        [self.babyHorizontalListView setupBabyDataWithDataList:[[EHBabyListDataCenter sharedCenter] babyList]];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needLogin  && IOS_VERSION < 8.0) {
        // 查看是否登陆，如果未登陆则跳出登陆
        [self checkLogin];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)measureViewFrame{
    [super measureViewFrame];
    CGRect frame = self.view.frame;
    frame.size.height -= 44;
    if (!CGRectEqualToRect(frame, self.view.frame)) {
        [self.view setFrame:frame];
    }
}

-(void)setNeedLogin:(BOOL)needLogin{
    _needLogin = needLogin;
}

-(UINavigationItem *)navigationItem{
    if (self.rdv_tabBarController.navigationItem) {
        return self.rdv_tabBarController.navigationItem;
    }
    return [super navigationItem];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  navBarTItleView
-(EHHomeNavBarTItleView *)navBarTitleView{
    if (_navBarTitleView == nil) {
        _navBarTitleView = [[EHHomeNavBarTItleView alloc] initWithFrame:CGRectMake(0, 0, caculateNumber(200), 44)];
        WEAKSELF
        _navBarTitleView.buttonClicedBlock = ^(EHHomeNavBarTItleView* navBarTitleVIew){
            STRONGSELF
            [strongSelf navBarTitleViewDidSelect:navBarTitleVIew];
        };
    }
    return _navBarTitleView;
}

-(void)navBarTitleViewDidSelect:(EHHomeNavBarTItleView*)navBarTitleView{
    [self setBabyHorizontalListViewShow:navBarTitleView.btnIsSelected];
    // 当导航栏被选中且当前babyHorizontalListView获取宝贝列表失败，怎重新获取列表
    if (navBarTitleView.btnIsSelected
        && self.babyHorizontalListView.isServiceFailed == YES) {
        [self.babyHorizontalListView refreshDataRequest];
    }
}

-(EHHomeNavBarRightView *)navBarRightView{
    if (_navBarRightView == nil) {
        _navBarRightView = [EHHomeNavBarRightView sharedCenter];
//        _navBarRightView.frame = CGRectMake(0, 0, 60, 44);
        WEAKSELF
        _navBarRightView.buttonClickedBlock = ^(EHHomeNavBarRightView* navBarRightView){
            STRONGSELF
            [strongSelf navBarRightViewDidSelect:navBarRightView];
        };
    }
    return _navBarRightView;
}
//-(void)navBarRightViewDidSelect:(EHHomeNavBarRightView*)navBarRightView{
//    TBOpenURLFromSourceAndParams(internalURL(@"EHMessageInfoViewController"), self, nil);
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 消息响应 messageBtnClicked
-(void)messageBtnClicked:(id)sender{
    // goto 消息列表页面
//    BOOL isLogin = [KSAuthenticationCenter isLogin];
//    if (isLogin) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        //        if (self.babyHorizontalListView.babyListArray) {
        //            [params setObject:self.babyHorizontalListView.babyListArray forKey:@"babyListArray"];
        //        }
        if ([[EHDeviceStatusCenter sharedCenter].currentMessageType integerValue] == EHCurrentMessageType_systemMessage) {
            [params setObject:@(1) forKey:@"systemMessageType"];
        }
        TBOpenURLFromTargetWithNativeParams(internalURL(@"EHMessageInfoViewController"), self, @{ACTION_ANIMATION_KEY:@(true)} ,params);
    
        [EHDeviceStatusCenter sharedCenter].currentMessageType = [NSNumber numberWithLong:EHCurrentMessageType_babyMessage];
    
        //        TBOpenURLFromSourceAndParams(internalURL(@"EHMessageInfoViewController"), self, params);
//    }else{
//        [self alertCheckLoginWithCompleteBlock:nil];
//    }
}

-(void)navBarRightViewDidSelect:(EHHomeNavBarRightView*)navBarRightView{
    [self messageBtnClicked:navBarRightView];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  babyHorizontalListView（下拉宝贝列表）及动画操作
-(EHHomeBabyHorizontalListView *)babyHorizontalListView{
    if (_babyHorizontalListView == nil) {
        _babyHorizontalListView = [[EHHomeBabyHorizontalListView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, babyHorizontalListViewHeight)];
        _babyHorizontalListView.alpha = 0;
        WEAKSELF
        _babyHorizontalListView.cancelBlock = ^(){
            STRONGSELF
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        _babyHorizontalListView.babyListViewClickedBlock = ^(EHBabyHorizontalBasicListView* babyListView,NSInteger index, NSInteger preIndex, EHGetBabyListRsp* babyUserInfo){
            STRONGSELF
            if (preIndex != index && babyUserInfo && babyUserInfo.babyId > 0) {
                // 更新宝贝数据中心的数据
                [[EHBabyListDataCenter sharedCenter] setCurrentSelectBabyId:babyUserInfo.babyId];
                [strongSelf.navBarTitleView setBtnTitle:babyUserInfo.babyNickName];
                [strongSelf babyHorizontalListViewBabyCliced:babyUserInfo];
            }
            if (preIndex != EHBabyNonFoundNum) {
                [strongSelf.navBarTitleView setButtonSelected:YES];
            }
        };
        
        _babyHorizontalListView.addBabyClickedBlock = ^(EHHomeBabyHorizontalListView* babyListView){
            STRONGSELF
            // to do add baby
            BOOL isLogin = [KSAuthenticationCenter isLogin];
            if (isLogin) {
                TBOpenURLFromSourceAndParams(internalURL(kEHBabyAtteintion), strongSelf, nil);
            }else{
                [strongSelf alertCheckLoginWithCompleteBlock:nil];
            }
            /*
             * 登录后直接进入添加页面
            [strongSelf alertCheckLoginWithCompleteBlock:^(){
                TBOpenURLFromSourceAndParams(internalURL(kEHBabyAtteintion), strongSelf, nil);
            }];
             */
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        
        _babyHorizontalListView.hasBabyDataBlock = ^(EHBabyHorizontalBasicListView* babyListView, BOOL hasBabyData){
            STRONGSELF
            if (!hasBabyData) {
                [strongSelf.navBarTitleView setBtnTitle:@"暂无用户"];
            }
        };
    }
    return _babyHorizontalListView;
}

-(void)babyHorizontalListViewBabyCliced:(EHGetBabyListRsp*)babyUserInfo{
    
}

-(void)setBabyHorizontalListViewShow:(BOOL)show{
    UIView* linearContainer = [self.babyHorizontalListView valueForKey:@"_linearContainer"];
    UIView* bgImageView = [self.babyHorizontalListView valueForKey:@"_bgImageView"];
    CGRect rect = linearContainer.frame;
    if (show) {
        rect.origin.y = self.view.top;
    }else{
        rect.origin.y = self.view.top - rect.size.height;
    }
    [self.view bringSubviewToFront:self.babyHorizontalListView];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [linearContainer setFrame:rect];
        [bgImageView setFrame:rect];
        self.babyHorizontalListView.alpha = (NSUInteger)(show?1:0);
    } completion:nil];
}

-(BOOL)needSetupBabyData{
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 登陆相关 检查是否登陆

-(void)alertCheckLoginWithCompleteBlock:(dispatch_block_t)completeBlock{
    WEAKSELF
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (!isLogin) {
        EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:LOGIN_ALERTVIEW_MESSAGE/*@"增加成员需要登录账号，是否登录已有账号？"*/ clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
            STRONGSELF
            if (index == 1) {
                [strongSelf doLoginWithCompleteBlock:completeBlock];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [aleatView show];
    }else if (completeBlock) {
        completeBlock();
    }
}

-(void)doLoginWithCompleteBlock:(dispatch_block_t)completeBlock{
    WEAKSELF
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        STRONGSELF
        // 如果登陆成功就跳转到当前
        [strongSelf.rdv_tabBarController setSelectedIndex:EHTabBarViewControllerType_Home];
        if (completeBlock) {
            completeBlock();
        }
    };
    [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:nil source:self];
}

-(BOOL)checkLogin{
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (!isLogin) {
        [self doLogin];
    }
    return isLogin;
}

-(void)doLogin{
    WEAKSELF
    void(^cancelActionBlock)(void) = ^(void){
        STRONGSELF
        strongSelf.isLoginLoading = NO;
        // 如果当前选中的tab就是我的登陆页面，取消登陆后跳转到上次选中的tab
        if (strongSelf == strongSelf.rdv_tabBarController.selectedViewController) {
            [strongSelf.rdv_tabBarController setSelectedIndex:EHTabBarViewControllerType_Home];
        }
    };
    
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        STRONGSELF
        // 如果登陆成功就跳转到当前
        strongSelf.isLoginLoading = NO;
//        [strongSelf.rdv_tabBarController setSelectedViewController:strongSelf];
        [strongSelf.rdv_tabBarController setSelectedIndex:EHTabBarViewControllerType_Home];
    };
    if (!self.isLoginLoading) {
        self.isLoginLoading = YES;
        [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:cancelActionBlock source:self];
        [self performSelector:@selector(changLoginLoading) withObject:nil afterDelay:3.0];
    }
}

-(void)changLoginLoading{
    self.isLoginLoading = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 登陆相关 登录消息

-(void)userDidLoginNotification:(NSNotification*)notification{
    [self userDidLogin:notification.userInfo];
}

-(void)userDidLogoutNotification:(NSNotification*)notification{
    [self userDidLogout:notification.userInfo];
}

-(void)currentSelectBabyChangedNotification:(NSNotification*)notification{
    [self currentSelectBabyChanged:notification.userInfo];
}

-(void)switchToBabyWithBabyId:(NSNumber *)babyId{
    if (babyId == nil) {
        return;
    }
    if ([babyId integerValue] == [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]) {
        return;
    }
    [self.babyHorizontalListView switchToBabyWithBabyId:babyId];
}

-(void)currentSelectBabyChanged:(NSDictionary*)userInfo{
    NSNumber* babyId = [userInfo objectForKey:EHSELEC_BABY_ID_DATA];
    [self switchToBabyWithBabyId:babyId];
}

-(void)userDidLogin:(NSDictionary*)userInfo{
    
}

-(void)userDidLogout:(NSDictionary*)userInfo{
    
}

#pragma mark- KSTabBarViewControllerProtocol

-(BOOL)shouldSelectViewController:(UIViewController *)viewController{
    // chech login
    if (self.needLogin) {
        return [self checkLogin];
    }
    return YES;
}

// 点击选中
-(void)didSelectViewController:(UIViewController*)viewController{
    
}

// 重复点击选中
-(void)didSelectSameViewController:(UIViewController *)viewController{
    
}

-(CGRect)selectViewControllerRectForBounds:(CGRect)bounds{
    return bounds;
}

@end
