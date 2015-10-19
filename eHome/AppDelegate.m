//
//  AppDelegate.m
//  eHome
//
//  Created by louzhenhua on 15/6/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "AppDelegate.h"
#import "EHTabBarViewController.h"
#import "EHSocializedShareConfig.h"
#import "EHMessageManager.h"
#import "EHRemoteMessageModel.h"
#import "EHXiaoXiConfig.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()

@property (nonatomic, assign)  BOOL    isNotNeedPushNotificationMessage;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [EHLog initEHLog];
    
    EHLogInfo(@"launch finished!");
    [self configRemoteNotificationWithApplication:application launchingWithOptions:launchOptions];
    [self configUIContent];
    [self configApplication];
    [self configIQKeyboardManager];
    [EHSocializedShareConfig config];
    
    return YES;
}

-(void)configIQKeyboardManager{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.enableAutoToolbar = NO;
}
-(void)configApplication{
    // 配置小溪
    [EHXiaoXiConfig configXiaoXi];
    // 读取配置文件
    [KSConfigCenter configMatrix];
    // 配置Navigator，支持全局url跳转
    [KSBasicNavigator configNavigator];
    // 检查是否登录
    [[KSAuthenticationCenter sharedCenter] autoLoginWithCompleteBlock:nil];
}

-(void)configUIContent{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController: [[EHTabBarViewController alloc] init]];
    navigationController.navigationBar.translucent = NO;
    if([navigationController.navigationBar respondsToSelector:@selector(barTintColor)]){
        navigationController.navigationBar.barTintColor = UINAVIGATIONBAR_COLOR;
    }
    if([navigationController.navigationBar respondsToSelector:@selector(tintColor)]){
        navigationController.navigationBar.tintColor  =   UINAVIGATIONBAR_TITLE_COLOR;
    }
    [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    // 修改navbar title颜色
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               UINAVIGATIONBAR_TITLE_COLOR, NSForegroundColorAttributeName,
                                               [UIFont boldSystemFontOfSize:18], NSFontAttributeName,nil];
    
    [navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    self.window.rootViewController = navigationController;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
    EHLogInfo(@"%@",platformType);
    [EHXiaoXiConfig setUnReadMessageCount:0];
    [EHXiaoXiConfig goOffLine];
    self.isNotNeedPushNotificationMessage = NO;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cancelAllNotificationMessage];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - remoteNotification method
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [EHXiaoXiConfig setDeviceToken:deviceToken];
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    // to do upload token
    EHLogInfo(@"---Token--%@", token);
}

//不管APP是否在线，只要有推送消息都会调用该方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    EHLogInfo(@"userInfo == %@",userInfo);
    // 防止小溪抽风一直走离线推送，导致不断消息页面进栈
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"active");
        //程序当前正处于前台
    }else if(application.applicationState == UIApplicationStateInactive){
        NSLog(@"inactive");
        //程序处于后台
        @synchronized(self){
            if (!self.isNotNeedPushNotificationMessage) {
                self.isNotNeedPushNotificationMessage = YES;
                NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                // 消息处理
                [self sendRemoteMessageWithMessageWithMessageText:message];
                // 返回app首页
                [self goBackToHomeTabViewControllerWithMessageText:message];
                // 根据消息打开不同页面，如进入消息页面，进入申请页面
                [self openNativeViewControllerWithMessageText:message];
            }
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    EHLogInfo(@"Regist fail%@",error);
}

-(void)configRemoteNotificationWithApplication:(UIApplication *)application launchingWithOptions:(NSDictionary *)launchOptions {
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    // 点击消息进入的页面
    if (launchOptions) {
        // do something else
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        [[EHXiaoXiConfig sharedCenter] sendRemoteMessageWithMessage:message];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    
}

- (void)cancelAllNotificationMessage{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Remote Message Action method
- (void)sendRemoteMessageWithMessageWithMessageText:(NSString*)messageText{
    [[EHXiaoXiConfig sharedCenter] sendRemoteMessageWithMessage:messageText];
}

- (void)goBackToHomeTabViewControllerWithMessageText:(NSString*)messageText{
    EHTabBarViewController* tabbarVC = [EHTabBarViewController getTabBarViewController];
    if (tabbarVC && [tabbarVC isKindOfClass:[EHTabBarViewController class]]) {
        [tabbarVC.navigationController popToViewController:tabbarVC animated:NO];
        [tabbarVC setSelectedIndex:EHTabBarViewControllerType_Home];
    }else{
        [self.window.rootViewController.KSNavigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)openNativeViewControllerWithMessageText:(NSString*)messageText{
    
    if ([messageText hasPrefix:@"语音通话"]) {
        NSString* babyId = [self getBabyIdStringFromMessageText:messageText];
        if (babyId == nil) {
            return;
        }
        TBOpenURLFromTargetWithNativeParams(internalURL(@"EHBabySingleChatMessageViewController"), self.window.rootViewController, @{ACTION_ANIMATION_KEY:@(false)} ,@{@"babyId":[NSNumber numberWithInteger:[babyId integerValue]]});
    }else if ([messageText hasPrefix:@"用户关注"]) {
        NSString* babyId = [self getBabyIdStringFromMessageText:messageText];
        if (babyId == nil) {
            return;
        }
        TBOpenURLFromTargetWithNativeParams(internalURL(@"EHNewApplyFamilyMemberViewController"), self.window.rootViewController, @{ACTION_ANIMATION_KEY:@(false)} ,@{@"babyId":[NSNumber numberWithInteger:[babyId integerValue]]});
    }else{
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if ([messageText isEqualToString:@"家庭消息"]) {
            [params setObject:@(1) forKey:@"systemMessageType"];
        }
        TBOpenURLFromTargetWithNativeParams(internalURL(@"EHMessageInfoViewController"), self.window.rootViewController, @{ACTION_ANIMATION_KEY:@(false)} ,params);
    }
   
}

-(NSString*)getBabyIdStringFromMessageText:(NSString*)messageText{
    NSArray *array = [messageText componentsSeparatedByString:@"("];
    if ([array count] <= 1) {
        return nil;
    }
    NSString *subMessage = [array objectAtIndex:1];
    NSArray *subarray = [subMessage componentsSeparatedByString:@")"];
    if ([array count] <= 1) {
        return nil;
    }
    NSString* babyId = [subarray objectAtIndex:0];
    return babyId;
}

@end
