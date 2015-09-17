//
//  EHSocialShareHandle.h
//  test-7.14-share
//
//  Created by xtq on 15/7/14.
//  Copyright (c) 2015年 one. All rights reserved.
//  可使用EHSocialShareHandle从底部弹出分享框。或者直接添加EHSocialShareView分享框视图到

#pragma mark - EHSocialShareHandle

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UMSocial.h"

typedef NS_ENUM(NSInteger, EHShareType) {
    EHShareTypeWechatSession = 0,
    EHShareTypeWechatTimeline,
    EHShareTypeQQ,
    EHShareTypeWeibo,
    EHShareTypeSms,
    EHShareTypeQRCode,
};

static NSString *const EHShareToWechatSession = @"微信";
static NSString *const EHShareToWechatTimeline = @"朋友圈";
static NSString *const EHShareToQQ = @"QQ";
static NSString *const EHShareToSina = @"微博";
static NSString *const EHShareToSms = @"短信";
static NSString *const EHShareToQRCode = @"二维码";

@interface EHSocialShareHandle : NSObject

+ (void)presentWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image FromTarget:(id)target;

@end



#pragma mark - EHSocialShareView

@protocol EHSocialShareViewDelegate <NSObject>

@required

/**
 *  需要在代理中去实现调用分享弹跳
 */
- (void)shareWithType:(NSInteger)type Title:(NSString *)title Image:(UIImage *)image;

@end


typedef NSTimeInterval (^FinishSelectedBlock) (void);                   //结束点击，返回延迟时间


@interface EHSocialShareView : UIView

@property (nonatomic, strong)FinishSelectedBlock finishSelectedBlock;   //在EHSocialShareHandle封装回调的时候用到

@property (nonatomic, strong)id delegate;

- (instancetype)initWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image InView:(UIView *)view FromTarget:(id)target;

@end