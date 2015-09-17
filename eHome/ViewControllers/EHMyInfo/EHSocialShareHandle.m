//
//  EHSocialShareHandle.m
//  test-7.14-share
//
//  Created by xtq on 15/7/14.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHSocialShareHandle.h"
#import "NSString+StringSize.h"

#define kColumn 3           //列数
#define kSideSpaceX 75 / 2.0
#define kViewSpaceX 120 / 2.0
#define kViewSpaceY 75 / 2.0

#define kViewTag 100

@interface EHSocialShareHandle ()

@end

@implementation EHSocialShareHandle
{
    UIView *_bgView;
    EHSocialShareView *_shareView;
    NSTimeInterval _duration;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _duration = 0.3;
    }
    return self;
}

+(EHSocialShareHandle *)sharedManager{
    static dispatch_once_t predicate;
    static EHSocialShareHandle * sharedManager;
    dispatch_once(&predicate, ^{
        sharedManager=[[EHSocialShareHandle alloc] init];
    });
    return sharedManager;
}

+ (void)presentWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image FromTarget:(id)target{
    
    [[EHSocialShareHandle sharedManager] showWithTypeArray:array Title:title Image:image FromTarget:target];
}

- (void)showWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image FromTarget:(id)target{
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    _bgView = [[UIView alloc]initWithFrame:window.bounds];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_bgView addGestureRecognizer:tap];
    [window addSubview:_bgView];
    
    _shareView = [[EHSocialShareView alloc]initWithTypeArray:array Title:title Image:image InView:_bgView FromTarget:target];
    typeof(self) __weak weakSelf = self;
    __block NSTimeInterval delay = _duration;
    _shareView.finishSelectedBlock = ^(){
        [weakSelf hide];
        return delay;
    };
    
    _shareView.layer.transform = CATransform3DMakeTranslation(0, CGRectGetHeight(_shareView.frame), 0);
    [UIView animateWithDuration:_duration animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        _shareView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hide{
    [UIView animateWithDuration:_duration animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        _shareView.layer.transform = CATransform3DMakeTranslation(0, CGRectGetHeight(_shareView.frame), 0);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_shareView removeFromSuperview];
        _bgView = nil;
        _shareView = nil;
    }];
}

- (void)tap:(id)gesture{
    [self hide];
}


@end





@interface EHSocialShareView()

@property (nonatomic, strong)NSString *shareTitle;

@property (nonatomic, strong)UIImage *shareImage;

@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, strong)NSArray *titleArray;

@property (nonatomic, strong)NSArray *imageArray;


@end

@implementation EHSocialShareView


- (instancetype)initWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image InView:(UIView *)view FromTarget:(id)target{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = view.bounds;
        [view addSubview:self];
        
        self.typeArray = array;
        self.delegate = target;
        self.shareTitle = title;
        self.shareImage = image;
        
        [self configUI];
    }
    return self;
}


#pragma mark - Events Response
- (void)btnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (self.finishSelectedBlock) {
        NSInteger delay =  self.finishSelectedBlock();
        [self performSelector:@selector(selectTag:) withObject:@(btn.tag - kViewTag) afterDelay:delay];
    }
    else {
        [self performSelector:@selector(selectTag:) withObject:@(btn.tag - kViewTag) afterDelay:0];
    }

}

- (void)selectTag:(NSNumber *)tag{
    NSLog(@"selectTag = %@",tag);
    [self.delegate shareWithType:[tag integerValue] Title:self.shareTitle Image:self.shareImage];
}

#pragma mark - Getters And Setters
- (void)configUI{
    CGFloat imageWidth = (CGRectGetWidth(self.frame) - (kSideSpaceX * 2 + kViewSpaceX * (kColumn - 1))) / ((CGFloat)kColumn);
    CGFloat imageHeight = imageWidth;
    
    CGFloat labelWidth = imageWidth;
    CGFloat labelHeight = [self.titleArray[0] sizeWithFontSize:12.0f Width:imageWidth].height;
    
    CGFloat selfHeight = (20 + imageWidth + 10 + labelHeight) * ((self.typeArray.count - 1) / kColumn + 1) + 20;
    
    self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame) - selfHeight, CGRectGetWidth(self.superview.frame), selfHeight);
    
    for (int i = 0 ; i < self.typeArray.count; i++) {
        
        NSString *title = self.typeArray[i];
        NSInteger index = [self.titleArray indexOfObject:title];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kSideSpaceX + imageWidth *(i % kColumn) + kViewSpaceX * (i % kColumn), 20 + (imageHeight + 10 + labelHeight + 20) * (i/kColumn), imageWidth, imageHeight) ];
        [btn setImage:self.imageArray[index] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = kViewTag + index;
        [self addSubview:btn];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) + 10, labelWidth, labelHeight)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = RGB(0x66, 0x66, 0x66);
        [self addSubview:label];
    }
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToQQ,EHShareToSina,EHShareToSms,EHShareToQRCode];
    }
    return _titleArray;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        UIImage *wechatSessionImage = [UIImage imageNamed:@"ico_share_wechat"];
        UIImage *wechatTimelineImage = [UIImage imageNamed:@"ico_share_circleoffriends"];
        UIImage *QQImage = [UIImage imageNamed:@"ico_share_QQ"];
        UIImage *sinaImage = [UIImage imageNamed:@"ico_share_sina"];
        UIImage *smsImage = [UIImage imageNamed:@"ico_share_message"];
        UIImage *QRCodeImage = [UIImage imageNamed:@"ico_share_twodimensioncode"];
        _imageArray = @[wechatSessionImage,wechatTimelineImage,QQImage,sinaImage,smsImage,QRCodeImage];
    }
    return _imageArray;
}

@end
