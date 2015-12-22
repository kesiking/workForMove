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

#define QRIMAGE_X_MARGIN 50
#define QRIMAGE_Y_MARGIN 180

@interface EHAppQRImageViewController ()

@property (nonatomic, strong)UILabel *appNameLabel;

@property (nonatomic, strong)UIImageView *appLogoImageView;

@property (nonatomic, strong)UIImageView *appQRImageView;

@property (nonatomic, strong)UILabel *qrCodeDespLabel;

@end

@implementation EHAppQRImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    self.view.backgroundColor = EHBgcor1;

    [self.view addSubview:self.appLogoImageView];
    [self.view addSubview:self.appQRImageView];
    //[self.view addSubview:self.appNameLabel];
    //[self.view addSubview:self.qrCodeDespLabel];
    // Do any additional setup after loading the view.
}

//- (UILabel *)appNameLabel{
//    if (!_appNameLabel) {
//        _appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.appQRImageView.frame), 40)];
//        _appNameLabel.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMinY(self.appQRImageView.frame) - 40 );
//        _appNameLabel.text = @"爱家•童行";
//        _appNameLabel.font = EH_font1;
//        _appNameLabel.textAlignment = NSTextAlignmentCenter;
//        _appNameLabel.backgroundColor = EHBgcor1;
//    }
//    return _appNameLabel;
//}

- (UIImageView *)appLogoImageView{
    if (!_appLogoImageView) {
        
        _appLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - QRIMAGE_X_MARGIN, (SCREEN_WIDTH - QRIMAGE_X_MARGIN)*309.0/240)];//[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_2dimensional barcode_shareapp"]];
        
        _appLogoImageView.image = [UIImage imageNamed:@"img_2dimensional barcode_shareapp"];
        _appLogoImageView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)-30);
        _appLogoImageView.backgroundColor = [UIColor whiteColor];
    }
    return _appLogoImageView;
}

- (UIImageView *)appQRImageView{
    if (!_appQRImageView) {
        
        CGFloat imageViewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - QRIMAGE_X_MARGIN * 2;
        UIImage *appQRImage = [MWQREncode qrImageForString:kEH_WEBSITE_URL imageSize:imageViewWidth];

        _appQRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewWidth)];
        _appQRImageView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)-10);;
        _appQRImageView.image = appQRImage;
        _appQRImageView.backgroundColor = [UIColor whiteColor];
    }
    return _appQRImageView;
}

//- (UILabel *)qrCodeDespLabel{
//    if (!_qrCodeDespLabel) {
//        
//        _qrCodeDespLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.appQRImageView.frame)+10, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
//
//        _qrCodeDespLabel.text = @"扫一扫,快速下载爱家童行APP";
//        _qrCodeDespLabel.font = EH_font3;
//        _qrCodeDespLabel.textAlignment = NSTextAlignmentCenter;
//        _qrCodeDespLabel.backgroundColor = EHBgcor1;
//
//    }
//    return _qrCodeDespLabel;
//}

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
