//
//  EHMapManagerActionSheet.m
//  eHome
//
//  Created by 孟希羲 on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapManagerActionSheet.h"
#import "EHMapNavigationManager.h"
#import "EHDeviceStatusCenter.h"
#import "RMActionController.h"
#import "EHAleatView.h"
#import "KSToastView.h"
#import "EHLoadingToast.h"

@implementation EHMapManagerActionSheet

-(void)setupView{
    [super setupView];
}

-(void)showMapManagerActionSheet{
    NSArray *mapsArray = [EHMapNavigationManager checkHasOwnApp];
    if (mapsArray == nil || [mapsArray count] == 0) {
        [self showHasNoMapAppErrorTosat];
        return;
    }
    
    if (![[EHDeviceStatusCenter sharedCenter] didGetCurrentLoaction] || [EHBabyListDataCenter sharedCenter].currentBabyPosition == nil){
        [self showHasNoCurrentPositionErrorTosat];
        return;
    }
    
    RMActionController *actionSheet = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    actionSheet.seperatorViewColor = EH_cor8;
    
    //Setup properties of elements
    UILabel* headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerTitleLabel.text = @"请选择导航";
    [headerTitleLabel sizeToFit];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.textColor = EH_cor3;
    headerTitleLabel.font = EH_font4;
    headerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    headerTitleLabel.numberOfLines = 1;
    actionSheet.contentView = headerTitleLabel;
    NSDictionary *bindings = @{@"contentView": actionSheet.contentView};
    [actionSheet.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(44)]" options:0 metrics:nil views:bindings]];
    
    actionSheet.disableBlurEffects = YES;
    
    for (NSDictionary* mapDict in mapsArray) {
        if (![mapDict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSString* mapDescription = [mapDict objectForKey:@"mapDescription"];
        NSString* mapImageBundle = [mapDict objectForKey:@"mapImageBundle"];
        RMAction *mapAction = [RMAction actionWithTitle:mapDescription style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
            if ([[EHDeviceStatusCenter sharedCenter] didGetCurrentLoaction] && [EHBabyListDataCenter sharedCenter].currentBabyPosition) {
                CLLocationCoordinate2D currentBabyCoordinate;                                   //设置坐标
                currentBabyCoordinate.latitude = [[EHBabyListDataCenter sharedCenter].currentBabyPosition.location_latitude doubleValue];      //经度
                currentBabyCoordinate.longitude = [[EHBabyListDataCenter sharedCenter].currentBabyPosition.location_longitude doubleValue];    //纬度
                [EHMapNavigationManager openMapUrlArrayWithCurrentCoordinate:[EHDeviceStatusCenter sharedCenter].currentPhoneCoordinate naviCoordinate:currentBabyCoordinate withMapDescription:mapDescription];
            }
        }];
        mapAction.titleColor = UINAVIGATIONBAR_COMMON_COLOR;
        mapAction.titleFont = [UIFont boldSystemFontOfSize:EH_siz4];
        UIView* actionView = [mapAction valueForKey:@"view"];
        if (mapImageBundle && mapImageBundle.length > 0 && actionView && [actionView isKindOfClass:[UIButton class]]) {
            UIButton * actionButton = (UIButton*)actionView;
            [actionButton setImage:[UIImage imageNamed:mapImageBundle] forState:UIControlStateNormal];
            [actionButton setImageEdgeInsets:UIEdgeInsetsMake((actionButton.height - 30)/2, -20, (actionButton.height - 30)/2, 0)];
        }
        [actionSheet addAction:mapAction];
    }
    
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor = UINAVIGATIONBAR_COMMON_COLOR;
    cancelAction.titleFont = [UIFont boldSystemFontOfSize:EH_siz4];
    [actionSheet addAction:cancelAction];
    
    //Now just present the date selection controller using the standard iOS presentation method
    UIViewController* popViewController = self.popViewController ? : self.viewController;
    [popViewController presentViewController:actionSheet animated:YES completion:nil];
}

-(void)showHasNoMapAppErrorTosat{
    [KSToastView toast:@"您的手机尚未安装导航App\n无法使用导航功能！" toView:[[UIApplication sharedApplication] keyWindow] displaytime:3.0 postion:CGPointZero withCallBackBlock:^(UIView *toastView, UILabel *toastLabel) {
        UIImageView* iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_exclamation_toast"]];
        [iconImageView setFrame:CGRectMake((toastView.width - 50)/2, 25, 50, 50)];
        [toastView addSubview:iconImageView];
        
        toastView.layer.cornerRadius = 0;
        toastView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        [toastView setHeight:toastView.height + 25 + 50];
        
        [toastLabel setOrigin:CGPointMake(toastLabel.origin.x, iconImageView.bottom + 10)];
        
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:toastView.bounds];
        bgImageView.image = [[UIImage imageNamed:@"bg_toast"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 100, 150)];
        [toastView insertSubview:bgImageView atIndex:0];
    }];
}

-(void)showHasNoCurrentPositionErrorTosat{
    EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:@"未能获取到手机当前位置\n请打开3G/4G网络或者gps"/*@"进入我的选项需要登陆账号，是否登陆已有账号？"*/ clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
        
    } cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [aleatView show];
}

@end
