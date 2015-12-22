//
//  KSLoginService.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginService.h"
#import "KSLoginComponentItem.h"

@interface KSLoginService()

@property (nonatomic, strong) NSString          *accountName;

@property (nonatomic, strong) NSString          *password;

@end

@implementation KSLoginService

-(void)setupService{
    [super setupService];
}

-(void)loginWithAccountName:(NSString*)accountName password:(NSString*)password{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil || password == nil) {
        return;
    }
    self.accountName = accountName;
    self.password = password;
    [self setItemClass:[KSLoginComponentItem class]];
    [self loadItemWithAPIName:login_api_name params:@{@"user_phone":self.accountName, @"user_password":[EHUtils tripleDES:self.password encryptOrDecrypt:kCCEncrypt]} version:nil];
}

-(void)logoutWithAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil) {
        return;
    }
    [self loadItemWithAPIName:logout_api_name params:@{@"user_phone":accountName} version:nil];
}

-(void)sendValidateCodeWithAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil) {
        return;
    }
    [self loadNumberValueWithAPIName:sendValidateCode_api_name params:@{@"user_phone":accountName} version:nil];
}

-(void)checkValidateCodeWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if ([WeAppUtils isEmpty:accountName]
        || [WeAppUtils isEmpty:validateCode]) {
        return;
    }
    [self loadNumberValueWithAPIName:checkValidateCode_api_name params:@{@"user_phone":accountName,@"securityCode":validateCode} version:nil];
}

-(void)modifyPasswordWithAccountName:(NSString*)accountName oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil
        || oldPassword == nil
        || newPassword == nil) {
        return;
    }
    self.password = newPassword;
    [self loadItemWithAPIName:modifyPwd_api_name params:@{@"user_phone":accountName,@"old_psw":[EHUtils tripleDES:oldPassword encryptOrDecrypt:kCCEncrypt],@"new_psw":[EHUtils tripleDES:newPassword encryptOrDecrypt:kCCEncrypt],@"flag":@"00000010"} version:nil];
}

-(void)modifyPhoneNumberWithOldAccountName:(NSString*)oldAccountName newAccountName:(NSString*)newAccountName password:(NSString*)password validateCode:(NSString*)validateCode{
    if (oldAccountName == nil) {
        oldAccountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (oldAccountName == nil
        || newAccountName == nil
        || password == nil
        || validateCode == nil) {
        return;
    }
    [self loadItemWithAPIName:modifyPwd_api_name params:@{@"user_phone":newAccountName,@"old_phone":oldAccountName,@"new_phone":newAccountName,@"user_psd":[EHUtils tripleDES:password encryptOrDecrypt:kCCEncrypt],@"securityCode":validateCode,@"flag":@"00000001"} version:nil];
}

-(void)resetPasswordWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode newPassword:(NSString*)newPassword{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil
        || validateCode == nil
        || newPassword == nil) {
        return;
    }
    self.accountName = accountName;
    self.password = newPassword;
    [self loadNumberValueWithAPIName:reset_api_name params:@{@"user_phone":accountName,@"user_password":[EHUtils tripleDES:newPassword encryptOrDecrypt:kCCEncrypt],@"securityCode":validateCode} version:nil];
}

-(void)registerWithAccountName:(NSString*)accountName password:(NSString*)password userName:(NSString*)userName validateCode:(NSString*)validateCode inviteCode:(NSString*)inviteCode{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if ([WeAppUtils isEmpty:accountName]
        || [WeAppUtils isEmpty:password]
        || [WeAppUtils isEmpty:userName]) {
        return;
    }
    self.accountName = accountName;
    self.password = password;
    self.jsonTopKey = @"responseData";
    NSMutableDictionary* params = [@{@"user_phone":accountName, @"user_password":[EHUtils tripleDES:password encryptOrDecrypt:kCCEncrypt] , @"nick_name":userName,@"user_head_img":@"",@"user_head_img_small":@""} mutableCopy];
    if (![WeAppUtils isEmpty:inviteCode]) {
        [params setObject:inviteCode forKey:@"code"];
    }
    if (![WeAppUtils isEmpty:validateCode]) {
        [params setObject:validateCode forKey:@"validateCode"];
    }
    [self setItemClass:[KSLoginComponentItem class]];
    
    [self loadItemWithAPIName:register_api_name params:params version:nil];
}

-(void)checkAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if ([WeAppUtils isEmpty:accountName]) {
        return;
    }
    [self loadItemWithAPIName:checkAccountName_api_name params:@{@"user_phone":accountName} version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    if ([model.apiName isEqualToString:login_api_name]) {
        // 返回成功后记录下登陆账号与密码
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
        [[KSLoginComponentItem sharedInstance] setXiaoxiPassword:[(KSLoginComponentItem*)model.item IMPassword]];
        [[KSLoginComponentItem sharedInstance] setAccountName:self.accountName];
        
        // 更新userInfo信息，更新登陆信息
        [[KSLoginComponentItem sharedInstance] updateUserInfo:[model.item toDictionary]];
        [[KSLoginComponentItem sharedInstance] updateUserLogin:YES];
        // 发送成功登陆消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification object:nil userInfo:nil];
    }else if([model.apiName isEqualToString:logout_api_name]){
        [[KSLoginComponentItem sharedInstance] updateUserLogin:NO];
        // 清除登录内容状态
        [[KSLoginComponentItem sharedInstance] clearPassword];
        // 发送成功登出消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSuccessNotification object:nil userInfo:nil];
    }else if ([model.apiName isEqualToString:register_api_name]){
        // 返回成功后记录下登陆账号与密码
        if (!self.accountName) {
            self.accountName = [model.params objectForKey:@"user_phone"];
        }
        if (!self.password) {
            self.password = [model.params objectForKey:@"user_password"];
        }
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
        [[KSLoginComponentItem sharedInstance] setAccountName:self.accountName];
        // 发送成功注册消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserRegisterSuccessNotification object:nil userInfo:nil];
    }else if ([model.apiName isEqualToString:reset_api_name]){
        // 返回成功后记录下登陆账号与密码
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
        [[KSLoginComponentItem sharedInstance] setAccountName:self.accountName];
    }else if ([model.apiName isEqualToString:modifyPwd_api_name]){
//        [[KSLoginComponentItem sharedInstance] clearPassword];
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
    }
    [super modelDidFinishLoad:model];
}

-(void)model:(WeAppBasicRequestModel *)model didFailLoadWithError:(NSError *)error{
    if ([model.apiName isEqualToString:login_api_name]) {
        // 发送登陆失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginFailNotification object:nil userInfo:@{@"error":error?:@""}];

    }else if([model.apiName isEqualToString:logout_api_name]){
        // 发送登出失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutFailNotification object:nil userInfo:@{@"error":error?:@""}];
    }else if ([model.apiName isEqualToString:register_api_name]){
        // 发送注册失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserRegisterFailNotification object:nil userInfo:@{@"error":error?:@""}];
    }
    [super model:model didFailLoadWithError:error];
}

@end
