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
#import "RMActionController.h"
#import "EHTransferBabyManagerService.h"
#import "EHDeleteBabyUserService.h"
#import "NSString+StringSize.h"
#import "GroupedTableView.h"



#define IMAGEWIDTH 60

@interface EHFamilyMemberViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    EHGetBabyAttentionUsersService* _getBabyAttentionUsersService;
    EHGetBabyManagerIsReadMsgService *_getBabyManagerIsReadMsgService;
    EHTransferBabyManagerService* _transferManagerService;
    EHDeleteBabyUserService* _deleteBabyUserService;
    UIImageView *_topView;
    UIImageView *_headImageView;
    UILabel *_familyNumber;
    UILabel *_nameLable;
    UILabel *_phoneLable;
    UILabel *_authorityLabel;
    
}
@property(nonatomic, strong)   UITableView* familyMemberTableView;
@property( nonatomic, strong)NSArray* familyMemberList;
@property(nonatomic, assign)BOOL bFamilyMemberDidChanged;
@property(nonatomic, assign) BOOL redPointIsShow;

@property(nonatomic, assign) BOOL isTransferManager;
@property(nonatomic, assign) BOOL isDeleteFamilyMember;
@property(nonatomic, strong)NSIndexPath * currentSecectIndex;
@property(nonatomic, strong)NSString* currentManager;
@property(nonatomic, strong)NSMutableDictionary * currentSecectMembers;
@property(nonatomic, strong)NSString* relationship;
@property(nonatomic, strong)NSString* imageUrl;
@property(nonatomic, strong)NSString* numberString;


@end

@implementation EHFamilyMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@的家庭成员", self.babyName];
    if ([EHUtils isAuthority:self.authority]) {
        [self topView];
    }
    [self familyMemberTableView];
    self.view.backgroundColor=self.familyMemberTableView.backgroundColor;
    
    self.bFamilyMemberDidChanged = NO;
    self.redPointIsShow=NO;
    self.isTransferManager=NO;
    self.isDeleteFamilyMember=NO;
    [self updateFamilyMemberList];
    [self getBabyManagerIsReadMsg];
    _currentSecectMembers = [NSMutableDictionary new];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.familyMemberDidChanged) {
        self.familyMemberDidChanged(self.bFamilyMemberDidChanged);
    }
}


-(void)viewWillAppear:(BOOL)animated{
    if ([EHUtils isAuthority:self.authority]) {
        [self setHeadImage];
    }
}


-(void)topView{
    _topView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_family" ]];
    // _topView.frame = CGRectMake(8, 12, CGRectGetWidth(self.view.frame)-2*8, (CGRectGetWidth(self.view.frame)-2*8) * CGRectGetHeight(_topView.frame) / CGRectGetWidth(_topView.frame));
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(8*SCREEN_SCALE);
        make.top.equalTo(self.view.mas_top).with.offset(12*SCREEN_SCALE);
        make.right.equalTo(self.view.mas_right).with.offset(-8*SCREEN_SCALE);
        make.height.mas_equalTo((CGRectGetWidth(self.view.frame)-16)*CGRectGetHeight(_topView.frame) / CGRectGetWidth(_topView.frame));
    }];

    
    
    CGFloat labelHeightsize5 = [@"text" sizeWithFontSize:EH_siz5 Width:CGRectGetWidth(_topView.frame)].height;
    UIImageView *horizentalImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_family_font"]];
    NSString *number=@"0位家庭成员";
    CGSize theStringSize =[number sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:EH_siz5]}];
    NSString *authority=@"管理员";
    CGSize auStringSize =[authority sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:EH_siz5]}];
    [_topView addSubview:horizentalImageView];
    [horizentalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView.mas_centerX);
        make.centerY.equalTo(_topView.mas_top).with.offset(23+IMAGEWIDTH/2);
        make.width.mas_equalTo(theStringSize.width+9+IMAGEWIDTH+18+labelHeightsize5+5+auStringSize.width+28);
        make.height.mas_equalTo(labelHeightsize5+15);
    }];

    
    _headImageView=[[UIImageView alloc]init];
    _headImageView.layer.cornerRadius = IMAGEWIDTH/2.0;
    _headImageView.layer.masksToBounds = YES;
    [_topView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_topView).with.offset(23*SCREEN_SCALE);
        make.width.mas_equalTo(IMAGEWIDTH);
        make.height.mas_equalTo(IMAGEWIDTH);
    }];
    

    _familyNumber=[[UILabel alloc]init];
    [_topView addSubview:_familyNumber];
    _familyNumber.text=number;
    _familyNumber.textColor=EH_cor1;
    _familyNumber.font=[UIFont systemFontOfSize:EH_siz5];
    [_familyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizentalImageView.mas_top).with.offset(7.5*SCREEN_SCALE);
        make.right.equalTo(_headImageView.mas_left).with.offset(-9*SCREEN_SCALE);
        make.width.mas_equalTo(theStringSize.width);
        make.height.mas_equalTo(labelHeightsize5);
    }];
    
   
    UIImageView *lockView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_family_lock"]];
    [_topView addSubview:lockView];
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizentalImageView.mas_top).with.offset(8.5*SCREEN_SCALE);
        make.left.equalTo(_headImageView.mas_right).with.offset(18*SCREEN_SCALE);
        make.width.mas_equalTo(labelHeightsize5-1);
        make.height.mas_equalTo(labelHeightsize5-1);
    }];
    

    _authorityLabel=[[UILabel alloc]init];
    _authorityLabel.text=authority;
    _authorityLabel.textColor=EH_cor1;
    _authorityLabel.font=[UIFont systemFontOfSize:EH_siz5];
    [_topView addSubview:_authorityLabel];
    [_authorityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizentalImageView.mas_top).with.offset(7.5*SCREEN_SCALE);
        make.left.equalTo(lockView.mas_right).with.offset(5*SCREEN_SCALE);
        make.width.mas_equalTo(auStringSize);
        make.height.mas_equalTo(auStringSize);
    }];

    
   
    CGFloat labelHeight = [@"text" sizeWithFontSize:EH_siz2 Width:CGRectGetWidth(_topView.frame)].height;
    _nameLable=[[UILabel alloc]init];
    _nameLable.text=[NSString stringWithFormat:@"%@的%@(我)", self.babyName,@"家人" ];
    
    
    _nameLable.font= [UIFont systemFontOfSize:EH_siz2];
    _nameLable.textColor=EH_cor1;
    _nameLable.textAlignment=NSTextAlignmentCenter;
    [_topView addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).with.offset(10*SCREEN_SCALE);
        make.left.equalTo(_topView.mas_left);
        make.centerX.equalTo(_topView.mas_centerX);
        make.height.mas_equalTo(labelHeight);
    }];
    
    
    _phoneLable=[[UILabel alloc]init];
    _phoneLable.text=[KSAuthenticationCenter userPhone];
    _phoneLable.textColor=EH_cor1;
    _phoneLable.font=[UIFont systemFontOfSize:EH_siz5];
    _phoneLable.textAlignment=NSTextAlignmentCenter;
    [_topView addSubview:_phoneLable];
    [_phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).with.offset(8*SCREEN_SCALE);
        make.left.equalTo(_topView.mas_left);
        make.centerX.equalTo(_topView.mas_centerX);
        make.height.mas_equalTo(labelHeightsize5);
    }];
}


//设置头像
- (void)setHeadImage{
    NSURL *imageUrl = [NSURL URLWithString:[KSLoginComponentItem sharedInstance].user_head_img];
    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getUserHeadPlaceHolderImage:[NSNumber numberWithInteger:[[KSLoginComponentItem sharedInstance].userId integerValue]] newPlaceHolderImagePath:[KSLoginComponentItem sharedInstance].user_head_img defaultHeadImage:[UIImage imageNamed:@"headportrait_home_150"]] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}



- (UITableView *)familyMemberTableView{
    if (!_familyMemberTableView) {
     //   _familyMemberTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topView.frame)+12,CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.view.frame)-CGRectGetHeight(_topView.frame)) style:UITableViewStyleGrouped];
        _familyMemberTableView=[[GroupedTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _familyMemberTableView.rowHeight = 61;
        _familyMemberTableView.sectionFooterHeight = 0;
        _familyMemberTableView.dataSource = self;
        _familyMemberTableView.delegate = self;
        _familyMemberTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_familyMemberTableView];
        if ([EHUtils isAuthority:self.authority]) {
            [_familyMemberTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom);
                make.left.equalTo(_topView.mas_left);
                make.right.equalTo(_topView.mas_right);
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }
        else{
            [_familyMemberTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top);
                make.left.equalTo(self.view.mas_left).with.offset(8*SCREEN_SCALE);
                make.right.equalTo(self.view.mas_right).with.offset(-8*SCREEN_SCALE);
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }
    }
    return _familyMemberTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

#pragma mark - private function
- (void)moreBtnTapped:(id)sender
{
    [EHPopMenuLIstView showMenuViewWithTitleTextArray:@[@"转让管理员", @"移除家庭成员"] menuSelectedBlock:^(NSUInteger index, EHPopMenuModel *selectItem) {
        NSLog(@"index = %ld",index);
        if (index == 0) {
            self.isTransferManager=YES;
            [self showTransferManagerView];
        }
        else if (index == 1)
        {
            self.isDeleteFamilyMember=YES;
            [self showFamilyMemberMangeView];
        }
        UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnTapped:)];
        self.navigationItem.rightBarButtonItem = confirmBtn;
        
    }];
}


- (void)showTransferManagerView
{
//    EHTransferManagerViewController * transferManagerVC = [[EHTransferManagerViewController alloc] init];
//    transferManagerVC.babyId = self.babyId;
//    transferManagerVC.babyName = self.babyName;
    NSMutableArray * familyMemberExcludeManager = [NSMutableArray new];
    [self.familyMemberList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![EHUtils isAuthority:[(EHBabyAttentionUser*)obj authority]]) {
            [familyMemberExcludeManager addObject:obj];
        }
        else
        {
            self.currentManager = [[(EHBabyAttentionUser*)obj user] user_phone];
        }
        
    }];
    self.familyMemberList=familyMemberExcludeManager;
    [self.familyMemberTableView reloadData];
    
//    transferManagerVC.familyMemberList = familyMemberExcludeManager;
//    transferManagerVC.transferManagerSuccess = ^(NSString *selectedManager){
//        [self updateFamilyMemberList];
//        self.navigationItem.rightBarButtonItem = nil;
//        self.authority=@"0";
//        //self.bFamilyMemberDidChanged = YES;
//    };
//    [self.navigationController pushViewController:transferManagerVC animated:YES];
}

- (void)showFamilyMemberMangeView
{
//    EHFamilyMemberManageViewController * familyMemberManageVC = [[EHFamilyMemberManageViewController alloc] init];
//    familyMemberManageVC.babyId = self.babyId;
//    familyMemberManageVC.babyName = self.babyName;
    NSMutableArray * familyMemberExcludeManager = [NSMutableArray new];
    [self.familyMemberList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![EHUtils isAuthority:[(EHBabyAttentionUser*)obj authority]]) {
            [familyMemberExcludeManager addObject:obj];
        }
        else
        {
            self.currentManager = [[(EHBabyAttentionUser*)obj user] user_phone];
        }
        
    }];
    self.familyMemberList=familyMemberExcludeManager;
    [self.familyMemberTableView reloadData];
    
//    familyMemberManageVC.familyMemberList = familyMemberExcludeManager;
//    familyMemberManageVC.deleteFamilyMemberSuccess = ^(){
//        [self updateFamilyMemberList];
//        self.bFamilyMemberDidChanged = YES;
//    };
//    [self.navigationController pushViewController:familyMemberManageVC animated:YES];
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
            
            [strongSelf reSetFamilyNumber];
            [strongSelf.familyMemberTableView reloadData];
        }
        
    };
    _getBabyAttentionUsersService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        EHLogError(@"getBabyAttentionUserfailed！");
        
    };
    
    [_getBabyAttentionUsersService getThisBabyAllAttentionUsers:self.babyId];
}



-(void)reSetFamilyNumber{
    if ([EHUtils isAuthority:self.authority]) {
        self.numberString=[NSString stringWithFormat:@"%ld位家庭成员",self.familyMemberList.count];
        _familyNumber.text=self.numberString;
        for (int i=0; i<_familyMemberList.count; i++) {
            EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[self.familyMemberList objectAtIndex:i];
            if ([attentionUser.user.user_phone isEqualToString:[KSAuthenticationCenter userPhone]]) {
                self.relationship = [NSString stringWithFormat:@"%@的%@(我)", self.babyName, [attentionUser relationship] ];
                break;
            }
        }
        _nameLable.text=self.relationship;
        [self viewDidLayoutSubviews];

    }else{
        [_topView removeFromSuperview];
       // [_topView setHeight:0];
      //  [_familyMemberTableView updateConstraints];
        [_familyMemberTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(12*SCREEN_SCALE);
            make.left.equalTo(self.view.mas_left).with.offset(8*SCREEN_SCALE);
            make.right.equalTo(self.view.mas_right).with.offset(-8*SCREEN_SCALE);
            make.bottom.equalTo(self.view.mas_bottom);
            
        }];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([EHUtils isAuthority:self.authority]) {
        if (section==0) {
            return 1;
        }
    }
    return self.familyMemberList.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([EHUtils isAuthority:self.authority]) {
        if(indexPath.section==0){
            return 44;
        }
    }
    return 61;
}


static NSString *familyMemberCellID = @"familyMemberCellID";
static NSString *firseSectionFamilyMemberCellID=@"firseSectionFamilyMemberCellID";
static BOOL bFamilyMemberCellRegistered = NO;
static BOOL kEHFamilyMemberFirstSectionCellRegistered=NO;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([EHUtils isAuthority:self.authority]) {
        if(indexPath.section==0){
            if(!kEHFamilyMemberFirstSectionCellRegistered){
                UINib *nib=[UINib nibWithNibName:@"EHFamilyMemberFirstSectionTableViewCell" bundle:nil];
                kEHFamilyMemberFirstSectionCellRegistered=YES;
                [tableView registerNib:nib forCellReuseIdentifier:firseSectionFamilyMemberCellID];
            }
            
            EHFamilyMemberFirstSectionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:firseSectionFamilyMemberCellID ];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHFamilyMemberFirstSectionTableViewCell class]) owner:self options:nil] firstObject];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            [cell.headImageView setImage:[UIImage imageNamed:@"icon_family_newmember"]];
            
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
//            self.relationship=[attentionUser relationship];
//        }
//        else
//        {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@的%@",self.babyName, [attentionUser relationship] ];
  //      }
        
        
        cell.phoneLabel.text = attentionUser.user.user_phone;
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:attentionUser.user.user_head_img_small] placeholderImage:[EHUtils getUserHeadPlaceHolderImage:attentionUser.user.user_id newPlaceHolderImagePath:attentionUser.user.user_head_img_small defaultHeadImage:[UIImage imageNamed:@"headportrait_80"]]];
    
    if (self.isTransferManager) {
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_normal"];
        cell.checkImageView.hidden = NO;

    }else if(self.isDeleteFamilyMember){
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_normal"];
    }else{
        if ([EHUtils isAuthority:attentionUser.authority]) {
            cell.checkImageView.image = [UIImage imageNamed:@"ico_administrator"];
        }
        else{
            cell.checkImageView.image = nil;
        }

    }
        return cell;

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([EHUtils isAuthority:self.authority]) {
        return 2;
    }
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([EHUtils isAuthority:self.authority]) {
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
        
        
        
        EHFamilyMemberTableViewCell *cell = nil;
        if (self.isTransferManager) {
            if (_currentSecectIndex) {
                cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:_currentSecectIndex];
                cell.checkImageView.image = [UIImage imageNamed:@"public_radiobox_set_off"];
            }
            
            _currentSecectIndex = indexPath;
            
            cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.checkImageView.image = [UIImage imageNamed:@"btn_radiobutton_press"];
        }
        
        
        if (self.isDeleteFamilyMember) {
            if ([_currentSecectMembers  objectForKey:indexPath]) {
                cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.checkImageView.image = [UIImage imageNamed:@"public_radiobox_set_off"];
                
                [_currentSecectMembers removeObjectForKey:indexPath];
                
            }
            else
            {
                cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.checkImageView.image = [UIImage imageNamed:@"public_radiobox_set_on"];
                [_currentSecectMembers setObject:cell.phoneLabel.text forKey:indexPath];
            }
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


#pragma mark - private function
- (void)confirmBtnTapped:(id)sender
{
    RMAction *transferAction;
    if (self.isTransferManager) {
        if (_currentSecectIndex == nil)
        {
            [WeAppToast toast:@"请选择家庭成员"];
            return;
        }
        
        transferAction = [RMAction actionWithTitle:@"转让管理员权限" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
            [self transferManager];
        }];
    }else if(self.isDeleteFamilyMember){
        if (_currentSecectMembers.count == 0) {
            [WeAppToast toast:@"请选择您要移除的家庭成员"];
            return;
        }
        transferAction = [RMAction actionWithTitle:@"移除家庭成员" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
            [self deleteBabyUser];
        }];
    }
    transferAction.titleColor = EH_cor7;
    transferAction.titleFont = EH_font2;
    
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    if (self.isTransferManager) {
        actionSheet.title = @"是否将管理员权限转让给该成员？";
    }else if(self.isDeleteFamilyMember){
        actionSheet.title = @"是否移除该家庭成员？";
    }
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
            [strongSelf updateFamilyMemberList];
            strongSelf.authority=@"0";
            strongSelf.isTransferManager=NO;
            strongSelf.navigationItem.rightBarButtonItem = nil;
        };
        _transferManagerService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            
            NSDictionary* userInfo = error.userInfo;
            [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
        };
    }
    
    EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[self.familyMemberList objectAtIndex:_currentSecectIndex.row];
    [_transferManagerService transferManagerTo:attentionUser.user.user_phone byBabyId:self.babyId from:[KSAuthenticationCenter userPhone]];
    
}



- (void)deleteBabyUser
{
    if (!_deleteBabyUserService) {
        _deleteBabyUserService = [EHDeleteBabyUserService new];
        WEAKSELF
        _deleteBabyUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf updateFamilyMemberList];
            strongSelf.bFamilyMemberDidChanged = YES;
            strongSelf.isDeleteFamilyMember=NO;
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


@end
