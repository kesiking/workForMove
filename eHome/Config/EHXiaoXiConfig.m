//
//  EHXiaoXiConfig.m
//  eHome
//
//  Created by 孟希羲 on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHXiaoXiConfig.h"
#import <EIM_XMPP/XMPPManager.h>
#import "EHSocializedSharedMacro.h"
#import "EHMessageManager.h"
#import "EHRemoteMessageModel.h"
#import "EHDeviceActionForMessage.h"
#import "EHAleatView.h"
#import "EHTabBarViewController.h"
#import "EHSingleChatMessageHandleFactory.h"
#import "MessageModel+EHMessageParse.h"

#define REPEATE_LOGIN_ERROR @"账号在其他设备重复登录"

#define DEVELOP_ENVIRONMENT @"develop"
#define PRODUCT_ENVIRONMENT @"product"

#ifdef DEBUG
#define push_notification_environment DEVELOP_ENVIRONMENT
#else
#define push_notification_environment PRODUCT_ENVIRONMENT
#endif

@implementation EHXiaoXiConfig

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}


+ (void)configXiaoXi{
    // 配置小溪
    [[XMPPManager defaultManager] onCreateAppkey:kEH_XIAOXIKEY];
    // 注册消息
    [[self sharedCenter] setup];
}

+ (void)setDeviceToken:(NSData*)deviceToken{
    [XMPPManager defaultManager].deviceToken = deviceToken;
}

+ (void)goOffLine{
    [[XMPPManager defaultManager] goOffLine];
    [EHXiaoXiConfig sharedCenter].isXiaoXiOnline = NO;
}

+ (void)setUnReadMessageCount:(NSInteger)count{
    [[XMPPManager defaultManager] setUnReadMessageCount:count];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)setup{
    
    // 初始化通知
    [self setupXiaoXiNotification];
    // 消息接收
    [self xiaoXiReedMessageCallBackProcess];
    // 状态轮训
    [self xiaoXiStatusCallBackProcess];
    
}

-(void)setupXiaoXiNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginNotification:) name:kUserLoginSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)xiaoXiReedMessageCallBackProcess{
    void(^successCompleteBlock)(MessageModel *model) = ^(MessageModel *model){
        if (!(model.chatType == EHMessageChatType_single)) {
            return;
        }
        if (!(model.fileType == EHMessageFileType_text)) {
            return;
        }
        // 未登录不做操作
        if (![KSAuthenticationCenter isLogin]) {
            return;
        }
        // 与安卓逻辑不同，IOS是通过外层的msgid判断是否为语音聊天的，语音聊天编号为1000506
        EHSingleChatMessageBasicHandle* chatMessageHandle = [EHSingleChatMessageHandleFactory getMessageHandleByType:[EHSingleChatMessageHandleFactory getMessageTypeWithEHMsgid:model.msgid]];
        [chatMessageHandle sendRemoteMessageWithMessage:[[EHSingleChatMessageModel alloc] initWithMessageModel:model]];
    };
    
    [[XMPPManager defaultManager] receiveMessageBlock:^(MessageModel *model) {
        if (successCompleteBlock) {
            successCompleteBlock(model);
        }
    }];
    
    [[XMPPManager defaultManager] sendselfmessageblock:^(MessageModel *model) {
        if (successCompleteBlock) {
            successCompleteBlock(model);
        }
    }];
}

-(void)xiaoXiStatusCallBackProcess{
    WEAKSELF
    [[XMPPManager defaultManager] repeatLoginblock:^(NSString *error) {
        // 重复登录，弹出登陆框
        if (error && [error isEqualToString:REPEATE_LOGIN_ERROR]) {
            void(^cancelActionBlock)(void) = ^(void){
                // 如果当前选中的tab就是我的登陆页面，取消登陆后跳转到上次选中的tab
                EHTabBarViewController* tabbarVC = [EHTabBarViewController getTabBarViewController];
                if (tabbarVC && [tabbarVC isKindOfClass:[EHTabBarViewController class]]) {
                    [tabbarVC.navigationController popToViewController:tabbarVC animated:YES];
                    [tabbarVC setSelectedIndex:EHTabBarViewControllerType_Home];
                }
            };
            
            void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
                // 如果登陆成功就跳转到当前
                EHTabBarViewController* tabbarVC = [EHTabBarViewController getTabBarViewController];
                NSString* preUserPhone = [KSAuthenticationCenter preUserPhone];
                NSString* currentUserPhone = [KSAuthenticationCenter userPhone];
                BOOL needPopToHomeController = (preUserPhone == nil || ![preUserPhone isEqualToString:currentUserPhone]) || (tabbarVC.selectedIndex == EHTabBarViewControllerType_Sport);
                if (tabbarVC && [tabbarVC isKindOfClass:[EHTabBarViewController class]] && needPopToHomeController) {
                    [tabbarVC.navigationController popToViewController:tabbarVC animated:YES];
                    [tabbarVC setSelectedIndex:EHTabBarViewControllerType_Home];
                }
            };
            [[KSAuthenticationCenter sharedCenter] repeatLoginAleatViewWithMessage:REPEAT_LOGIN_ALERTVIEW_MESSAGE loginActionBlock:loginActionBlock cancelActionBlock:cancelActionBlock];
        }
        EHLogInfo(@" ----> ");
    } contectSuccessful:^(NSString *successFul) {
        EHLogInfo(@" ----> ");
    } contectFail:^(NSString *fail) {
        EHLogInfo(@" ----> ");
        weakSelf.isXiaoXiOnline = NO;
    } platformDeleteUser:^(NSString *deleteUser) {
        EHLogInfo(@" ----> ");
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[XMPPManager defaultManager] releaseXmppManager];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma send message method
- (void)sendRemoteMessageWithMessage:(NSString*)message{
    EHSingleChatBabyRemoteMessageHandle* chatMessageHandle = [EHSingleChatBabyRemoteMessageHandle new];
    [chatMessageHandle sendBabyRemoteMessageWithMessage:message];
}

-(void)sendVoice:(NSString *)path voiceLength:(NSInteger)length
              to:(NSString *)userName
messageSuccessBlock:(void(^)(void))messageSuccessBlock
   messageFailBlock:(void(^)(NSError* error))messageFailBlock{
    if ([EHUtils isEmptyString:path] || [EHUtils isEmptyString:userName]) {
        return;
    }
    [[XMPPManager defaultManager] sendVoice:path voiceLength:length updataVoiceBegin:^{
        EHLogInfo(@"语音正在发送");
    } to:userName messageblock:^(BOOL ret, XMPPManagerErrorCode code) {
        if (ret) {
            if (messageSuccessBlock) {
                messageSuccessBlock();
            }
        }else{
            NSError *error = [NSError errorWithDomain:@"messageErrorDomain" code:code userInfo:nil];
            if (messageFailBlock) {
                messageFailBlock(error);
            }
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma login xiaoxi method
-(void)loginXIAOXI{
    WEAKSELF
    [[XMPPManager defaultManager] loginWithUserName:[[KSLoginComponentItem sharedInstance] getAccountName] password:[[KSLoginComponentItem sharedInstance] getPassword] loginblockSucessful:^{
        EHLogInfo(@"登录成功");
        [weakSelf subscribePushNotification];
        weakSelf.isXiaoXiOnline = YES;
    } loginFail:^(NSString *error) {
        EHLogInfo(@"登录失败，错误码：@％");
        weakSelf.isXiaoXiOnline = NO;
    }];
}

/*!
 *  @author 孟希羲, 15-08-13 17:08:43
 *
 *  @brief  订阅在线消息
 *
 *  @since 1.0
 */
-(void)subscribePushNotification{
    EHLogInfo(@"-----> push_notification_environment:%@",push_notification_environment);
    [[XMPPManager defaultManager] subscribePushNotification:push_notification_environment subscribeSuccessful:^{
        EHLogInfo(@"-----> 订阅成功");
    } subscribeFail:^(NSString *error) {
        EHLogError(@"-----> 订阅失败: %@",error);
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma notification method
-(void)applicationDidBecomeActive:(NSNotification*)notification{
    [self loginXIAOXI];
}

-(void)userDidLoginNotification:(NSNotification*)notification{
    //最后,在登录账户成功后调用订阅推送接口: 
    [self loginXIAOXI];
}

-(void)userDidLogoutNotification:(NSNotification*)notification{
    //在退出账号登录后调用此接口,可取消推送 
    [[XMPPManager defaultManager] cancelPushNotification];
    [[XMPPManager defaultManager] goOffLine];
}

@end
