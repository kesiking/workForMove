//
//  EHHealthyBasicViewController.m
//  eHome
//
//  Created by 钱秀娟 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicViewController.h"
#import "EHGetBabyListRsp.h"
#import "Masonry.h"
#import "EHBabyHorizontalBasicListView.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "iCarousel.h"

@interface EHHealthyBasicViewController ()

@end

@implementation EHHealthyBasicViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.healthyView=[[EHHealthyBasicView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    [self.view addSubview:self.healthyView];
    [self.healthyView.babyHeadBtn addTarget:self action:@selector(babyHeadBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self.healthyView.calendarBtn addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取当前宝贝的babyId,设置宝贝头像以及宝贝昵称
    EHGetBabyListRsp *babyListRsp=[[EHBabyListDataCenter sharedCenter]currentBabyUserInfo];
    self.babyId=babyListRsp.babyId;
    if (self.babyId) {
        self.healthyView.babyHeadBtn.hidden=NO;
        self.healthyView.babyNameLabel.hidden=NO;
        self.healthyView.step.hidden=NO;
        self.healthyView.fourthView.hidden=NO;
        [self setHeadImageUrl:babyListRsp.babyHeadImage withSex:[babyListRsp.babySex integerValue]];
        self.healthyView.babyNameLabel.text=babyListRsp.babyNickName;
        self.startUserDay=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    }
    else{
        self.healthyView.babyHeadBtn.hidden=YES;
        self.healthyView.babyNameLabel.hidden=YES;
        self.healthyView.step.hidden=YES;
        self.healthyView.finishSteps.text=@"暂无宝贝";
        self.healthyView.distanceLabel.text=@"-千米";
        self.healthyView.energyLabel.text=@"-卡";
        self.healthyView.ratioLabel.text=@"-%";
        [self.healthyView.distanceChart updateChartByCurrent:@0];
        [self.healthyView.energyChart updateChartByCurrent:@0];
        [self.healthyView.ratioChart updateChartByCurrent:@0];
        self.healthyView.thirdView.hidden=YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮点击方法
- (void)babyHeadBtnClick
{
//    [self configBabyHeadClick:self.healthyView];
}

//代理方法
- (void)configDateBtnClick:(EHHealthyBasicView *)healthyView{
    
    
}

- (void)dateBtnClick
{
    if ([self.delegate respondsToSelector:@selector(configDateBtnClick:)]) {
        [self.delegate configDateBtnClick:self.healthyView];
    }
}

#pragma mark - 私有方法
- (void)reloadDataWhenDayOrWeekChanged
{
        if ([self.delegate respondsToSelector:@selector(reloadDataWhenViewScroll)]) {
            [self.delegate reloadDataWhenViewScroll];
        }
}
- (void)reloadDataWhenCurrentBabyChangedWithBabyInfo:(EHGetBabyListRsp *)babyInfo
{
    EHGetBabyListRsp *babyListRsp=babyInfo;
    self.babyId=babyListRsp.babyId;
    if (self.babyId) {
        [self setHeadImageUrl:babyListRsp.babyHeadImage withSex:[babyListRsp.babySex integerValue]];
        if ([self.delegate respondsToSelector:@selector(reloadDataWhenHeadBtnClick)]) {
            [self.delegate reloadDataWhenHeadBtnClick];
        }
    }
}
-(void)setHeadImageUrl:(NSString*)imageUrl withSex:(NSUInteger)sex{
    //试用宝贝头像有数据
    if (sex == EHBabySexType_girl) {
        [self.healthyView.babyHeadBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]];
    }else{
        [self.healthyView.babyHeadBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]];
    }

}
#pragma mark - 子类实现方法
- (void)updateUIWithInit
{
    self.healthyView.finishSteps.text=@"0";
    self.healthyView.distanceLabel.text=@"0公里";
    self.healthyView.energyLabel.text=@"0卡";
    self.healthyView.ratioLabel.text=@"0%";
    [self.healthyView.distanceChart updateChartByCurrent:@0];
    [self.healthyView.energyChart updateChartByCurrent:@0];
    [self.healthyView.ratioChart updateChartByCurrent:@0];
    [self hideErrorView];
    [self hideLoadingView];
}
- (void)updateUIAfterService:(EHHealthyBasicModel *)model withView:(EHHealthyBasicView *)healthyView
{
    //子类实现方法
    
}
@end
