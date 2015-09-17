//
//  EHSocializedShareConfig.m
//  eHome
//
//  Created by xtq on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSocializedShareConfig.h"

@implementation EHSocializedShareConfig

+ (void)config{
    
    //友盟AppKey
    [UMSocialData setAppKey:kEH_UM_APPKEY];
    
    //微博SSO授权
    [UMSocialSinaHandler openSSOWithRedirectURL:kEH_WEIBO_URL];
    
    //设置微信AppId、appKey，分享url
    [UMSocialQQHandler setQQWithAppId:kEH_QQ_APPID appKey:kEH_QQ_APPKEY url:kEH_WEBSITE_URL];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kEH_WECHAT_APPID appSecret:kEH_WECHAT_APPSECRET url:kEH_WEBSITE_URL];
    
    //由于苹果审核政策需求，友盟建议对未安装客户端平台进行隐藏
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline]];

    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"贯众·爱家";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"贯众·爱家";
    [UMSocialData defaultData].extConfig.qqData.title = @"贯众·爱家";

}

@end
