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
#import "NSString+StringSize.h"

#define SHAREMESSAGE1 @"我家宝贝手表的设备码是："
#define SHAREMESSAGE2 @"下载童行app,输入设备码即可关注！"
#define TEXTFIELD_INSETS 20
#define DEVICECODE_TEXTFIELD_Y_MARGIN 40
#define DEVICECODE_TEXTFIELD_HEIGHT 49
#define DEVICECODE_TEXTFIELD_LWFTVIEW_WIDTH 120

#define COPYLABEL_Y_HEIGHT 15
#define COPYLABEL_MARGIN 9


#define QRIMAGE_X_MARGIN 85
#define QRIMAGE_Y_MARGIN 60

#define kColumn 3           //列数
#define kSideSpaceX 70 / 2.0
#define kViewSpaceX 70 / 2.0
#define kViewSpaceY 75 / 2.0

@interface EHBabyIdentityViewController ()
{
    KSInsetsTextField* _deviceCodeTextField;
    UILabel* _babyEquipmentLabel;
    UIImageView* _deviceCodeQRImageView;
    UIImageView* _backgroundView;
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
    self.view.backgroundColor = EHBgcor1;
    [self setupSubViews];
    [self setupShareViews];
    
}


- (void)setupSubViews
{
    _backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_twodimensioncode_babyidentity"]];
    [self.view addSubview:_backgroundView];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(27*SCREEN_SCALE);
        make.left.equalTo(self.view.mas_left).with.offset(40*SCREEN_SCALE);
        make.right.equalTo(self.view.mas_right).with.offset(-40*SCREEN_SCALE);
        make.height.mas_equalTo((CGRectGetWidth(self.view.frame)-80)*CGRectGetHeight(_backgroundView.frame)/CGRectGetWidth(_backgroundView.frame));
    }];

    CGFloat imageViewWidth=CGRectGetWidth(_backgroundView.frame)-62;
    _deviceCodeQRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth , imageViewWidth)];
    [_backgroundView addSubview:_deviceCodeQRImageView];
    [_deviceCodeQRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(_backgroundView.mas_left).with.offset(10*SCREEN_SCALE);
        make.right.equalTo(_backgroundView.mas_right).with.offset(-10*SCREEN_SCALE);
        make.height.equalTo(_backgroundView.mas_width).with.offset(-20*SCREEN_SCALE);
    }];
    
 //   _deviceCodeQRImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, QRIMAGE_Y_MARGIN+imageViewWidth/2);
    
    _deviceCodeQRImageView.image = [MWQREncode qrImageForString:_deviceCode imageSize:imageViewWidth*2];
    
    
    _babyEquipmentLabel=[[UILabel alloc]init];
    _babyEquipmentLabel.text=@"宝贝设备码";
    _babyEquipmentLabel.font=[UIFont systemFontOfSize:EHSiz2];
    _babyEquipmentLabel.textColor=EHCor5;
    _babyEquipmentLabel.textAlignment=NSTextAlignmentCenter;
    CGFloat labelHeightsize = [@"text" sizeWithFontSize:EHSiz2 Width:CGRectGetWidth(_babyEquipmentLabel.frame)].height;
    [_backgroundView addSubview:_babyEquipmentLabel];
    [_babyEquipmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.top.equalTo(_deviceCodeQRImageView.mas_bottom).with.offset(13*SCREEN_SCALE);
        make.centerX.equalTo(_backgroundView.mas_centerX);
        make.width.equalTo(_backgroundView.mas_width);
        make.height.mas_equalTo(labelHeightsize);
    }];
    
    
    UIImageView *outlineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_phone_twodimensioncode_babyidentity"]];
    [_backgroundView addSubview:outlineView];
    [outlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_babyEquipmentLabel.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.centerX.equalTo(_backgroundView.mas_centerX);
        make.left.equalTo(_backgroundView.mas_left).with.offset(36*SCREEN_SCALE);
        make.right.equalTo(_backgroundView.mas_right).with.offset(-36*SCREEN_SCALE);
        make.bottom.equalTo(_backgroundView.mas_bottom).with.offset(-9*SCREEN_SCALE);
    }];
    
    
    UILabel *deviceCode=[[UILabel alloc]init];
    deviceCode.text=_deviceCode;
    deviceCode.font=[UIFont systemFontOfSize:EHSiz2];
    deviceCode.textColor=EHCor5;
    deviceCode.textAlignment=NSTextAlignmentCenter;
    [_backgroundView addSubview:deviceCode];
    [deviceCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(outlineView.mas_top).with.offset(2*SCREEN_SCALE);
        make.centerX.equalTo(_backgroundView.mas_centerX);
        make.width.equalTo(outlineView.mas_width);
        make.bottom.equalTo(outlineView.mas_bottom).with.offset(-2*SCREEN_SCALE);
    }];
    
    
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect rect = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    return rect.size.height;
}


-(void)setupShareViews{
    UILabel *shareLabel=[[UILabel alloc]init];
    NSString *share=@"可以通过以下三种方式对宝贝设备码进行分享";
    shareLabel.text=share;
    shareLabel.font=[UIFont systemFontOfSize:EHSiz5];
    shareLabel.textColor=EHCor3;
    shareLabel.textAlignment=NSTextAlignmentCenter;
  //  float shHeight=[self heightForString:share fontSize:EH_siz5 andWidth:CGRectGetWidth(_backgroundView.frame)];
     CGFloat shHeight = [@"text" sizeWithFontSize:EH_siz2 Width:CGRectGetWidth(_babyEquipmentLabel.frame)].height;
    
    [self.view addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      //  make.top.equalTo(_backgroundView.mas_bottom).with.offset(33*SCREEN_SCALE);
        make.centerX.equalTo(_backgroundView.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(shHeight);
    }];
    
    
    CGFloat imageWidth = (CGRectGetWidth(self.view.frame) - 70 * 2 ) / ((CGFloat)kColumn);
    CGFloat imageHeight = imageWidth;
    
  //  UIImageView *sharedBtnBgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_share_wechatanefriend"]];
    UIImageView *sharedBtnBgView=[[UIImageView alloc]init];
    [self.view addSubview:sharedBtnBgView];
    CGFloat labelHeight = [self heightForString:@"微信" fontSize:12.0f andWidth
                                               :imageWidth];
    [sharedBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(shareLabel.mas_bottom).with.offset(26*SCREEN_SCALE);
        make.width.equalTo(self.view.mas_width);
       // make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, imageHeight+labelHeight+40*SCREEN_SCALE));
    }];
    
    UIButton *weChatBtn=[[UIButton alloc]init];
    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_share_wechat"] forState:UIControlStateNormal];
    weChatBtn.tag=EHShareTypeWechatSession;
    //[self.dayButton addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [weChatBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sharedBtnBgView addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top);
        make.left.equalTo(sharedBtnBgView.mas_left).with.offset(kSideSpaceX);
        make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
    }];
    sharedBtnBgView.userInteractionEnabled=YES;
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"微信";
    label.font=[UIFont systemFontOfSize:EHSiz5];
    label.textColor =EHCor5;
    label.textAlignment=NSTextAlignmentCenter;
    [sharedBtnBgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(sharedBtnBgView.mas_left).with.offset(kSideSpaceX*SCREEN_SCALE);
        make.top.equalTo(weChatBtn.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.bottom.equalTo(sharedBtnBgView.mas_bottom).with.offset(-15*SCREEN_SCALE);
        make.centerX.equalTo(weChatBtn.mas_centerX);
    }];

    
    UIButton *QQMessageBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    [QQMessageBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_share_QQ"] forState:UIControlStateNormal];
    [sharedBtnBgView addSubview:QQMessageBtn];
    [QQMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top);
        make.left.equalTo(weChatBtn.mas_right).with.offset(kViewSpaceX*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
    }];
    QQMessageBtn.tag=EHShareTypeQQ;
    [QQMessageBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shareMessagelabelQQ=[[UILabel alloc]init];
    shareMessagelabelQQ.text=@"QQ";
    shareMessagelabelQQ.font=[UIFont systemFontOfSize:EHSiz5];
    shareMessagelabelQQ.textColor =EHCor5;
    shareMessagelabelQQ.textAlignment=NSTextAlignmentCenter;
    [sharedBtnBgView addSubview:shareMessagelabelQQ];
    [shareMessagelabelQQ mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(QQMessageBtn.mas_left);
        make.top.equalTo(QQMessageBtn.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.bottom.equalTo(sharedBtnBgView.mas_bottom).with.offset(-15*SCREEN_SCALE);
        make.centerX.equalTo(QQMessageBtn.mas_centerX);
    }];

    
    
    UIButton *shareMessageBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    [shareMessageBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_share_message"] forState:UIControlStateNormal];
    [sharedBtnBgView addSubview:shareMessageBtn];
    [shareMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top);
        make.left.equalTo(QQMessageBtn.mas_right).with.offset(kViewSpaceX*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(imageWidth,imageHeight));
    }];
    shareMessageBtn.tag=EHShareTypeSms;
    [shareMessageBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shareMessagelabel=[[UILabel alloc]init];
    shareMessagelabel.text=@"短信";
    shareMessagelabel.font=[UIFont systemFontOfSize:EHSiz5];
    shareMessagelabel.textColor = EHCor5;
    shareMessagelabel.textAlignment=NSTextAlignmentCenter;
    [sharedBtnBgView addSubview:shareMessagelabel];
    [shareMessagelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(shareMessageBtn.mas_left);
        make.top.equalTo(shareMessageBtn.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.bottom.equalTo(sharedBtnBgView.mas_bottom).with.offset(-15*SCREEN_SCALE);
        make.centerX.equalTo(shareMessageBtn.mas_centerX);
    }];

}



#pragma mark - 点击分享按钮响应事件
- (void)sharedButonClick:(UIButton *)sender
{
    NSString *sharedMessage = [NSString stringWithFormat:@"%@ %@，%@",SHAREMESSAGE1,_deviceCode,SHAREMESSAGE2];
    switch (sender.tag) {
        case EHShareTypeWechatSession:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:sharedMessage image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微信好友分享成功！");
                }
            }];
        }
            break;
            
        case EHShareTypeQQ:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:sharedMessage image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"QQ分享成功！");
                }
            }];
        }
            break;

        case EHShareTypeSms:
        {
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:sharedMessage image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
