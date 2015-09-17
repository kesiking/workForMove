//
//  EHFamilyMemberViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyMemberViewController.h"
#import "EHGetBabyAttentionUsersRsp.h"
#import "EHFamilyMemberTableViewCell.h"
#import "EHTransferManagerViewController.h"
#import "EHGetBabyAttentionUsersService.h"
#import "EHFamilyMemberManageViewController.h"
#import "EHNewApplyFamilyMemberTableViewCell.h"
#import "EHNewApplyFamilyMemberViewController.h"
#import "EHFamilyMemberFirstSectionTableViewCell.h"
#import "EHGetBabyManagerIsReadMsgService.h"

@interface EHFamilyMemberViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    EHGetBabyAttentionUsersService* _getBabyAttentionUsersService;
    EHGetBabyManagerIsReadMsgService *_getBabyManagerIsReadMsgService;
}
@property(nonatomic, strong)   UITableView* familyMemberTableView;
@property( nonatomic, strong)NSArray* familyMemberList;
@property(nonatomic, assign)BOOL bFamilyMemberDidChanged;
@property(nonatomic,assign) BOOL redPointIsShow;
@end

@implementation EHFamilyMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@的家庭成员", self.babyName];
    [self.view addSubview:[self familyMemberTableView]];
    
    
    self.bFamilyMemberDidChanged = NO;
    self.redPointIsShow=NO;
    [self updateFamilyMemberList];
    [self getBabyManagerIsReadMsg];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.familyMemberDidChanged) {
        self.familyMemberDidChanged(self.bFamilyMemberDidChanged);
    }
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
- (void)moreBtnTapped:(id)sender
{
    [EHPopMenuLIstView showMenuViewWithTitleTextArray:@[@"转让管理员", @"移除家庭成员"] menuSelectedBlock:^(NSUInteger index, EHPopMenuModel *selectItem) {
        NSLog(@"index = %ld",index);
        if (index == 0) {
            [self showTransferManagerView];
        }
        else if (index == 1)
        {
            [self showFamilyMemberMangeView];
        }
        
    }];
}

- (void)showTransferManagerView
{
    EHTransferManagerViewController * transferManagerVC = [[EHTransferManagerViewController alloc] init];
    transferManagerVC.babyId = self.babyId;
    transferManagerVC.babyName = self.babyName;
    NSMutableArray * familyMemberExcludeManager = [NSMutableArray new];
    [self.familyMemberList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![EHUtils isAuthority:[(EHBabyAttentionUser*)obj authority]]) {
            [familyMemberExcludeManager addObject:obj];
        }
        else
        {
            transferManagerVC.currentManager = [[(EHBabyAttentionUser*)obj user] user_phone];
        }
        
    }];
    transferManagerVC.familyMemberList = familyMemberExcludeManager;
    transferManagerVC.transferManagerSuccess = ^(NSString *selectedManager){
        [self updateFamilyMemberList];
        self.navigationItem.rightBarButtonItem = nil;
        self.authority=@"0";
        //self.bFamilyMemberDidChanged = YES;
    };
    [self.navigationController pushViewController:transferManagerVC animated:YES];
}

- (void)showFamilyMemberMangeView
{
    EHFamilyMemberManageViewController * familyMemberManageVC = [[EHFamilyMemberManageViewController alloc] init];
    familyMemberManageVC.babyId = self.babyId;
    familyMemberManageVC.babyName = self.babyName;
    NSMutableArray * familyMemberExcludeManager = [NSMutableArray new];
    [self.familyMemberList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![EHUtils isAuthority:[(EHBabyAttentionUser*)obj authority]]) {
            [familyMemberExcludeManager addObject:obj];
        }
        else
        {
            familyMemberManageVC.currentManager = [[(EHBabyAttentionUser*)obj user] user_phone];
        }
        
    }];
    familyMemberManageVC.familyMemberList = familyMemberExcludeManager;
    familyMemberManageVC.deleteFamilyMemberSuccess = ^(){
        [self updateFamilyMemberList];
        self.bFamilyMemberDidChanged = YES;
    };
    [self.navigationController pushViewController:familyMemberManageVC animated:YES];
}

- (void)updateFamilyMemberList
{
    _getBabyAttentionUsersService = [EHGetBabyAttentionUsersService new];
    
    WEAKSELF
    _getBabyAttentionUsersService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getBabyAttentionUsers完成！");
        STRONGSELF
        
        if (service.item) {
            EHLogInfo(@"%@",service.item);
            strongSelf.familyMemberList = [(EHGetBabyAttentionUsersRsp*)service.item user] ;
            
            if (strongSelf.familyMemberList.count > 1 && [EHUtils isAuthority:strongSelf.authority]) {
                UIBarButtonItem* moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:strongSelf action:@selector(moreBtnTapped:)];
                strongSelf.navigationItem.rightBarButtonItem = moreBtn;
            }
            
            [strongSelf.familyMemberTableView reloadData];
            
        }
        
        
        
    };
    _getBabyAttentionUsersService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        EHLogError(@"getBabyAttentionUserfailed！");
        
    };
    
    [_getBabyAttentionUsersService getThisBabyAllAttentionUsers:self.babyId];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([EHUtils isAuthority:self.authority]){
        if(section==0){
            return 1;
        }else{
            return self.familyMemberList.count;
        }

    }
    
    return self.familyMemberList.count;

}


static NSString *familyMemberCellID = @"familyMemberCellID";
static NSString *firseSectionFamilyMemberCellID=@"firseSectionFamilyMemberCellID";
static BOOL bFamilyMemberCellRegistered = NO;
static BOOL kEHFamilyMemberFirstSectionCellRegistered=NO;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if([EHUtils isAuthority:self.authority]){

            if(indexPath.section==0){
                if(!kEHFamilyMemberFirstSectionCellRegistered){
                    UINib *nib=[UINib nibWithNibName:@"EHFamilyMemberFirstSectionTableViewCell" bundle:nil];
                    kEHFamilyMemberFirstSectionCellRegistered=YES;
                    [tableView registerNib:nib forCellReuseIdentifier:firseSectionFamilyMemberCellID];
                }

                EHFamilyMemberFirstSectionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:firseSectionFamilyMemberCellID ];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHFamilyMemberFirstSectionTableViewCell class]) owner:self options:nil] firstObject];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                //   [cell.textField setText:@"新申请的成员"];
                [cell.headImageView setImage:[UIImage imageNamed:@"headportrait_80"]];

                if (self.redPointIsShow) {
                    [cell.rePointImageView setImage:[UIImage imageNamed:@"public_ico_tbar_message_propmpt"]];
                }

                return cell;
            }
        }
        if (!bFamilyMemberCellRegistered) {
            UINib *nib = [UINib nibWithNibName:@"EHFamilyMemberTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:familyMemberCellID];
            bFamilyMemberCellRegistered = YES;
        }
        
        EHFamilyMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:familyMemberCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHFamilyMemberTableViewCell class]) owner:self options:nil] firstObject];
        }
        
        [cell.phoneLabel setHidden:NO];
        EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[self.familyMemberList objectAtIndex:indexPath.row];
//        if ([attentionUser.user.user_phone isEqualToString:[KSAuthenticationCenter userPhone]]) {
//            cell.nameLabel.text = [NSString stringWithFormat:@"%@的%@(我)", self.babyName, [attentionUser relationship] ];
//        }
//        else
//        {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@（%@的%@）",attentionUser.user.nick_name, self.babyName, [attentionUser relationship] ];
    //    }
        
        
        cell.phoneLabel.text = attentionUser.user.user_phone;
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:attentionUser.user.user_head_img_small] placeholderImage:[EHUtils getUserHeadPlaceHolderImage:attentionUser.user.user_id newPlaceHolderImagePath:attentionUser.user.user_head_img_small defaultHeadImage:[UIImage imageNamed:@"headportrait_80"]]];
          
        if ([EHUtils isAuthority:attentionUser.authority]) {
            cell.checkImageView.image = [UIImage imageNamed:@"ico_administrator"];
        }
        else{
            cell.checkImageView.image = nil;
        }
        return cell;

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([EHUtils isAuthority:self.authority]){
        return 2;
    }
    
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([EHUtils isAuthority:self.authority]){
        if(indexPath.section==0){
            EHNewApplyFamilyMemberViewController *newApplyFamilyMember=[[EHNewApplyFamilyMemberViewController alloc]init];
            newApplyFamilyMember.baby_Id=self.babyId;
            newApplyFamilyMember.redPointIsShow=^(BOOL isShow){
                self.redPointIsShow=isShow;
                [self.familyMemberTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                //[self getBabyManagerIsReadMsg];
            };
            newApplyFamilyMember.bindingBabySuccess=^{
                [self updateFamilyMemberList];
            };
            
            [self.navigationController pushViewController:newApplyFamilyMember animated:YES];
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getBabyManagerIsReadMsg{
    
    _getBabyManagerIsReadMsgService=[EHGetBabyManagerIsReadMsgService new];
    
    WEAKSELF
    _getBabyManagerIsReadMsgService.serviceDidFinishLoadBlock=^(WeAppBasicService *service){
        STRONGSELF
        EHLogInfo(@"getBabyManagerIsReadMsgService respond success:%@",service);
        strongSelf.redPointIsShow=[service.numberValue boolValue];
        EHLogInfo(@"redPointShow %@",strongSelf.redPointIsShow?@"YES":@"NO");
        
        [strongSelf.familyMemberTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    };
  
    _getBabyManagerIsReadMsgService.serviceDidFailLoadBlock=^(WeAppBasicService *servic,NSError *error){
        
        EHLogError(@"getBabyManagerIsReadMsgService error");
    };
    
    [_getBabyManagerIsReadMsgService getBabyManagerIsReadMsgService:[KSAuthenticationCenter userPhone] ];
    
    
    

}


@end
