//
//  EHHealthyTabbarViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyTabViewController.h"
#import "EHGetBabyListRsp.h"
#import "EHHealthySettingViewController.h"
#import "EHHealthyShareViewController.h"

#import "EHHealthyDayViewController.h"
#import "EHHealthyWeekViewController.h"
#import "Masonry.h"
#import "RMActionController.h"

@interface EHHealthyTabViewController () <UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *healthScrollView;

@property(nonatomic, strong) UIViewController *currentVC;
@property(nonatomic, strong) EHHealthyDayViewController *dayVC;
@property(nonatomic, strong) EHHealthyWeekViewController *weekVC;

@property(nonatomic, strong) EHHealthySettingViewController *settingVC;
@property(nonatomic, strong) UIButton *dayButton;
@property(nonatomic, strong) UIButton *weekButton;
@property(nonatomic, strong) UIView *underlineView;
@property(nonatomic, strong) NSString *authority;
@property(nonatomic, strong) NSNumber *targetSteps;
@property(nonatomic, strong) NSString *babyName;
@property(nonatomic, strong) NSString *babyImage;
@property(nonatomic, strong) NSNumber *babySex;
@property(nonatomic, strong) NSNumber *babyID;

@property(nonatomic, assign) CGPoint previousContentoffset;
@end

@implementation EHHealthyTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建滑动视图
    self.healthScrollView = [[UIScrollView alloc]
                             initWithFrame:CGRectMake(0, 0,
                                                      CGRectGetWidth([UIScreen mainScreen].bounds),
                                                      CGRectGetHeight([UIScreen mainScreen].bounds) -
                                                      64 - 49)];
    self.healthScrollView.contentSize =
    CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 2,
               CGRectGetHeight([UIScreen mainScreen].bounds) - 64 - 49);
    self.healthScrollView.showsHorizontalScrollIndicator = NO;
    self.healthScrollView.showsVerticalScrollIndicator = NO;
    self.healthScrollView.pagingEnabled = YES;
    [self.view addSubview:self.healthScrollView];
    self.healthScrollView.delegate = self;
    self.healthScrollView.clipsToBounds = NO;
    self.healthScrollView.bounces = NO;
    self.currentVC = self.dayVC;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏navigationBar的下分割线
    [self.navigationController.navigationBar
     setBackgroundImage:[[UIImage alloc] init]
     forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self initRightBarButtonItemsWithFlag:[KSAuthenticationCenter isTestAccount]];
    [self.healthScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo(
                              CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds),
                                         CGRectGetHeight([UIScreen mainScreen].bounds) - 64 - 49));
    }];
    self.dayVC.view.frame =
    CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds),
               self.healthScrollView.frame.size.height);
    [self.healthScrollView addSubview:self.dayVC.view];

    
    self.weekVC.view.frame =
    CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0.0,
               CGRectGetWidth([UIScreen mainScreen].bounds),
               self.healthScrollView.frame.size.height);
    [self.healthScrollView addSubview:self.weekVC.view];
    if (self.currentVC == self.dayVC) {
        return;
    }
    self.previousContentoffset = CGPointMake(0, 0);
    [self changeToDayVC];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage= nil;
}
//- (void)viewDidLayoutSubviews {
//  [super viewDidLayoutSubviews];
//
//  //修复iOS7直接崩溃bug
//  [self.view layoutIfNeeded];
//}
//- (void)viewDidAppear:(BOOL)animated {
//  [super viewDidAppear:animated];
//}
#pragma mark - UIScrollViewDelegate
//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    NSInteger page = roundf(scrollView.contentOffset.x /
                            CGRectGetWidth([UIScreen mainScreen].bounds));
    page = MAX(page, 0);
    page = MIN(page, 1);
}

//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.previousContentoffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == self.previousContentoffset.x) {
        EHLogInfo(@"scrollView.contentOffset.x == self.previousContentoffset.x");
        return;
    }
    self.previousContentoffset = scrollView.contentOffset;
    NSInteger page = roundf(scrollView.contentOffset.x /
                            CGRectGetWidth([UIScreen mainScreen].bounds));
    EHLogInfo(@"scroll to page  %ld", page);
    page = MAX(page, 0);
    page = MIN(page, 1);
    
    switch (page) {
        case 0: {
            [self changeToDayVC];
            break;
        }
        case 1: {
            [self changeToWeekVC];
            break;
        }
        default:
            break;
    }
}

-(void)babyHorizontalListViewBabyCliced:(EHGetBabyListRsp*)babyUserInfo{
    if (babyUserInfo.babyId == nil) {
        TBOpenURLFromSourceAndParams(tabbarURL(kEHOMETabHome), self, nil);
        return;
    }
    [self.dayVC reloadDataWhenCurrentBabyChangedWithBabyInfo:babyUserInfo];
    [self.weekVC reloadDataWhenCurrentBabyChangedWithBabyInfo:babyUserInfo];
}
#pragma mark - 私有函数
- (void)changeToDayVC
{
    EHLogInfo(@"change to DayVC");
    self.dayButton.enabled=NO;
    self.weekButton.enabled=NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lineViewFrame=self.underlineView.frame;
//        lineViewFrame.origin.x -= 44;
        lineViewFrame.origin.x = 12;
        self.underlineView.frame=lineViewFrame;
    } completion:^(BOOL finished) {
        self.currentVC = self.dayVC;
        self.dayButton.enabled=YES;
        self.weekButton.enabled=YES;
        [_dayButton setTitleColor:EHCor6 forState:UIControlStateNormal];
        [_weekButton setTitleColor:EHCor5 forState:UIControlStateNormal];
        [self.dayVC reloadDataWhenDayOrWeekChanged];
    }];
    [self.healthScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)changeToWeekVC
{
    EHLogInfo(@"change to WeekVC");
    self.dayButton.enabled=NO;
    self.weekButton.enabled=NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lineViewFrame=self.underlineView.frame;
//        lineViewFrame.origin.x += 44;
        lineViewFrame.origin.x = 56;
        self.underlineView.frame=lineViewFrame;
    } completion:^(BOOL finished) {
        self.currentVC = self.weekVC;
        self.dayButton.enabled=YES;
        self.weekButton.enabled=YES;
        [_weekButton setTitleColor:EHCor6 forState:UIControlStateNormal];
        [_dayButton setTitleColor:EHCor5 forState:UIControlStateNormal];
    }];
    [self.healthScrollView
     setContentOffset:CGPointMake(
                                  CGRectGetWidth([UIScreen mainScreen].bounds), 0)
     animated:YES];
    [self.weekVC reloadDataWhenDayOrWeekChanged];
}
- (void)doMore {
    EHGetBabyListRsp *babyUserInfo =
    [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    _authority = [babyUserInfo authority];
    _targetSteps = [babyUserInfo baby_target_steps];
    _babyName = [babyUserInfo babyNickName];
    _babyImage = [babyUserInfo babyHeadImage];
    _babySex = [babyUserInfo babySex];
    _babyID = [babyUserInfo babyId];
    if ([_authority isEqualToString:@"1"]) {
        [EHPopMenuLIstView
         showMenuViewWithTitleTextArray:@[ @"计步设置", @"健康分享" ]
         menuSelectedBlock:^(NSUInteger index,
                             EHPopMenuModel *selectItem) {
             if (index == 0) {
                 self.settingVC.currentTargetSteps = _targetSteps;
                 [self.navigationController
                  pushViewController:self.settingVC
                  animated:YES];
//                 self.dayVC.previousIndex = -1;
//             
             }
             if (index == 1) {
                 [self presentSharedViewController];
             }
         }];
    } else {
        [EHPopMenuLIstView
         showMenuViewWithTitleTextArray:@[ @"健康分享" ]
         menuSelectedBlock:^(NSUInteger index,
                             EHPopMenuModel *selectItem) {
             [self presentSharedViewController];
         }];
    }
}
- (void) initRightBarButtonItemsWithFlag: (BOOL)isTestAccount
{
    UIView *rightBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [rightBgView addSubview:self.dayButton];
    [self.dayButton addTarget:self
                       action:@selector(onClickButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [rightBgView addSubview:self.weekButton];
    [self.weekButton addTarget:self
                        action:@selector(onClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    if (_underlineView == nil) {
        self.underlineView= [[UIView alloc]initWithFrame:CGRectMake(12, 28, 20, 3)];
        _underlineView.backgroundColor = EH_cor9;
    }
    [rightBgView addSubview:_underlineView];
    UIBarButtonItem *dayWeekBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBgView];
    if (isTestAccount) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:dayWeekBarButtonItem, nil];
    }else{
        UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"]
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(doMore)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: moreBarButtonItem,dayWeekBarButtonItem, nil];
    }
}
- (void)onClickButton:(UIButton *)sender {
    if ((self.currentVC == _dayVC && sender == self.dayButton) ||
        (self.currentVC == _weekVC && sender == self.weekButton)) {
        EHLogInfo(@"-----> click button invalid");
        return;
    }
    switch ([sender tag]) {
        case 1: {
            self.previousContentoffset = CGPointMake(0, 0);
            [self changeToDayVC];
            break;
        }
        case 2: {
            self.previousContentoffset = CGPointMake(SCREEN_WIDTH, 0);
            [self changeToWeekVC];
            break;
        }
        default:
            break;
    }
}
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController
            newController:(UIViewController *)newController {
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [newController.view
     setFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    [self transitionFromViewController:oldController
                      toViewController:newController
                              duration:0.0
                               options:UIViewAnimationOptionTransitionNone
                            animations:nil
                            completion:^(BOOL finished) {
                                [newController didMoveToParentViewController:self];
                                [oldController willMoveToParentViewController:nil];
                                [oldController removeFromParentViewController];
                                self.currentVC = newController;
                            }];
}
- (void)presentSharedViewController {
    EHHealthyShareViewController *sharedVC =
    [[EHHealthyShareViewController alloc] init];
    sharedVC.sharedBabyId = _babyID;
    sharedVC.sharedBabyName = _babyName;
    sharedVC.sharedHeadImage = _babyImage;
    sharedVC.babySex = _babySex;
    if (self.currentVC == _dayVC) {
        // sharedVC.sharedTargetSteps = self.targetSteps;
        //日期
        sharedVC.sharedDate = self.dayVC.dayVCmodel.date;
        
        NSString *yearString = [self.dayVC.dayVCmodel.date substringToIndex:4];
        NSString *monthString = [self.dayVC.dayVCmodel.date substringWithRange:NSMakeRange(5, 2)];
        NSString *dayString = [self.dayVC.dayVCmodel.date substringWithRange:NSMakeRange(8, 2)];
        if ([monthString characterAtIndex:0]=='0') {
            monthString =[monthString substringFromIndex:1];
        }
        if ([dayString characterAtIndex:0]=='0') {
            dayString =[dayString substringFromIndex:1];
        }
        
        sharedVC.sharedDate = [NSString stringWithFormat:@"%@年%@月%@日运动成绩",yearString,monthString,dayString];

        //大圆圈步数
        sharedVC.finishedSteps.text =
        [NSString stringWithFormat:@"%ld", (long)self.dayVC.dayVCmodel.steps];
        sharedVC.babyTargetSteps.text = [NSString stringWithFormat:@"目标：%ld步",self.dayVC.dayVCmodel.targetSteps];
        //距离
        
        if (self.dayVC.dayVCmodel.mileage == 0) {
            sharedVC.distanceDigitLabel.text = @"0米";
        }else{
            if(self.dayVC.dayVCmodel.mileage < 1000){
                sharedVC.distanceDigitLabel.text =
                [NSString stringWithFormat:@"%ld米", self.dayVC.dayVCmodel.mileage];
            }else{
                sharedVC.distanceDigitLabel.text =
                [NSString stringWithFormat:@"%.3f千米", self.dayVC.dayVCmodel.mileage/1000.0];
            }
            
        }

        //热量
        if (1000*self.dayVC.dayVCmodel.calorie<10000) {
            self.dayVC.dayVCmodel.calorie = self.dayVC.dayVCmodel.calorie*1000;
            sharedVC.energyDigitLabel.text = [NSString
                                              stringWithFormat:@"%ld卡", (long)self.dayVC.dayVCmodel.calorie];
        }else{
            sharedVC.energyDigitLabel.text = [NSString
                                              stringWithFormat:@"%ld千卡", (long)self.dayVC.dayVCmodel.calorie];
        }
        
        //完成
        sharedVC.finishDigitRateLabel.text =
        [NSString stringWithFormat:@"%@%%", self.dayVC.dayVCmodel.percent];
        //鼓励语
        sharedVC.markedWordsLabel.text =
        [NSString stringWithFormat:@"%@", self.dayVC.dayVCmodel.encourage];
        
    } else if (self.currentVC == _weekVC) {
//        _weekVC.showSharePage = YES;
        //日期
//        sharedVC.sharedDate = self.weekVC.selectedWeek;
        NSString *yearString =  _weekVC.healthyView.dateLabel.text;
        sharedVC.sharedDate = [NSString stringWithFormat:@"%@%@运动成绩",yearString,self.weekVC.selectedWeek];
       
        //大圆圈步数
        sharedVC.finishedSteps.text = [NSString
                                       stringWithFormat:@"%ld", (long)self.weekVC.weekVCmodel.steps];
        sharedVC.babyTargetSteps.text = [NSString stringWithFormat:@"目标：%ld步",self.weekVC.weekVCmodel.targetSteps];

        //距离
        if (self.weekVC.weekVCmodel.mileage == 0) {
            sharedVC.distanceDigitLabel.text = @"0米";

        }else{
            if(self.weekVC.weekVCmodel.mileage < 1000){
                sharedVC.distanceDigitLabel.text =
                [NSString stringWithFormat:@"%ld米", self.weekVC.weekVCmodel.mileage];
            }else{
                sharedVC.distanceDigitLabel.text =
                [NSString stringWithFormat:@"%.3f千米", self.weekVC.weekVCmodel.mileage/1000.0];
            }
            
        }
        
        if (1000*self.weekVC.weekVCmodel.calorie<10000) {
            self.weekVC.weekVCmodel.calorie = self.weekVC.weekVCmodel.calorie *1000;
            sharedVC.energyDigitLabel.text =
            [NSString stringWithFormat:@"%ld卡", self.weekVC.weekVCmodel.calorie];
        }else{
            sharedVC.energyDigitLabel.text =[NSString stringWithFormat:@"%ld千卡", self.weekVC.weekVCmodel.calorie];
            
        }
        
  
        //完成
        sharedVC.finishDigitRateLabel.text =
        [NSString stringWithFormat:@"%@%%", self.weekVC.weekVCmodel.percent];
        //鼓励语
        sharedVC.markedWordsLabel.text =
        [NSString stringWithFormat:@"%@", self.weekVC.weekVCmodel.encourage];
        
    }
    sharedVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:sharedVC animated:YES completion:nil];
}

- (UIImage *)screenshotForCroppingRect:(CGRect)croppingRect {
    UIGraphicsBeginImageContextWithOptions(croppingRect.size, NO,
                                           [UIScreen mainScreen].scale);
    // Create a graphics context and translate it the view we want to crop so
    // that even in grabbing (0,0), that origin point now represents the actual
    // cropping origin desired:
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        return nil;
    CGContextTranslateCTM(context, -croppingRect.origin.x,
                          -croppingRect.origin.y);
    
    [self.view layoutIfNeeded];
    [self.view.layer renderInContext:context];
    
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

#pragma mark - 懒加载
- (EHHealthySettingViewController *)settingVC {
    if (!_settingVC) {
        _settingVC = [[EHHealthySettingViewController alloc] init];
    }
    return _settingVC;
}
//- (EHHealthyShareViewController *)sharedVC
//{
//    if (!_sharedVC) {
//        _sharedVC=[[EHHealthyShareViewController alloc]init];
//    }
//    return _sharedVC;
//}

- (EHHealthyDayViewController *)dayVC {
    if (!_dayVC) {
        _dayVC = [[EHHealthyDayViewController alloc] init];
    }
    return _dayVC;
}
- (EHHealthyWeekViewController *)weekVC {
    if (!_weekVC) {
        _weekVC = [[EHHealthyWeekViewController alloc] init];
    }
    return _weekVC;
}
- (UIButton *)dayButton
{
    if (!_dayButton) {
        _dayButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 30)];
        _dayButton.tag = 1;
        [_dayButton setTitle:@"日" forState:UIControlStateNormal];
        [_dayButton setTitleColor:EHCor6 forState:UIControlStateNormal];
        _dayButton.titleLabel.font = EH_font5;
    }
    return _dayButton;
}
- (UIButton *)weekButton
{
    if (!_weekButton) {
        _weekButton = [[UIButton alloc]initWithFrame:CGRectMake(44, 0, 44, 30)];
        _weekButton.tag = 2;
        [_weekButton setTitle:@"周" forState:UIControlStateNormal];
        [_weekButton setTitleColor:EHCor5 forState:UIControlStateNormal];
        _weekButton.titleLabel.font = EH_font5;
    }
    return _weekButton;
}
#pragma mark - KSTabBarViewControllerProtocol
- (BOOL)shouldSelectViewController:(UIViewController *)viewController {
    BOOL hasBabyId =(BOOL)[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyId;
    if ([KSAuthenticationCenter isTestAccount]&&hasBabyId) {
        return YES;
    }else if([KSAuthenticationCenter isTestAccount]&&!hasBabyId){
        [WeAppToast toast:@"暂无试用宝贝，请稍后再试"];
        return NO;
        }
    WEAKSELF
    return [self alertViewCheckBabyIdWithCompleteBlock:^{
        STRONGSELF[strongSelf doBabyAttention];
    }];

}

#pragma mark - 用户没有添加宝贝情况下，宝贝添加引导
- (BOOL)alertViewCheckBabyIdWithCompleteBlock:(dispatch_block_t)completeBlock {
    BOOL hasBabyId =
    (BOOL)[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyId;
    if (!hasBabyId) {
        if (completeBlock) {
            completeBlock();
        }
    }
    return hasBabyId;
}
- (void)doBabyAttention {
    WEAKSELF
    RMAction *babyAttAction =
    [RMAction actionWithTitle:@"绑定宝贝"
                        style:RMActionStyleDefault
                   andHandler:^(RMActionController *controller) {
                       STRONGSELF
                       TBOpenURLFromSourceAndParams(
                                                    internalURL(kEHBabyAtteintion),
                                                    strongSelf.KSNavigationController, nil);
                   }];
    babyAttAction.titleFont = EH_font2;
    RMAction *cancelAction =
    [RMAction actionWithTitle:@"取消"
                        style:RMActionStyleCancel
                   andHandler:^(RMActionController *controller){
                   }];
    cancelAction.titleFont = EH_font2;
    cancelAction.titleColor = EH_cor3;
    RMActionController *actionSheet = [RMActionController
                                       actionControllerWithStyle:RMActionControllerStyleDefault];
    [actionSheet addAction:babyAttAction];
    [actionSheet addAction:cancelAction];
    actionSheet.title = @"当前用户暂无宝贝，是否绑定宝贝？";
    actionSheet.titleFont = EH_font6;
    actionSheet.titleColor = EH_cor5;
    actionSheet.seperatorViewColor = EH_linecor1;
    actionSheet.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    actionSheet.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint =
    [NSLayoutConstraint constraintWithItem:actionSheet.contentView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:0];
    [actionSheet.contentView addConstraint:heightConstraint];
    actionSheet.disableBlurEffects = YES;
    actionSheet.disableBouncingEffects = YES;
    actionSheet.disableMotionEffects = YES;
    [self.KSNavigationController presentViewController:actionSheet
                                              animated:YES
                                            completion:nil];
}
@end
