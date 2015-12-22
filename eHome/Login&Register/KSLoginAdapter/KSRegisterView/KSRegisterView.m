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
#import "KSCheckRegisterService.h"

#define account_label_description  @"账户"
#define password_label_description @"登陆密码"

#define text_label_width  (caculateNumber(200.0))
#define text_label_height (caculateNumber(15.0))

@interface KSRegisterView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel                   *registerDescriptionLabel;
@property (nonatomic, strong)      KSCheckRegisterService*                 checkRegister;

@end

@implementation KSRegisterView

-(void)setupView{
    [super setupView];
    self.backgroundColor = RGB(245, 245, 249);
    [self initRegisterViewCtl];
    [self reloadData];
}

-(void)initRegisterViewCtl{
    self.registerViewCtl.text_phoneNum.hidden = NO;
    self.registerViewCtl.text_psw.hidden = NO;
    self.registerViewCtl.btn_next.hidden = NO;
    
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
    self.registerViewCtl.text_phoneNum.aDelegate = self;
    _checkRegister = [KSCheckRegisterService new];

    [self addSubview:self.registerViewCtl];
    
    _registerDescriptionLabel = [UILabel new];
    _registerDescriptionLabel.font = EHFont5;
    _registerDescriptionLabel.textColor = EHCor3;
    _registerDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    _registerDescriptionLabel.text = @"密码为6-20位数字、字母或字符的组合";
    _registerDescriptionLabel.frame = CGRectMake(kSpaceX, self.registerViewCtl.text_psw.bottom + 12, self.width - 2*kSpaceX, text_label_height);
    [self addSubview:_registerDescriptionLabel];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    _registerDescriptionLabel.frame = CGRectMake(kSpaceX, self.registerViewCtl.text_psw.bottom + 12, self.width - 2*kSpaceX, text_label_height);
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
#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.checkRegister checkRegisterWithAccountName:textField.text checkRegister:^(BOOL isRegister,NSError* error) {
        if (isRegister) {
            // 已经注册过弹出提示
            [WeAppToast toast:ALREADY_HAS_REGISTER_ACCOUNT_INFO];
        }else{
            return;
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.registerViewCtl.text_phoneNum.textView == textField) {
        if (![EHUtils isEmptyString:string] && (![EHUtils isPureInt:string] || string.length > 11 || range.location > 10)) {
            [WeAppToast toast:@"请输入正确的手机号码"];
            return NO;
        }
    }
    return YES;
}
@end
