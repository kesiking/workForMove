//
//  KSMainViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSViewController.h"
#import "EHTabBarViewController.h"
#import "KSTabBarViewControllerProtocol.h"
#import "EHHomeNavBarTItleView.h"
#import "EHHomeNavBarRightView.h"
#import "EHHomeBabyHorizontalListView.h"

@interface KSTabBasicViewController : KSViewController<KSTabBarViewControllerProtocol>

@property(nonatomic,assign) BOOL                 needLogin;

@property(nonatomic,strong) UIBarButtonItem     *leftBarButtonItem;

@property(nonatomic,strong) UIView              *titleView;

@property(nonatomic,strong) UIBarButtonItem     *rightBarButtonItem;

/*!
 *  @brief  view层
 */
// 顶部nav bar titleView、rightView
@property (nonatomic, strong) EHHomeNavBarTItleView        *navBarTitleView;

@property (nonatomic, strong) EHHomeNavBarRightView        *navBarRightView;

// 下拉宝贝列表
@property (nonatomic, strong) EHHomeBabyHorizontalListView *babyHorizontalListView;

-(void)navBarTitleViewDidSelect:(EHHomeNavBarTItleView*)navBarTitleView;

-(void)navBarRightViewDidSelect:(EHHomeNavBarRightView*)navBarRightView;

-(void)babyHorizontalListViewBabyCliced:(EHGetBabyListRsp*)babyUserInfo;

-(void)setBabyHorizontalListViewShow:(BOOL)show;

-(BOOL)checkLogin;

-(void)alertCheckLoginWithCompleteBlock:(dispatch_block_t)completeBlock;

-(void)doLogin;

-(void)currentSelectBabyChanged:(NSDictionary*)userInfo;

-(void)userDidLogin:(NSDictionary*)userInfo;

-(void)userDidLogout:(NSDictionary*)userInfo;

@end