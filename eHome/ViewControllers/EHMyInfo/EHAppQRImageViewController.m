//
//  EHAppQRImageViewController.m
//  eHome
//
//  Created by xtq on 15/7/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAppQRImageViewController.h"
#import "EHSocializedSharedMacro.h"
#import "MWQREncode.h"

#define QRIMAGE_X_MARGIN 85
#define QRIMAGE_Y_MARGIN 180

@interface EHAppQRImageViewController ()

@property (nonatomic, strong)UILabel *appNameLabel;

@property (nonatomic, strong)UIImageView *appQRImageView;

@end

@implementation EHAppQRImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    self.view.backgroundColor = EH_bgcor1;

    [self.view addSubview:self.appQRImageView];
    [self.view addSubview:self.appNameLabel];
    // Do any additional setup after loading the view.
}

- (UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.appQRImageView.frame), 50)];
        _appNameLabel.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMinY(self.appQRImageView.frame) - 50 - 25);
        _appNameLabel.text = kEH_APP_NAME;
        _appNameLabel.font = EH_font1;
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _appNameLabel;
}

- (UIImageView *)appQRImageView{
    if (!_appQRImageView) {
        
        CGFloat imageViewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - QRIMAGE_X_MARGIN * 2;
        UIImage *appQRImage = [MWQREncode qrImageForString:kEH_WEBSITE_URL imageSize:imageViewWidth LogoImage:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME]];

        _appQRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewWidth)];
        _appQRImageView.center = CGPointMake(CGRectGetMidX(self.view.frame), QRIMAGE_Y_MARGIN+imageViewWidth/2);
        _appQRImageView.image = appQRImage;
        _appQRImageView.backgroundColor = [UIColor whiteColor];
    }
    return _appQRImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
