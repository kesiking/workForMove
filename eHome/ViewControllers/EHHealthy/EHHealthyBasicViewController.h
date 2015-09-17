//
//  EHHealthyBasicViewController.h
//  eHome
//
//  Created by 钱秀娟 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHHealthyBasicModel.h"
#import "EHHealthyBasicView.h"

@protocol EHHealthyDelegate <NSObject>
@required
- (void)loadUIWhenAppear:(EHHealthyBasicView *)healthyView;
- (void)configDateBtnClick:(EHHealthyBasicView *)healthyView;
//点击左上角切换当前宝贝，调用的delegate方法
- (void)reloadDataWhenHeadBtnClick;
//点击日，周按钮或滑动页面，调用的delegate方法
- (void)reloadDataWhenViewScroll;
@end




@interface EHHealthyBasicViewController : KSViewController

@property(nonatomic,weak) id <EHHealthyDelegate> delegate;

@property(nonatomic,strong)NSNumber *babyId;
//
@property(nonatomic,strong) EHHealthyBasicView *healthyView;
@property(nonatomic,strong)NSDate *startUserDay;

//日期滚动条视图
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger previousIndex;
//当天没有数据时，页面更新操作
- (void)updateUIWithInit;
//当天有数据，页面更新操作
- (void)updateUIAfterService:(EHHealthyBasicModel *)model withView:(EHHealthyBasicView *)healthyView;
//点击导航栏日，周按钮或者直接滑动页面调用方法
- (void)reloadDataWhenDayOrWeekChanged;
- (void)reloadDataWhenCurrentBabyChangedWithBabyInfo:(EHGetBabyListRsp *)babyInfo;
@end


