//
//  KSModifyPasswordView.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSModifyPasswordView.h"
#import "EHUtils.h"

@interface KSModifyPasswordView()

@property (nonatomic,strong) UILabel*           resetDescriptionLabel;

@end

@implementation KSModifyPasswordView

-(void)setupView{
    [super setupView];
    [self initResetViewCtl];
    [self reloadData];
}

-(void)initResetViewCtl{
    self.resetViewCtl.text_oldPwd.hidden = NO;
//    self.resetViewCtl.text_renewPwd.hidden = NO;
    self.resetViewCtl.text_newPwd.hidden = NO;
//    self.resetViewCtl.btn_done.hidden = NO;
    WEAKSELF
    self.resetViewCtl.text_oldPwd.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
    self.resetViewCtl.text_newPwd.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
    
    [self addSubview:self.resetViewCtl];
    
    _resetDescriptionLabel = [UILabel new];
    _resetDescriptionLabel.font = [UIFont systemFontOfSize:11];
    _resetDescriptionLabel.textColor = RGB(0xdc, 0xdc, 0xdc);
    _resetDescriptionLabel.textAlignment = NSTextAlignmentRight;
    _resetDescriptionLabel.text = @"请输入6-20位数字或字母";
    _resetDescriptionLabel.frame = CGRectMake(self.width - 200 - kSpaceX, self.resetViewCtl.text_newPwd.bottom + 6, 200, 20);
    [self addSubview:_resetDescriptionLabel];
}

-(void)reloadData{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _resetDescriptionLabel.frame = CGRectMake(self.width - 200 - kSpaceX, self.resetViewCtl.text_newPwd.bottom + 6, 200, 20);
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
        [WeAppToast toast:MODIFY_PASSWORD_SUCCESS_INFO];
        if (strongSelf.modifyPasswordAction) {
            strongSelf.modifyPasswordAction(YES);
        }
    };
    
    _service.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"]?:MODIFY_PASSWORD_FAIL_INFO;
        [WeAppToast toast:errorInfo];
    };
}

-(void)setResetViewCtl:(KSResetViewCtl *)resetViewCtl{
    if (_resetViewCtl != resetViewCtl) {
        _resetViewCtl = nil;
        _resetViewCtl = resetViewCtl;
        [self setupResetViewCtl];
    }
}

-(KSResetViewCtl *)getResetViewCtl{
    if (_resetViewCtl == nil) {
        _resetViewCtl = [[KSResetViewCtl alloc] initWithFrame:self.bounds];
        [self setupResetViewCtl];
    }
    return _resetViewCtl;
}

-(void)setupResetViewCtl{
    WEAKSELF
    
    _resetViewCtl.nextStepBlock = ^(KSResetViewCtl* resetViewCtl){
        STRONGSELF
        //判断逻辑待完善
        if(![EHUtils isValidMobile:strongSelf.user_phone])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }
        if (![EHUtils isValidPassword:resetViewCtl.text_oldPwd.text]) {
            [WeAppToast toast:LOGIN_INPUT_OLD_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        NSString* pwd = [[KSLoginComponentItem sharedInstance] getPassword];
        if (![pwd isEqualToString:resetViewCtl.text_oldPwd.text]) {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNCOLLECT_INFO];
            return;
        }
        if (![EHUtils isValidPassword:resetViewCtl.text_newPwd.text]) {
            [WeAppToast toast:LOGIN_INPUT_NEW_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        if([resetViewCtl.text_oldPwd.text isEqualToString:resetViewCtl.text_newPwd.text]){
            [WeAppToast toast:@"新密码与原密码不能相同哦"];
            return;
        }
        /*
         * 去除确认密码
        if (![EHUtils isValidPassword:resetViewCtl.text_renewPwd.text]) {
            [WeAppToast toast:@"请输入正确的确认密码"];
            return;
        }
        if(![resetViewCtl.text_renewPwd.text isEqualToString:resetViewCtl.text_newPwd.text]){
            [WeAppToast toast:@"确认密码与新密码不相符"];
            return;
        }
         */
        
        [strongSelf.service modifyPasswordWithAccountName:strongSelf.user_phone oldPassword:resetViewCtl.text_oldPwd.text newPassword:resetViewCtl.text_newPwd.text];
    };
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [EHUtils isNotEmptyString:self.resetViewCtl.text_oldPwd.text] && [EHUtils isNotEmptyString:self.resetViewCtl.text_newPwd.text];
    self.resetViewCtl.btn_nextStep.enabled = loginBtnEnable;
}

@end
