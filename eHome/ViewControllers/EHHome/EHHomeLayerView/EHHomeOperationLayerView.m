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
    [_historyListBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_footprint_n"] forState:UIControlStateNormal];
    [_historyListBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_footprint_p"] forState:UIControlStateHighlighted];
    [_historyListBtn addTarget:self action:@selector(historyListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_historyListBtn];
    
    _fencingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _historyListBtn.bottom + button_border, self.width, self.width)];
    [_fencingBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_crawl_n"] forState:UIControlStateNormal];
    [_fencingBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_crawl_p"] forState:UIControlStateHighlighted];
    [_fencingBtn addTarget:self action:@selector(fencingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fencingBtn];
    
    CGRect rect = _fencingBtn.bounds;
    rect.origin.y = _fencingBtn.bottom + button_border;
    
//    _chatBtn = [[UIButton alloc] initWithFrame:rect];
//    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_voice_n"] forState:UIControlStateNormal];
//    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_voice_p"] forState:UIControlStateHighlighted];
//    [_chatBtn addTarget:self action:@selector(chatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_chatBtn];
//    
//    rect = _chatBtn.bounds;
//    rect.origin.y = _chatBtn.bottom + button_border;
//    
//    _phoneBtn = [[UIButton alloc] initWithFrame:rect];
//    [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_phone_n"] forState:UIControlStateNormal];
//    [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_phone_p"] forState:UIControlStateHighlighted];
//    [_phoneBtn addTarget:self action:@selector(phoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_phoneBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _historyListBtn.frame = CGRectMake(0, self.height - self.width * 2 - button_border, self.width, self.width);
    _fencingBtn.frame = CGRectMake(0, _historyListBtn.bottom + button_border, self.width, self.width);
    
//    if (!_phoneBtn.hidden) {
//        _historyListBtn.frame = CGRectMake(0, 0, self.width, self.width);
//        _fencingBtn.frame = CGRectMake(0, _historyListBtn.bottom + button_border, self.width, self.width);
//        _chatBtn.frame = CGRectMake(0, _fencingBtn.bottom + button_border, self.width, self.width);
//
//        CGRect rect = _chatBtn.bounds;
//        rect.origin.y = _chatBtn.bottom + button_border;
//        
//        _phoneBtn.frame = rect;
//    }else{
//        _historyListBtn.frame = CGRectMake(0, self.height - self.width * 3 - 2 * button_border, self.width, self.width);
//        _fencingBtn.frame = CGRectMake(0, _historyListBtn.bottom + button_border, self.width, self.width);
//        _chatBtn.frame = CGRectMake(0, _fencingBtn.bottom + button_border, self.width, self.width);
//    }
}

-(void)setBabyUserInfo:(EHGetBabyListRsp *)babyUserInfo{
    _babyUserInfo = babyUserInfo;
    if (babyUserInfo == nil) {
        //_phoneBtn.hidden = YES;
        _fencingBtn.hidden = YES;
        _historyListBtn.hidden = YES;
        //_chatBtn.hidden = YES;
    }else{
        //_phoneBtn.hidden = YES;
        _fencingBtn.hidden = NO;
        _historyListBtn.hidden = NO;
        //_chatBtn.hidden = YES;
    }
//    if ([babyUserInfo isBabyInFamilyPhoneNumbers]) {
//        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_phone_n"] forState:UIControlStateNormal];
//        
//    }else{
//        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_phone_d"] forState:UIControlStateNormal];
//        
//    }
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
    //EHOMEIOS-359 试用账号，禁止进入安全围栏
//    if (![self checkLoginWithCompleteBlock:nil]) {
//        return;
//    }
    // 跳转到电子围栏
    if (self.babyUserInfo && self.babyUserInfo.babyId > 0) {
//        TBOpenURLFromSourceAndParams(internalURL(@"EHGeofenceListViewController"), self, @{@"babyId":[NSString stringWithFormat:@"%@",self.babyUserInfo.babyId]});
        EHGeofenceListViewController *glvc = [[EHGeofenceListViewController alloc]init];
        glvc.babyUser = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
        [self.viewController.navigationController pushViewController:glvc animated:YES];
    }
}

//-(void)phoneButtonClicked:(id)sender{
//    if (![self checkLoginWithCompleteBlock:nil]) {
//        return;
//    }
//    // 打电话
//    if (self.babyUserInfo
//        && self.babyUserInfo.devicePhoneNumber
//        && [self.babyUserInfo.devicePhoneNumber isKindOfClass:[NSString class]]
//        && [EHUtils isValidMobile:self.babyUserInfo.devicePhoneNumber])
//    {
//        if ([self.babyUserInfo isBabyInFamilyPhoneNumbers]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.babyUserInfo.devicePhoneNumber]]];
//        }
//        else
//        {
//            [WeAppToast toast:@"您的账号不在宝贝的亲情电话列表内，请联系管理员获取通话权限"];
//        }
//        
//    }else{
//        [WeAppToast toast:@"宝贝手表不在线，请检查手表或sim卡"];
//    }
//}

//-(void)chatButtonClicked:(id)sender{
//    if (![self checkLoginWithCompleteBlock:nil]) {
//        return;
//    }
//    // 聊天
//    if (self.babyUserInfo) {
//        TBOpenURLFromSourceAndParams(internalURL(@"EHBabySingleChatMessageViewController"), self, @{@"babyId":[NSString stringWithFormat:@"%@",self.babyUserInfo.babyId]});
//    }else{
//        [WeAppToast toast:@"宝贝手表不在线，请检查手表或sim卡"];
//    }
//}

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
