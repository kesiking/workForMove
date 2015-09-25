//
//  EHNewApplyFamileMemberViewController.m
//  eHome
//
//  Created by jss on 15/8/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHNewApplyFamilyMemberViewController.h"
#import "EHGetBabyBindingStatusListService.h"
#import "EHNewApplyFamilyMemberTableViewCell.h"
#import "EHCheckBabyIsAgreeService.h"
#import "GroupedTableView.h"

@interface EHNewApplyFamilyMemberViewController ()<UITableViewDataSource,UITableViewDelegate>{
    EHGetBabyBindingStatusListService *getBabyBindingStatusListService;
    EHCheckBabyIsAgreeService *checkBabyIsAgreeService;
}

@property (nonatomic,strong) UITableView * newfamilyMemberTableView;

@end




@implementation EHNewApplyFamilyMemberViewController
@synthesize newfamilyMemberList;

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.baby_Id = [nativeParams objectForKey:@"babyId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新申请的成员";
    [self.view addSubview:[self newApplyFamilyMemberTableView]];
    self.view.backgroundColor=_newfamilyMemberTableView.backgroundColor;
    if (self.redPointIsShow) {
        self.redPointIsShow(NO);
    }
    [self getBabyBindingStatus];
}




-(UITableView *)newApplyFamilyMemberTableView{
    if (!_newfamilyMemberTableView) {
        _newfamilyMemberTableView=[[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame)-16, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _newfamilyMemberTableView.rowHeight=61;
        _newfamilyMemberTableView.sectionFooterHeight=0;
        _newfamilyMemberTableView.dataSource=self;
        _newfamilyMemberTableView.delegate=self;
        _newfamilyMemberTableView.tableFooterView=[[UIView alloc]init];
    }
    return _newfamilyMemberTableView;
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.newfamilyMemberList.count;
}

static NSString *cellIdentifier=@"babyBindingStatusListCellID";
static BOOL babyBindingStatusListRegistered=NO;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHNewApplyFamilyMemberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!babyBindingStatusListRegistered){
        UINib *nib=[UINib nibWithNibName:@"EHNewApplyFamilyMemberTableViewCell" bundle:nil];
        [_newfamilyMemberTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        babyBindingStatusListRegistered=YES;
    }
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHNewApplyFamilyMemberTableViewCell class]) owner:self options:nil] firstObject];
    }
    
    EHBabyBindingStatusListRsp *babyBindindStatusItem=[EHBabyBindingStatusListRsp new];
    babyBindindStatusItem=[self.newfamilyMemberList objectAtIndex:indexPath.row];
    cell.agreeBtnClickBlock=^{
        [self agreeBinding:babyBindindStatusItem.baby_id user_phone:babyBindindStatusItem.user_phone baby_nickname:@"" relationship:babyBindindStatusItem.relationship tableViewindexPath:indexPath];
        
    };
    cell.titleLabel.text=babyBindindStatusItem.nick_name;
    cell.phoneLabel.text=babyBindindStatusItem.user_phone;
    if ([babyBindindStatusItem.baby_status isEqualToString:@"1"]) {
        [cell.agreeButton setTitle:@"已同意" forState:UIControlStateNormal];
        [cell.agreeButton setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.agreeButton setEnabled:NO];
    }else if ([babyBindindStatusItem.baby_status isEqualToString:@"2"]){
        [cell.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [cell.agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_agree"] forState:UIControlStateNormal];
        [cell.agreeButton setEnabled:YES];

    }else{
        [cell.agreeButton setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.agreeButton setTitle:@"已过期" forState:UIControlStateNormal];
        [cell.agreeButton setEnabled:NO];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:babyBindindStatusItem.head_imag_small] placeholderImage:[UIImage imageNamed:@"headportrait_80"]];
    return cell;
    
}

-(void)agreeBinding:(NSNumber *)baby_id user_phone:(NSString *)userphone baby_nickname:(NSString *)nickname relationship:(NSString* )relationship tableViewindexPath:(NSIndexPath *)indexPath{
    checkBabyIsAgreeService=[EHCheckBabyIsAgreeService new];
    WEAKSELF
    checkBabyIsAgreeService.serviceDidFinishLoadBlock=^(WeAppBasicService *service){
        STRONGSELF
        [strongSelf getBabyBindingStatus];
        if (strongSelf.bindingBabySuccess) {
            strongSelf.bindingBabySuccess();
        }
    };
    
    checkBabyIsAgreeService.serviceDidFailLoadBlock=^(WeAppBasicService *service,NSError *error){
        STRONGSELF
        EHLogError(@"EHCheckBabyIsAgreeService failed");
        [strongSelf.newfamilyMemberTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [checkBabyIsAgreeService  checkBabyIsAgreeService:userphone babyId:baby_id baby_nickname:nickname relationship:relationship];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getBabyBindingStatus{
    getBabyBindingStatusListService=[EHGetBabyBindingStatusListService new];
    WEAKSELF
    getBabyBindingStatusListService.serviceDidFinishLoadBlock=^(WeAppBasicService *service){
        EHLogInfo(@"getBabyBindingStatusList Success");
        STRONGSELF
        
        EHLogInfo(@"%@",service.dataList);
        if ([service.dataList count]==0) {
            [strongSelf showEmptyView];

        }
        strongSelf.newfamilyMemberList=service.dataList;
        [strongSelf.newfamilyMemberTableView reloadData];
        
    };
    
    getBabyBindingStatusListService.serviceDidFailLoadBlock=^(WeAppBasicService *service,NSError *error){
        EHLogError(@"getBabyBindingStatusList failed");
    };
    
    [getBabyBindingStatusListService getBabyBindingStatusList:self.baby_Id Phone:[KSAuthenticationCenter userPhone]];
    
}


@end
