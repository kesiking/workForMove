//
//  EHMessageInfoViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageInfoViewController.h"
#import "EHMessageInfoListView.h"
#import "EHMessageBabyHorizontalListView.h"
#import "EHHomeNavBarTItleView.h"


typedef NS_ENUM(NSInteger, EHMessageInfoType) {
    EHMessageInfoType_baby = 1,       // 宝贝消息
    EHMessageInfoType_system,        // 系统消息
};
@interface EHMessageInfoViewController ()

/*!
 *  @brief  view层
 */
// 顶部nav bar titleView
@property (nonatomic, strong) EHHomeNavBarTItleView       *navBarTitleView;
// 宝贝消息列表 messageInfoListView
@property (nonatomic, strong) EHMessageInfoListView       *messageInfoListView;
// 系统消息列表 systemMsgInfoListView
@property (nonatomic, strong) EHMessageInfoListView       *systemMsgInfoListView;
// 下拉宝贝列表
@property (nonatomic, strong) EHMessageBabyHorizontalListView *babyHorizontalListView;
// 宝贝消息和系统消息按钮
@property (nonatomic, strong) UIView *navBtnsView;

// 判断是否系统消息，用于不同消息的跳转
@property (nonatomic, assign) BOOL isSystemMessageType;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIButton *babyMsgBtn;
@property (nonatomic, strong) UIButton *systemMsgBtn;
@property (nonatomic, strong) EHMessageInfoListView *currentView;
/*!
 *  @brief  数据层
 */
@property (nonatomic, strong) NSArray*                      babyListArray;

@end

@implementation EHMessageInfoViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.babyListArray = [nativeParams objectForKey:@"babyListArray"];
        _isSystemMessageType = [[nativeParams objectForKey:@"systemMessageType"] boolValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMessageNavBarViews];
    //[self.view setBackgroundColor:RGB(0xf0, 0xf0, 0xf0)];
//    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(59.5, 0, 1, self.view.height)];
//    backgroundView.image = [UIImage imageNamed:@"line_messagelist_longstring"];
//    [self.view addSubview:backgroundView];
    // Do any additional setup after loading the view.
    [self.view setClipsToBounds:YES];
    [self.view addSubview:self.messageInfoListView];
    [self.view addSubview:self.systemMsgInfoListView];
    
    self.currentView = _messageInfoListView;
    [self.view addSubview:self.navBtnsView];
    
    UISwipeGestureRecognizer *leftRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftGestureRecognize)];
    leftRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.messageInfoListView addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightGestureRecognize)];
    rightRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
    [self.systemMsgInfoListView addGestureRecognizer:rightRecognizer];
    //[self.view addSubview:self.babyHorizontalListView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isSystemMessageType) {
        [self animationForSystemMsgInfoViewWithDuration:0.0];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initMessageNavBarViews{
    self.navigationItem.title = @"全部消息";
//    self.navigationItem.titleView = self.navBarTitleView;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[[UIImage alloc]init];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  navBtnsView
-(UIView *)navBtnsView{
    if (_navBtnsView == nil) {
        _navBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32)];
        _navBtnsView.backgroundColor = UILOGINNAVIGATIONBAR_COLOR;
        
        _babyMsgBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _navBtnsView.width/2, _navBtnsView.height)];
        _babyMsgBtn.tag=1001;
        [_babyMsgBtn setTitle:@"宝贝消息" forState:UIControlStateNormal];
        [_babyMsgBtn setTitleColor:EH_cor9 forState:UIControlStateNormal];
        _babyMsgBtn.titleLabel.font=EH_font4;
        [_babyMsgBtn addTarget:self action:@selector(msgBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _systemMsgBtn=[[UIButton alloc]initWithFrame:CGRectMake(_navBtnsView.width/2, 0, _navBtnsView.width/2, _navBtnsView.height)];
        _systemMsgBtn.tag=1002;
        [_systemMsgBtn setTitle:@"系统消息" forState:UIControlStateNormal];
        [_systemMsgBtn setTitleColor:EH_cor4 forState:UIControlStateNormal];
        _systemMsgBtn.titleLabel.font=EH_font4;
        [_systemMsgBtn addTarget:self action:@selector(msgBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *separateLineView=[[UIView alloc]initWithFrame:CGRectMake(0, _navBtnsView.height-1, _navBtnsView.width, 1)];
        separateLineView.backgroundColor=EH_cor13;
        
        
        _lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, _navBtnsView.height-2, _navBtnsView.width/2, 2)];
        _lineImageView.backgroundColor=EH_cor9;
        
        [_navBtnsView addSubview:_babyMsgBtn];
        [_navBtnsView addSubview:_systemMsgBtn];
        [_navBtnsView addSubview:separateLineView];
        [_navBtnsView addSubview:_lineImageView];
        
    }
    return _navBtnsView;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  mapview、navBarTItleView
-(EHHomeNavBarTItleView *)navBarTitleView{
    if (_navBarTitleView == nil) {
        _navBarTitleView = [[EHHomeNavBarTItleView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        [_navBarTitleView setBtnTitle:@"全部消息"];
        WEAKSELF
        _navBarTitleView.buttonClicedBlock = ^(EHHomeNavBarTItleView* navBarTitleVIew){
            STRONGSELF
            [strongSelf setBabyHorizontalListViewShow:navBarTitleVIew.btnIsSelected];
        };
    }
    return _navBarTitleView;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  messageInfoListView
-(EHMessageInfoListView *)messageInfoListView{
    if (_messageInfoListView == nil) {
        //_messageInfoListView = [[EHMessageInfoListView alloc] initWithFrame:self.view.bounds];
        _messageInfoListView = [[EHMessageInfoListView alloc] initWithFrame:CGRectMake(0, 32, self.view.width, self.view.height-32)];
        _messageInfoListView.message_type=EHMessageInfoType_baby;
    }
    return _messageInfoListView;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  systemMsgInfoListView
-(EHMessageInfoListView *)systemMsgInfoListView{
    if (_systemMsgInfoListView == nil) {
        //_messageInfoListView = [[EHMessageInfoListView alloc] initWithFrame:self.view.bounds];
        _systemMsgInfoListView = [[EHMessageInfoListView alloc] initWithFrame:CGRectMake(self.view.width, 32, self.view.width, self.view.height-32)];
        _systemMsgInfoListView.message_type=EHMessageInfoType_system;
    }
    return _systemMsgInfoListView;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载  babyHorizontalListView（下拉宝贝列表）及动画操作
-(EHMessageBabyHorizontalListView *)babyHorizontalListView{
    if (_babyHorizontalListView == nil) {
        _babyHorizontalListView = [[EHMessageBabyHorizontalListView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        [_babyHorizontalListView setupBabyDataWithDataList:self.babyListArray];
        _babyHorizontalListView.alpha = 0;
        WEAKSELF
        _babyHorizontalListView.babyListViewClickedBlock = ^(EHBabyHorizontalBasicListView* babyListView,NSInteger index, NSInteger preIndex, EHGetBabyListRsp* babyUserInfo){
            STRONGSELF
            if (babyUserInfo && babyUserInfo.babyId > 0) {
                [strongSelf.messageInfoListView refreshDataRequestWithBabyId:[NSString stringWithFormat:@"%@",babyUserInfo.babyId] andMsgType:EHMessageInfoType_baby];
//                [strongSelf.messageInfoListView refreshDataRequestWithBabyId:[NSString stringWithFormat:@"%@",babyUserInfo.babyId]];
                [strongSelf.navBarTitleView setBtnTitle:babyUserInfo.babyName];
            }
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        
        _babyHorizontalListView.selectAllMessageClickedBlock = ^(EHMessageBabyHorizontalListView* babyListView){
            STRONGSELF
            // to do add baby
            [strongSelf.messageInfoListView refreshDataRequestWithBabyId:nil andMsgType:EHMessageInfoType_baby];
//            [strongSelf.messageInfoListView refreshDataRequestWithBabyId:nil];
            [strongSelf.navBarTitleView setBtnTitle:@"全部消息"];
            [strongSelf.navBarTitleView setButtonSelected:YES];
        };
        
    }
    return _babyHorizontalListView;
}
- (void)leftGestureRecognize
{
    [self animationForSystemMsgInfoViewWithDuration:0.5];
}
- (void)rightGestureRecognize
{
    [self animationForBabyMsgInfoView];
}
//宝贝消息、系统消息点击（滑动）方法
- (void)msgBtnsClick:(UIButton *)sender
{
    self.babyMsgBtn.enabled=NO;
    self.systemMsgBtn.enabled=NO;
    if ((sender.tag==1001&&self.currentView==self.messageInfoListView)||(sender.tag==1002&&self.currentView==self.systemMsgInfoListView)) {
        self.babyMsgBtn.enabled=YES;
        self.systemMsgBtn.enabled=YES;
        return;
    }else if (sender.tag==1001){
        [self animationForBabyMsgInfoView];
        
    }else{
        [self animationForSystemMsgInfoViewWithDuration:0.5];
    }
}
- (void)animationForBabyMsgInfoView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect babyMsgFrame=self.messageInfoListView.frame;
        babyMsgFrame.origin.x +=self.view.width;
        self.messageInfoListView.frame=babyMsgFrame;
        
        CGRect systemMsgFrame=self.systemMsgInfoListView.frame;
        systemMsgFrame.origin.x +=self.view.width;
        self.systemMsgInfoListView.frame=systemMsgFrame;
        
        CGRect lineImageViewFrame=self.lineImageView.frame;
        lineImageViewFrame.origin.x -=self.view.width/2;
        self.lineImageView.frame=lineImageViewFrame;
    } completion:^(BOOL finished) {
        self.currentView=self.messageInfoListView;
        self.babyMsgBtn.enabled=YES;
        self.systemMsgBtn.enabled=YES;
        [_babyMsgBtn setTitleColor:EH_cor9 forState:UIControlStateNormal];
        [_systemMsgBtn setTitleColor:EH_cor4 forState:UIControlStateNormal];
    }];
}
- (void)animationForSystemMsgInfoViewWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        CGRect babyMsgFrame=self.messageInfoListView.frame;
        babyMsgFrame.origin.x -=self.view.width;
        self.messageInfoListView.frame=babyMsgFrame;
        
        CGRect systemMsgFrame=self.systemMsgInfoListView.frame;
        systemMsgFrame.origin.x -=self.view.width;
        self.systemMsgInfoListView.frame=systemMsgFrame;
        
        CGRect lineImageViewFrame=self.lineImageView.frame;
        lineImageViewFrame.origin.x +=self.view.width/2;
        self.lineImageView.frame=lineImageViewFrame;
    } completion:^(BOOL finished) {
        self.currentView=self.systemMsgInfoListView;
        self.babyMsgBtn.enabled=YES;
        self.systemMsgBtn.enabled=YES;
        [_babyMsgBtn setTitleColor:EH_cor4 forState:UIControlStateNormal];
        [_systemMsgBtn setTitleColor:EH_cor9 forState:UIControlStateNormal];
    }];
}
-(void)setBabyHorizontalListViewShow:(BOOL)show{
    CGRect rect = self.babyHorizontalListView.frame;
    if (show) {
        rect.origin.y = self.view.bounds.origin.y;
    }else{
        rect.origin.y = self.view.bounds.origin.y - rect.size.height;
    }
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [self.babyHorizontalListView setFrame:rect];
        self.babyHorizontalListView.alpha = (NSUInteger)(show?1:0);
    } completion:nil];
}

@end
