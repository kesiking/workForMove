//
//  EHHomeOperationLayerView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHomeOperationLayerView.h"
#import "EHGeofenceListViewController.h"
#import "EHUtils.h"

#define button_border (20.0)

@implementation EHHomeOperationLayerView

-(void)setupView{
    [super setupView];
    [self initLayerButton];
    self.backgroundColor = [UIColor clearColor];
}

-(void)initLayerButton{
    _historyListBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [_historyListBtn setBackgroundImage:[UIImage imageNamed:@"ico_footpoint_normal"] forState:UIControlStateNormal];
    [_historyListBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_footprint_p"] forState:UIControlStateHighlighted];
    [_historyListBtn addTarget:self action:@selector(historyListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_historyListBtn];
    
    _fencingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _historyListBtn.bottom + button_border, self.width, self.width)];
    [_fencingBtn setBackgroundImage:[UIImage imageNamed:@"ico_crawl_normal"] forState:UIControlStateNormal];
    [_fencingBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_crawl_p"] forState:UIControlStateHighlighted];
    [_fencingBtn addTarget:self action:@selector(fencingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fencingBtn];
    
    CGRect rect = _fencingBtn.bounds;
    rect.origin.y = _fencingBtn.bottom + button_border;
    
    _phoneBtn = [[UIButton alloc] initWithFrame:rect];
    [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"ico_phone_normal"] forState:UIControlStateNormal];
    [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_phone_p"] forState:UIControlStateHighlighted];
    [_phoneBtn addTarget:self action:@selector(phoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_phoneBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!_phoneBtn.hidden) {
        _historyListBtn.frame = CGRectMake(0, 0, self.width, self.width);
        _fencingBtn.frame = CGRectMake(0, _historyListBtn.bottom + button_border, self.width, self.width);
        
        CGRect rect = _fencingBtn.bounds;
        rect.origin.y = _fencingBtn.bottom + button_border;
        
        _phoneBtn.frame = rect;
    }else{
        _historyListBtn.frame = CGRectMake(0, self.height - self.width * 2 - button_border, self.width, self.width);
        _fencingBtn.frame = CGRectMake(0, self.height - self.width, self.width, self.width);
    }
}

-(void)setBabyUserInfo:(EHGetBabyListRsp *)babyUserInfo{
    _babyUserInfo = babyUserInfo;
    if (babyUserInfo == nil) {
        _fencingBtn.hidden = YES;
        _historyListBtn.hidden = YES;
    }else{
        _fencingBtn.hidden = NO;
        _historyListBtn.hidden = NO;
    }
    if ([babyUserInfo isBabyInFamilyPhoneNumbers]) {
        _phoneBtn.hidden = NO;
    }else{
        _phoneBtn.hidden = YES;
    }
    [self setNeedsLayout];
}

-(void)historyListButtonClicked:(id)sender{
    // 跳转到轨迹列表
    if (self.babyUserInfo && self.babyUserInfo.babyId > 0) {
        if (self.historyTraceListBtnClickedBlock) {
            self.historyTraceListBtnClickedBlock(self.historyListBtn);
        }
    }
}

-(void)fencingButtonClicked:(id)sender{
    // 跳转到电子围栏
    if (self.babyUserInfo && self.babyUserInfo.babyId > 0) {
//        TBOpenURLFromSourceAndParams(internalURL(@"EHGeofenceListViewController"), self, @{@"babyId":[NSString stringWithFormat:@"%@",self.babyUserInfo.babyId]});
        EHGeofenceListViewController *glvc = [[EHGeofenceListViewController alloc]init];
        glvc.babyUser = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
        [self.viewController.navigationController pushViewController:glvc animated:YES];
    }
}

-(void)phoneButtonClicked:(id)sender{
    if (![self checkLoginWithCompleteBlock:nil]) {
        return;
    }
    TBOpenURLFromSourceAndParams(internalURL(@"EHBabySingleChatMessageViewController"), self, @{@"babyId":[NSString stringWithFormat:@"%@",self.babyUserInfo.babyId]});
    // 打电话
    if (self.babyUserInfo
        && self.babyUserInfo.devicePhoneNumber
        && [self.babyUserInfo.devicePhoneNumber isKindOfClass:[NSString class]]
        && [EHUtils isValidMobile:self.babyUserInfo.devicePhoneNumber]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.babyUserInfo.devicePhoneNumber]]];
    }else{
        [WeAppToast toast:@"宝贝未绑定号码"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 登陆相关 检查是否登陆

-(BOOL)checkLoginWithCompleteBlock:(dispatch_block_t)block{
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (!isLogin) {
        [self doLoginWithCompleteBlock:block];
    }else if(block){
        block();
    }
    return isLogin;
}

-(void)doLoginWithCompleteBlock:(dispatch_block_t)block{
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        // 如果登陆成功就跳转到当前
        if (block) {
            block();
        };
    };
    [[KSAuthenticationCenter sharedCenter] authenticateWithAlertViewMessage:LOGIN_ALERTVIEW_MESSAGE/*@"拨打电话需要登陆账号，是否登陆已有账号？"*/ LoginActionBlock:loginActionBlock cancelActionBlock:nil source:self];
}

@end
