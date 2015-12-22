//
//  EHTransferManagerViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHTransferManagerViewController.h"
#import "EHFamilyMemberTableViewCell.h"
#import "EHGetBabyAttentionUsersRsp.h"
#import "EHTransferBabyManagerService.h"
#import "RMActionController.h"

@interface EHTransferManagerViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * _familyMemberTableView;

    EHTransferBabyManagerService* _transferManagerService;
}

@property(nonatomic, strong)NSIndexPath * currentSecectIndex;
@end

@implementation EHTransferManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"转让管理员"];
    [self.view addSubview:[self familyMemberTableView]];
    self.view.backgroundColor=EHBgcor1;
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnTapped:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    
}
- (UITableView *)familyMemberTableView;{
    if (!_familyMemberTableView) {
        _familyMemberTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _familyMemberTableView.rowHeight = 70;
        _familyMemberTableView.sectionFooterHeight = 0;
        _familyMemberTableView.dataSource = self;
        _familyMemberTableView.delegate = self;
        _familyMemberTableView.backgroundColor=EHBgcor1;
        _familyMemberTableView.tableFooterView = [[UIView alloc] init];
    }
    return _familyMemberTableView;
}

#pragma mark - private function
- (void)confirmBtnTapped:(id)sender
{
    if (_currentSecectIndex == nil)
    {
        [WeAppToast toast:@"请选择家庭成员"];
        return;
    }
    
    RMAction *transferAction = [RMAction actionWithTitle:@"转让管理员权限" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        [self transferManager];
    }];
    transferAction.titleColor = EH_cor7;
    transferAction.titleFont = EH_font2;
    
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    
    actionSheet.title = @"是否将管理员权限转让给该成员？";
    actionSheet.titleColor = EH_cor5;
    actionSheet.titleFont = EH_font6;
    
    actionSheet.seperatorViewColor = EH_linecor1;
    
    [actionSheet addAction:transferAction];
    [actionSheet addAction:cancelAction];
    
    actionSheet.contentView=[[UIView alloc]init];
    actionSheet.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:actionSheet.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [actionSheet.contentView addConstraint:heightConstraint];
    
    actionSheet.disableBlurEffects=YES;
    actionSheet.disableBouncingEffects = YES;
    actionSheet.disableMotionEffects = YES;
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)transferManager
{
    if (!_transferManagerService) {
        _transferManagerService = [EHTransferBabyManagerService new];
        WEAKSELF
        _transferManagerService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[strongSelf.familyMemberList objectAtIndex:strongSelf.currentSecectIndex.row];
            if (strongSelf.transferManagerSuccess) {
                strongSelf.transferManagerSuccess(attentionUser.user.user_phone);
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyInfoChangedNotification object:nil];
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        };
        _transferManagerService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){

            NSDictionary* userInfo = error.userInfo;
            [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
        };
    }
    
    EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[self.familyMemberList objectAtIndex:_currentSecectIndex.row];
    [_transferManagerService transferManagerTo:attentionUser.user.user_phone byBabyId:self.babyId from:self.currentManager];

}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // -1 for current manager
    return self.familyMemberList.count;
}


static NSString *familyMemberCellID = @"familyMemberCellID";
static BOOL bFamilyMemberCellRegistered = NO;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!bFamilyMemberCellRegistered) {
        UINib *nib = [UINib nibWithNibName:@"EHFamilyMemberTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:familyMemberCellID];
        bFamilyMemberCellRegistered = YES;
    }
    
    EHFamilyMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:familyMemberCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHFamilyMemberTableViewCell class]) owner:self options:nil] firstObject];
    }
    
    
    EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[self.familyMemberList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@的%@", self.babyName, [attentionUser relationship] ];
    
    cell.phoneLabel.text = attentionUser.user.user_phone;
    
    cell.headImageView.image = [UIImage imageNamed:@"headportrait_80"];
    
    cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_normal"];
    cell.checkImageView.hidden = NO;
  
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHFamilyMemberTableViewCell *cell = nil;
    if (_currentSecectIndex) {
        cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:_currentSecectIndex];
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_normal"];
    }

    _currentSecectIndex = indexPath;
    
    cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.checkImageView.image = [UIImage imageNamed:@"btn_radiobutton_press"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}


@end
