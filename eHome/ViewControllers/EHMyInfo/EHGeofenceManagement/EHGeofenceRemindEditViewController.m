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
#import "UIViewController+BackButtonHandler.h"

@interface EHGeofenceRemindEditViewController ()

@end

@implementation EHGeofenceRemindEditViewController
{
    EHDeleteGeofenceRemindService *_deleteRemindService;
    EHUpdateGeofenceRemindService *_updateRemindService;
    EHGeofenceRemindModel *_copyModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _copyModel = [self.remindModel copy];
}

-(BOOL)navigationShouldPopOnBackButton {
    [self resetRemindModel];
    return YES;
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

- (void)configDeleteRemindService {
    if (!_deleteRemindService) {
        _deleteRemindService = [EHDeleteGeofenceRemindService new];
        WEAKSELF
        _deleteRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除成功"];

            [strongSelf.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                !strongSelf.remindNeedDelete?:strongSelf.remindNeedDelete(strongSelf.remindModel);
            });

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
            !strongSelf.remindNeedUpdate?:strongSelf.remindNeedUpdate(strongSelf.remindModel);

            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _updateRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf resetRemindModel];
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
        };
    }
}

- (void)resetRemindModel {
    self.remindModel.geofence_id = _copyModel.geofence_id;
    self.remindModel.geofence_baby_id = _copyModel.geofence_baby_id;
    self.remindModel.time = _copyModel.time;
    self.remindModel.work_date = _copyModel.work_date;
    self.remindModel.is_active = _copyModel.is_active;
    self.remindModel.is_repeat = _copyModel.is_repeat;
    self.remindModel.uuid = _copyModel.uuid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
