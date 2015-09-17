//
//  KSRegisterView.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSRegisterView.h"
#import "KSLoginComponentItem.h"
#import "EHUtils.h"

#define account_label_description  @"账户"
#define password_label_description @"登陆密码"

#define text_label_width  (caculateNumber(200.0))
#define text_label_height (caculateNumber(15.0))

@interface KSRegisterView()

@property (nonatomic, strong) UILabel                   *registerDescriptionLabel;

@end

@implementation KSRegisterView

-(void)setupView{
    [super setupView];
    [self initRegisterViewCtl];
    [self reloadData];
}

-(void)initRegisterViewCtl{
    self.registerViewCtl.text_phoneNum.hidden = NO;
    self.registerViewCtl.text_psw.hidden = NO;
    
    WEAKSELF
    self.registerViewCtl.text_phoneNum.textValueDidChanged = ^(UITextField *textField){
        STRONGSELF
        // check login
        /*
         * 登录按钮有效性验证
         */
        [strongSelf checkNextBtnEnable];
    };
    
    self.registerViewCtl.text_psw.textValueDidChanged = ^(UITextField *textField){
        STRONGSELF
        // check login
        /*
         * 登录按钮有效性验证
         */
        [strongSelf checkNextBtnEnable];
    };
    
    [self addSubview:self.registerViewCtl];
    
    _registerDescriptionLabel = [UILabel new];
    _registerDescriptionLabel.font = [UIFont systemFontOfSize:11];
    _registerDescriptionLabel.textColor = RGB(0xdc, 0xdc, 0xdc);
    _registerDescriptionLabel.textAlignment = NSTextAlignmentRight;
    _registerDescriptionLabel.text = @"请输入6-20位数字或字母";
    _registerDescriptionLabel.frame = CGRectMake(self.width - text_label_width - kSpaceX, self.registerViewCtl.text_psw.bottom + 6, text_label_width, text_label_height);
    [self addSubview:_registerDescriptionLabel];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    _registerDescriptionLabel.frame = CGRectMake(self.width - text_label_width - kSpaceX, self.registerViewCtl.text_psw.bottom + 6, text_label_width, text_label_height);
}

-(void)reloadData{

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - checkAccountNameService  手机是否注册过
-(void)setCheckAccountNameService:(KSLoginService *)checkAccountNameService{
    if (_checkAccountNameService != checkAccountNameService) {
        _checkAccountNameService = nil;
        _checkAccountNameService = checkAccountNameService;
        [self setupCheckAccountNameService];
    }
}

-(KSLoginService *)getCheckAccountNameService{
    if (_checkAccountNameService == nil) {
        _checkAccountNameService = [[KSLoginService alloc] init];
        [self setupCheckAccountNameService];
    }
    return _checkAccountNameService;
}

-(void)setupCheckAccountNameService{
    
    WEAKSELF
    dispatch_block_t completeBlock = ^(){
        STRONGSELF
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if (strongSelf.registerViewCtl.text_phoneNum.text) {
            [params setObject:strongSelf.registerViewCtl.text_phoneNum.text forKey:@"user_phone"];
        }
        if (strongSelf.registerViewCtl.text_psw.text) {
            [params setObject:strongSelf.registerViewCtl.text_psw.text forKey:@"user_password"];
        }
        if (strongSelf.registerActionBlock) {
            [params setObject:strongSelf.registerActionBlock forKey:@"registerActionBlock"];
        }
        if (strongSelf.cancelActionBlock) {
            [params setObject:strongSelf.cancelActionBlock forKey:@"cancelActionBlock"];
        }
        TBOpenURLFromTargetWithNativeParams(internalURL(kValidateCodeAndRegisterPage), strongSelf, nil, params);
    };
    _checkAccountNameService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        [strongSelf hideLoadingView];

        if (service.numberValue && [service.numberValue integerValue] == 0) {
            // 未注册过的则
            [WeAppToast toast:ALREADY_HAS_REGISTER_ACCOUNT_INFO];
            return;
        }
        if(![EHUtils isValidMobile:strongSelf.registerViewCtl.text_phoneNum.text])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }
        if(![EHUtils isValidPassword:strongSelf.registerViewCtl.text_psw.text])
        {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        
        if (completeBlock) {
            completeBlock();
        }
        
    };
    
    _checkAccountNameService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"]?:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO;
        if ([errorInfo isEqualToString:@"Garbage at end."]) {
            if (completeBlock) {
                completeBlock();
            }
            return;
        }
        [WeAppToast toast:errorInfo];
    };
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - registerViewCtl  注册视图
-(void)setRegisterViewCtl:(KSRegisterViewCtl *)registerViewCtl{
    if (_registerViewCtl != registerViewCtl) {
        _registerViewCtl = nil;
        _registerViewCtl = registerViewCtl;
        [self setupRegisterViewCtl];
    }
}

-(KSRegisterViewCtl *)getRegisterViewCtl{
    if (_registerViewCtl == nil) {
        _registerViewCtl = [[KSRegisterViewCtl alloc] initWithFrame:self.bounds];
        [self setupRegisterViewCtl];
    }
    return _registerViewCtl;
}

-(void)setupRegisterViewCtl{
    WEAKSELF
    _registerViewCtl.nextBlock = ^(KSRegisterViewCtl* registerViewCtl){
        STRONGSELF
        if(![EHUtils isValidMobile:registerViewCtl.text_phoneNum.text])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }
        if(![EHUtils isValidPassword:registerViewCtl.text_psw.text])
        {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        
        [strongSelf showLoadingView];
        //先获取验证码，成功后跳转到下一步
        [strongSelf.checkAccountNameService checkAccountName:((KSRegisterViewCtl*)registerViewCtl).text_phoneNum.text];
    };
    
    _registerViewCtl.cancelRegisterBlock = ^(KSRegisterViewCtl* registerViewCtl){
        STRONGSELF
        if (strongSelf.cancelActionBlock) {
            strongSelf.cancelActionBlock();
        }
    };
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [EHUtils isNotEmptyString:self.registerViewCtl.text_phoneNum.text] && [EHUtils isNotEmptyString:self.registerViewCtl.text_psw.text];
    self.registerViewCtl.btn_next.enabled = loginBtnEnable;
}

@end
