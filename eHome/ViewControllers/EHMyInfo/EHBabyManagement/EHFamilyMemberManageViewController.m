//
//  EHFamilyMemberManageViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyMemberManageViewController.h"
#import "EHDeleteBabyUserService.h"
#import "EHGetBabyAttentionUsersRsp.h"
#import "EHFamilyMemberTableViewCell.h"
#import "RMActionController.h"

@interface EHFamilyMemberManageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * _familyMemberTableView;
    
    EHDeleteBabyUserService* _deleteBabyUserService;
}

@property(nonatomic, strong)NSMutableDictionary * currentSecectMembers;


@end

@implementation EHFamilyMemberManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"移除家庭成员"];
    [self.view addSubview:[self familyMemberTableView]];
    
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnTapped:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    
    _currentSecectMembers = [NSMutableDictionary new];
    
}
- (UITableView *)familyMemberTableView;{
    if (!_familyMemberTableView) {
        _familyMemberTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _familyMemberTableView.rowHeight = 70;
        _familyMemberTableView.sectionFooterHeight = 0;
        _familyMemberTableView.dataSource = self;
        _familyMemberTableView.delegate = self;
        _familyMemberTableView.tableFooterView = [[UIView alloc] init];
    }
    return _familyMemberTableView;
}

#pragma mark - private function
- (void)confirmBtnTapped:(id)sender
{
    if (_currentSecectMembers.count == 0) {
        [WeAppToast toast:@"请选择您要移除的家庭成员"];
        return;
    }
    RMAction *transferAction = [RMAction actionWithTitle:@"移除家庭成员" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        [self deleteBabyUser];
    }];
    transferAction.titleColor = EH_cor7;
    transferAction.titleFont = EH_font2;
    
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    
    actionSheet.title = @"是否移除该家庭成员？";
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
- (void)deleteBabyUser
{
    if (!_deleteBabyUserService) {
        _deleteBabyUserService = [EHDeleteBabyUserService new];
        WEAKSELF
        _deleteBabyUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF

            if (strongSelf.deleteFamilyMemberSuccess) {
                strongSelf.deleteFamilyMemberSuccess();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        };
        _deleteBabyUserService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            
            NSDictionary* userInfo = error.userInfo;
            [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
        };
    }
    
    NSMutableArray* phoneList = [NSMutableArray new];
    for (NSString* userPhone in [_currentSecectMembers allValues]) {
        NSDictionary *dic = @{kEHUserPhone:userPhone};
        [phoneList addObject:dic];
    }
    [_deleteBabyUserService deleteUsers:phoneList ToAttentionBaby:self.babyId byAdmin:self.currentManager];
    
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
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHFamilyMemberTableViewCell *cell = nil;
    if ([_currentSecectMembers  objectForKey:indexPath]) {
        cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_normal"];
        
        [_currentSecectMembers removeObjectForKey:indexPath];
        
    }
    else
    {
        cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_press"];
        [_currentSecectMembers setObject:cell.phoneLabel.text forKey:indexPath];
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
