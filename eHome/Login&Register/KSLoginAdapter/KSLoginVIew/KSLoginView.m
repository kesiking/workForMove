//
//  KSLoginView.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginView.h"
#import "KSLoginKeyChain.h"
#import "KSLoginComponentItem.h"
#import "KSLoginUrlPath.h"
#import "EHUtils.h"

#define account_label_description  @"账户"
#define password_label_description @"登陆密码"

#define text_label_width (caculateNumber(65.0))

@interface KSLoginView()

@property (nonatomic, strong) UIImageView           *loginBackgroundView;
@property (nonatomic, strong) UIImageView           *lineImageView;

@end

@implementation KSLoginView

-(void)setupView{
    [super setupView];
    [self initLoginViewCtl];
    [self configTextView];
    [self reloadData];
}

-(void)initLoginViewCtl{
    
    [self.loginBackgroundView setImage:[UIImage imageNamed:@"bg_login"]];
    [self addSubview:self.loginBackgroundView];
    
    self.loginViewCtl.logo_imgView.hidden = NO;
    self.loginViewCtl.description_logo_imgView.hidden = NO;
    self.loginViewCtl.text_phoneNum.hidden = NO;
    self.loginViewCtl.text_psw.hidden = NO;
    self.loginViewCtl.btn_forgetPwd.hidden = NO;
    self.loginViewCtl.btn_login.hidden = NO;
    self.loginViewCtl.btn_cancel.hidden = NO;
    self.loginViewCtl.btn_register.hidden = NO;
    [self addSubview:self.loginViewCtl];
    
    [self addSubview:self.lineImageView];
    
}

-(void)configTextView{
    
}

-(void)reloadData{
    self.loginViewCtl.text_phoneNum.text = [[KSLoginComponentItem sharedInstance] getAccountName];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.loginViewCtl.text_phoneNum.textView.leftView setHeight:self.loginViewCtl.text_phoneNum.height];
    [self.loginViewCtl.text_psw.textView.leftView setHeight:self.loginViewCtl.text_psw.height];
    [self.lineImageView setOrigin:CGPointMake(self.lineImageView.origin.x, self.loginViewCtl.text_phoneNum.bottom - 1)];
}

-(UIImageView *)loginBackgroundView{
    if (_loginBackgroundView == nil) {
        _loginBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _loginBackgroundView;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.loginViewCtl.text_phoneNum.bottom - 1, self.width - 20 * 2, 1)];
        [_lineImageView setImage:[UIImage imageNamed:@"login_textfield_seprateline"]];
    }
    return _lineImageView;
}

-(void)setService:(KSLoginService *)service{
    if (_service != service) {
        _service = nil;
        _service = service;
        [self setupService];
    }
}

-(KSLoginService *)getService{
    if (_service == nil) {
        _service = [[KSLoginService alloc] init];
        [self setupService];
    }
    return _service;
}

-(void)setupService{
    WEAKSELF
    _service.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        [strongSelf hideLoadingView];
        if (strongSelf.loginActionBlock) {
            strongSelf.loginActionBlock(YES);
        }
    };
    
    _service.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"]?:LOGIN_FAIL_INFO;
        [WeAppToast toast:errorInfo];
    };
}

-(void)setLoginViewCtl:(KSLoginViewCtl *)loginViewCtl{
    if (_loginViewCtl != loginViewCtl) {
        _loginViewCtl = nil;
        _loginViewCtl = loginViewCtl;
        [self setupLoginViewCtl];
    }
}

-(KSLoginViewCtl *)getLoginViewCtl{
    if (_loginViewCtl == nil) {
        _loginViewCtl = [[KSLoginViewCtl alloc] initWithFrame:self.bounds];
        [self setupLoginViewCtl];
    }
    return _loginViewCtl;
}

-(void)setupLoginViewCtl{
    WEAKSELF
    _loginViewCtl.loginBlock = ^(KSLoginViewCtl* loginViewCtl){
        STRONGSELF
        if(![EHUtils isValidMobile:loginViewCtl.text_phoneNum.text])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }else if(![EHUtils isValidPassword:loginViewCtl.text_psw.text])
        {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        
        [strongSelf showLoadingView];
        
        [strongSelf.service loginWithAccountName:loginViewCtl.text_phoneNum.text password:loginViewCtl.text_psw.text];
    };
    
    _loginViewCtl.cancelLoginBlock = ^(KSLoginViewCtl* loginViewCtl){
        STRONGSELF
        if (strongSelf.cancelActionBlock) {
            strongSelf.cancelActionBlock();
        }
    };
    
    _loginViewCtl.registerBlock = ^(KSLoginViewCtl* loginViewCtl){
        STRONGSELF
        TBOpenURLFromSourceAndParams(internalURL(kRegisterView), strongSelf, nil);
    };
    
    _loginViewCtl.resetPwdBlock = ^(KSLoginViewCtl* loginViewCtl){
        STRONGSELF
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if (strongSelf.loginViewCtl.text_phoneNum.text) {
            [params setObject:strongSelf.loginViewCtl.text_phoneNum.text forKey:@"user_phone"];
        }
        TBOpenURLFromTargetWithNativeParams(internalURL(kResetPwdPage), strongSelf, nil ,params);
    };
}

@end
