//
//  EHBabyIdentityViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyIdentityViewController.h"
#import "KSInsetsTextField.h"
#import "MWQREncode.h"
#import "Masonry.h"
#import "UMSocial.h"
#import "EHSocializedSharedMacro.h"
#import "EHSocialShareHandle.h"

#define TEXTFIELD_INSETS 20
#define DEVICECODE_TEXTFIELD_Y_MARGIN 40
#define DEVICECODE_TEXTFIELD_HEIGHT 49
#define DEVICECODE_TEXTFIELD_LWFTVIEW_WIDTH 120

#define COPYLABEL_Y_HEIGHT 15
#define COPYLABEL_MARGIN 9


#define QRIMAGE_X_MARGIN 85
#define QRIMAGE_Y_MARGIN 60

#define kColumn 3           //列数
#define kSideSpaceX 75 / 2.0
#define kViewSpaceX 120 / 2.0
#define kViewSpaceY 75 / 2.0

@interface EHBabyIdentityViewController ()
{
    KSInsetsTextField* _deviceCodeTextField;
    UILabel* _copyPromptLabel;
    UIImageView* _deviceCodeQRImageView;
    
    NSString* _deviceCode;
}
@end

@implementation EHBabyIdentityViewController

- (instancetype)initWithDeviceCode:(NSString*)deviceCode
{
    if (self = [super init]) {
        _deviceCode = deviceCode;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"宝贝身份";
    self.view.backgroundColor = EH_bgcor1;
    [self setupSubViews];
    [self setupShareViews];
    
}


- (void)setupSubViews
{
   
    
    CGFloat imageViewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - QRIMAGE_X_MARGIN * 2;
    
    _deviceCodeQRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth , imageViewWidth)];
    _deviceCodeQRImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, QRIMAGE_Y_MARGIN+imageViewWidth/2);
    
    _deviceCodeQRImageView.image = [MWQREncode qrImageForString:_deviceCode imageSize:imageViewWidth*2];
    _deviceCodeQRImageView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_deviceCodeQRImageView];
    
    _deviceCodeTextField = [[KSInsetsTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_deviceCodeQRImageView.frame)+DEVICECODE_TEXTFIELD_Y_MARGIN, CGRectGetWidth([UIScreen mainScreen].bounds), DEVICECODE_TEXTFIELD_HEIGHT)];
    _deviceCodeTextField.backgroundColor = [UIColor whiteColor];
    
    UILabel* customPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DEVICECODE_TEXTFIELD_LWFTVIEW_WIDTH, DEVICECODE_TEXTFIELD_HEIGHT)];
    customPrompt.text = @"宝贝身份识别码";
    customPrompt.font = [UIFont systemFontOfSize:EH_siz3];
    customPrompt.textColor = EH_cor4;
    
    _deviceCodeTextField.leftView = customPrompt;
    _deviceCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _deviceCodeTextField.textAlignment = NSTextAlignmentRight;
    _deviceCodeTextField.text = _deviceCode;
    
    _deviceCodeTextField.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, TEXTFIELD_INSETS);
    _deviceCodeTextField.leftViewEdgeInsets = UIEdgeInsetsMake(0, TEXTFIELD_INSETS, 0, 0);
    
    _deviceCodeTextField.font = [UIFont systemFontOfSize:EH_siz3];
    _deviceCodeTextField.textColor = EH_cor5;
    
    [self.view addSubview:_deviceCodeTextField];
    
    _copyPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEXTFIELD_INSETS, CGRectGetMaxY(_deviceCodeTextField.frame)+COPYLABEL_Y_HEIGHT, CGRectGetWidth([UIScreen mainScreen].bounds), COPYLABEL_Y_HEIGHT)];
    _copyPromptLabel.text = @"点击长按可以复制宝贝身份识别码";
    _copyPromptLabel.textColor = EH_cor4;
    _copyPromptLabel.font = EH_font6;
    
    [self.view addSubview:_copyPromptLabel];
    
    
}



- (void)setupSubViewsold
{
    _deviceCodeTextField = [[KSInsetsTextField alloc] initWithFrame:CGRectMake(0, DEVICECODE_TEXTFIELD_Y_MARGIN, CGRectGetWidth([UIScreen mainScreen].bounds), DEVICECODE_TEXTFIELD_HEIGHT)];
    _deviceCodeTextField.backgroundColor = [UIColor whiteColor];
    
    UILabel* customPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICECODE_TEXTFIELD_LWFTVIEW_WIDTH, DEVICECODE_TEXTFIELD_HEIGHT)];
    customPrompt.text = @"宝贝身份识别码";
    customPrompt.font = [UIFont systemFontOfSize:EH_siz3];
    customPrompt.textColor = EH_cor4;
    
    _deviceCodeTextField.leftView = customPrompt;
    _deviceCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _deviceCodeTextField.textAlignment = NSTextAlignmentRight;
    _deviceCodeTextField.text = _deviceCode;
    
    _deviceCodeTextField.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, TEXTFIELD_INSETS);
    _deviceCodeTextField.leftViewEdgeInsets = UIEdgeInsetsMake(0, TEXTFIELD_INSETS, 0, 0);
    
    _deviceCodeTextField.font = [UIFont systemFontOfSize:EH_siz3];
    _deviceCodeTextField.textColor = EH_cor5;
    
    [self.view addSubview:_deviceCodeTextField];
    
    _copyPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEXTFIELD_INSETS, CGRectGetMaxY(_deviceCodeTextField.frame)+COPYLABEL_Y_HEIGHT, CGRectGetWidth([UIScreen mainScreen].bounds), COPYLABEL_Y_HEIGHT)];
    _copyPromptLabel.text = @"点击长按可以复制宝贝身份识别码";
    _copyPromptLabel.textColor = EH_cor4;
    _copyPromptLabel.font = EH_font6;
    
    [self.view addSubview:_copyPromptLabel];
    
    CGFloat imageViewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - QRIMAGE_X_MARGIN * 2;
    
    
    _deviceCodeQRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth , imageViewWidth)];
    _deviceCodeQRImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, QRIMAGE_Y_MARGIN+imageViewWidth/2);
    _deviceCodeQRImageView.image = [MWQREncode qrImageForString:_deviceCode imageSize:imageViewWidth*2];
    _deviceCodeQRImageView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_deviceCodeQRImageView];
    
    
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect rect = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    return rect.size.height;
}


-(void)setupShareViews{
    CGFloat imageWidth = (CGRectGetWidth(self.view.bounds) - (kSideSpaceX * 2 + kViewSpaceX * (kColumn - 1))) / ((CGFloat)kColumn);
    CGFloat imageHeight = imageWidth;
    
  //  UIImageView *sharedBtnBgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_share_wechatanefriend"]];
    UIImageView *sharedBtnBgView=[[UIImageView alloc]init];
    sharedBtnBgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sharedBtnBgView];
    CGFloat labelHeight = [self heightForString:@"微信" fontSize:12.0f andWidth
                                               :imageWidth];
    [sharedBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
        make.centerX.equalTo(self.view.mas_centerX);
       make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, imageHeight+labelHeight+40*SCREEN_SCALE));
    }];
    
    UIButton *weChatBtn=[[UIButton alloc]init];
    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"ico_share_wechat"] forState:UIControlStateNormal];
    weChatBtn.tag=EHShareTypeWechatSession;
    //[self.dayButton addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [weChatBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sharedBtnBgView addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(sharedBtnBgView.mas_left).with.offset(kSideSpaceX);
        make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
    }];
    sharedBtnBgView.userInteractionEnabled=YES;
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"微信";
    label.font=EH_font6;
    label.textColor = RGB(0x66, 0x66, 0x66);
    label.textAlignment=NSTextAlignmentCenter;
    [sharedBtnBgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(sharedBtnBgView.mas_left).with.offset(kSideSpaceX);
        make.top.equalTo(weChatBtn.mas_bottom).with.offset(10*SCREEN_SCALE);
        make.bottom.equalTo(sharedBtnBgView.mas_bottom).with.offset(-15*SCREEN_SCALE);
        make.centerX.equalTo(weChatBtn.mas_centerX);
    }];

    
    UIButton *shareMessageBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    [shareMessageBtn setBackgroundImage:[UIImage imageNamed:@"ico_share_message"] forState:UIControlStateNormal];
    [sharedBtnBgView addSubview:shareMessageBtn];
    [shareMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(weChatBtn.mas_right).with.offset(kViewSpaceX);
        make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
    }];
    shareMessageBtn.tag=EHShareTypeSms;
    [shareMessageBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shareMessagelabel=[[UILabel alloc]init];
    shareMessagelabel.text=@"短信";
    shareMessagelabel.font=EH_font6;
    shareMessagelabel.textColor = RGB(0x66, 0x66, 0x66);
    shareMessagelabel.textAlignment=NSTextAlignmentCenter;
    [sharedBtnBgView addSubview:shareMessagelabel];
    [shareMessagelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(shareMessageBtn.mas_left);
        make.top.equalTo(shareMessageBtn.mas_bottom).with.offset(10*SCREEN_SCALE);
        make.bottom.equalTo(sharedBtnBgView.mas_bottom).with.offset(-15*SCREEN_SCALE);
        make.centerX.equalTo(shareMessageBtn.mas_centerX);
    }];

}



#pragma mark - 点击分享按钮响应事件
- (void)sharedButonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case EHShareTypeWechatSession:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"test" image:[self screenshotForCroppingRect:CGRectMake(0, 0, SCREEN_WIDTH, 533)] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微信好友分享成功！");
                }
            }];
        }
            break;
        case EHShareTypeSms:
        {
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:@"test" image:[self screenshotForCroppingRect:CGRectMake(0, 0, SCREEN_WIDTH, 533)] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"短信分享成功！");
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 私有方法
/**
 *  @author jweigang, 15-07-16 15:07:22
 *
 *  根据制定大小截取屏幕
 *
 *  @param croppingRect CGRect类型
 *
 *  @return 返回截取到的UIImage
 */
- (UIImage *)screenshotForCroppingRect:(CGRect)croppingRect
{
    UIGraphicsBeginImageContextWithOptions(croppingRect.size, NO, [UIScreen mainScreen].scale);
    // Create a graphics context and translate it the view we want to crop so
    // that even in grabbing (0,0), that origin point now represents the actual
    // cropping origin desired:
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) return nil;
    CGContextTranslateCTM(context, -croppingRect.origin.x, -croppingRect.origin.y);
    
    [self.view layoutIfNeeded];
    [self.view.layer renderInContext:context];
    
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}


@end
