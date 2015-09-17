//
//  EHEditBabyAlarmViewController.m
//  eHome
//
//  Created by jinmiao on 15/9/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHEditBabyAlarmViewController.h"
#import "EHEditBabyAlarmService.h"
#import "EHDelBabyAlarmService.h"
#import "RMActionController.h"



@interface EHEditBabyAlarmViewController ()

@end

@implementation EHEditBabyAlarmViewController
{
    EHEditBabyAlarmService *_editBabyAlarmService;
    EHDelBabyAlarmService *_delBabyAlarmService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self deleteRemindButton]];
}

#pragma mark - Events Response
- (void)doneBtnClicked {
    if ([self.alarmModel.work_date isEqualToString:@"0000000"]) {
        [WeAppToast toast:@"请选择日期"];
        return;
        
    }
    self.editBlock(self.alarmModel);
    [self configUpdateAlarmService];
    [_editBabyAlarmService editBabyAlarm:self.alarmModel];
    [self showLoadingView];
}

- (void)deleteAlarmButtonClicked:(id)sender{
    [self showdeleteRemindAlert];
}

- (void)showdeleteRemindAlert
{
    RMActionController* deleteRemindAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    deleteRemindAlert.title = @"删除宝贝闹钟提醒";
    deleteRemindAlert.titleColor = EH_cor5;
    deleteRemindAlert.titleFont = EH_font6;
    
    NSString *phone = [[KSLoginComponentItem sharedInstance] user_phone];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *alarmListDict = @{kEHBabyAlarmId:self.alarmModel.uuid};
    [arr addObject:alarmListDict];


    
    WEAKSELF
    RMAction *deleteRemindAction = [RMAction actionWithTitle:@"删除该提醒" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        //删除提醒
        STRONGSELF
        strongSelf.deleteBlock(strongSelf.alarmModel);
        [strongSelf configDeleteAlarmService];
        [_delBabyAlarmService delBabyAlarm:arr byBabyId:strongSelf.babyUser.babyId andAdminPhone:phone];
        //[strongSelf showLoadingView];

//        [strongSelf.navigationController popViewControllerAnimated:YES];
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
    [deleteRemindButton addTarget:self action:@selector(deleteAlarmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleteRemindButton.layer.borderWidth = 0.1;
    deleteRemindButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return deleteRemindButton;
}

- (void)configDeleteAlarmService {
    if (!_delBabyAlarmService) {
        _delBabyAlarmService = [EHDelBabyAlarmService new];
        WEAKSELF
        _delBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _delBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除失败"];
        };
    }
}

- (void)configUpdateAlarmService {
    if (!_editBabyAlarmService) {
        _editBabyAlarmService = [EHEditBabyAlarmService new];
        WEAKSELF
        _editBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _editBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
        };
    }
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
