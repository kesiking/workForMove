//
//  EHGeofenceRemindEditViewController.m
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceRemindEditViewController.h"
#import "RMActionController.h"
#import "EHDeleteGeofenceRemindService.h"
#import "EHUpdateGeofenceRemindService.h"

@interface EHGeofenceRemindEditViewController ()

@end

@implementation EHGeofenceRemindEditViewController
{
    EHDeleteGeofenceRemindService *_deleteRemindService;
    EHUpdateGeofenceRemindService *_updateRemindService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self deleteRemindButton]];
}

#pragma mark - Events Response
- (void)sureItemClick {
    if (!self.remindUpdated) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.remindModel.work_date isEqualToString:@"0000000"]) {
        [WeAppToast toast:@"请选择日期"];
        return;
    }

    //修改围栏请求
    [self configUpdateRemindService];
    [_updateRemindService UpdateGeofenceRemind:self.remindModel];
    [self showLoadingView];
}

- (void)deleteRemindButtonClick:(id)sender{
    [self showdeleteRemindAlert];
}

- (void)showdeleteRemindAlert
{
    RMActionController* deleteRemindAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    deleteRemindAlert.title = @"删除围栏提醒";
    deleteRemindAlert.titleColor = EH_cor5;
    deleteRemindAlert.titleFont = EH_font6;
    
    WEAKSELF
    RMAction *deleteRemindAction = [RMAction actionWithTitle:@"删除该提醒" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        //删除提醒
        STRONGSELF
        [strongSelf configDeleteRemindService];
        [_deleteRemindService deleteGeofenceRemind:self.remindModel.uuid];
        [strongSelf showLoadingView];
    }];
    
    deleteRemindAction.titleColor = EH_cor7;
    deleteRemindAction.titleFont = EH_font2;
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    [deleteRemindAlert addAction:deleteRemindAction];
    [deleteRemindAlert addAction:cancelAction];
    
    deleteRemindAlert.seperatorViewColor = EH_linecor1;
    
    deleteRemindAlert.contentView=[[UIView alloc]init];
    deleteRemindAlert.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:deleteRemindAlert.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [deleteRemindAlert.contentView addConstraint:heightConstraint];
    
    //You can enable or disable blur, bouncing and motion effects
    deleteRemindAlert.disableBouncingEffects = YES;
    deleteRemindAlert.disableMotionEffects = YES;
    deleteRemindAlert.disableBlurEffects = YES;
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:deleteRemindAlert animated:YES completion:nil];
}

- (UIButton *)deleteRemindButton{
    UIButton *deleteRemindButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50 - 20, CGRectGetWidth(self.view.frame), 50)];
    deleteRemindButton.backgroundColor = [UIColor whiteColor];
    [deleteRemindButton setTitle:@"删除该提醒" forState:UIControlStateNormal];
    deleteRemindButton.titleLabel.font = EH_font2;
    [deleteRemindButton setTitleColor:EH_cor7 forState:UIControlStateNormal];
    [deleteRemindButton addTarget:self action:@selector(deleteRemindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    deleteRemindButton.layer.borderWidth = 0.1;
    deleteRemindButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return deleteRemindButton;
}

- (void)configDeleteRemindService {
    if (!_deleteRemindService) {
        _deleteRemindService = [EHDeleteGeofenceRemindService new];
        WEAKSELF
        _deleteRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _deleteRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除失败"];
        };
    }
}

- (void)configUpdateRemindService {
    if (!_updateRemindService) {
        _updateRemindService = [EHUpdateGeofenceRemindService new];
        WEAKSELF
        _updateRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _updateRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
        };
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
