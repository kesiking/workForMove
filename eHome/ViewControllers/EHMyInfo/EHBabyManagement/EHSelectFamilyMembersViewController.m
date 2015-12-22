//
//  EHSelectFamilyMembersViewController.m
//  eHome
//
//  Created by jss on 15/11/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSelectFamilyMembersViewController.h"
#import "EHGetBabyAttentionUsersService.h"
#import "EHFamilyMemberTableViewCell.h"
#import "EHGetBabyAttentionUsersRsp.h"
#import "EHAddBabyFamilyPhoneService.h"

@interface EHSelectFamilyMembersViewController (){
    EHGetBabyAttentionUsersService *_getBabyAttentionUsersService;
    EHAddBabyFamilyPhoneService *_addBabyFamilyPhoneService;
}

@property (nonatomic, strong) GroupedTableView *tableView;
@property(nonatomic, strong)NSIndexPath * currentSecectIndex;

@property(nonatomic,strong)NSArray *familyMemberList;


@end

@implementation EHSelectFamilyMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=EHBgcor1;
    [self tableView];
    
  //  [self updateFamilyMemberList];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateFamilyMemberList];

}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame)-16, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.backgroundColor=EHBgcor1;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EHFamilyMemberTableViewCell *cell = nil;
    
    if (_currentSecectIndex) {
        cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:_currentSecectIndex];
        cell.checkImageView.image = [UIImage imageNamed:@"public_radiobox_set_off"];
    }
    self.navigationItem.rightBarButtonItem.enabled=YES;
    _currentSecectIndex = indexPath;
    
    cell = (EHFamilyMemberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.checkImageView.image = [UIImage imageNamed:@"public_radiobox_set_on"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SelectfamilyMemberCellID=@"selectFamilyMemberCellID";
    EHFamilyMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectfamilyMemberCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHFamilyMemberTableViewCell class]) owner:self options:nil] firstObject];
    }
    EHBabyAttentionUser *attentionUser = (EHBabyAttentionUser *)[self.familyMemberList objectAtIndex:indexPath.row];
    NSString *nick_name=attentionUser.user.nick_name;
    NSString *relationship= [attentionUser relationship];
    NSString *nameString=[NSString stringWithFormat:@"%@（%@）",nick_name,relationship];
    CGSize auStringSize =[nameString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:EHSiz2]}];
    if (auStringSize.width>CGRectGetWidth(cell.nameLabel.frame)) {
        NSMutableString *name=[NSMutableString string];
        
        if (nick_name.length>2) {
            NSString *name1=[nameString substringToIndex:2];
            [name appendString:name1];
            [name appendString:@"..."];
        }else{
            [name appendString:nick_name];
        }
        if (relationship.length>2) {
            NSString *name2=[relationship substringToIndex:2];
            [name appendString:@"（"];
            [name appendString:name2];
            [name appendString:@"..."];
            [name appendString:@"）"];
        }else{
            [name appendString:@"（"];
            [name appendString:relationship];
            [name appendString:@"）"];
        }
        cell.nameLabel.text = name;
        
    }else{
        cell.nameLabel.text =[NSString stringWithFormat:@"%@（%@）",nick_name,relationship];
        
    }
    //   cell.nameLabel.text = [NSString stringWithFormat:@"%@", attentionUser.user.nick_name];
    
    cell.phoneLabel.text = attentionUser.user.user_phone;
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:attentionUser.user.user_head_img_small] placeholderImage:[EHUtils getUserHeadPlaceHolderImage:attentionUser.user.user_id newPlaceHolderImagePath:attentionUser.user.user_head_img_small defaultHeadImage:[UIImage imageNamed:@"headportrait_80"]]];
    if (_currentSecectIndex==indexPath) {
        cell.checkImageView.image = [UIImage imageNamed:@"public_radiobox_set_on"];
    }else {
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checkbox_normal"];
    }
    cell.checkImageView.hidden = NO;
    
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.familyMemberList.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}


-(void)updateFamilyMemberList{
    _getBabyAttentionUsersService=[EHGetBabyAttentionUsersService new];
    WEAKSELF
    _getBabyAttentionUsersService.serviceDidFinishLoadBlock=^(WeAppBasicService*service){
        STRONGSELF
        EHLogInfo(@"%@",service.dataList);
        
        if (service.item) {
            strongSelf.familyMemberList = [(EHGetBabyAttentionUsersRsp*)service.item user] ;
            
            if (strongSelf.familyMemberList.count > 0) {
                UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:strongSelf action:@selector(confirmBtnTapped:)];
                strongSelf.navigationItem.rightBarButtonItem = confirmBtn;
                strongSelf.navigationItem.rightBarButtonItem.enabled=false;
            }else{
                strongSelf.navigationItem.rightBarButtonItem = nil;
                [strongSelf showEmptyView];
            }
            
            [strongSelf.tableView reloadData];
        }
    };
    
    _getBabyAttentionUsersService.serviceDidFailLoadBlock=^(WeAppBasicService*service,NSError *error){
        EHLogError(@"getBabyAttentionUserfailed！");
    };
    
    [_getBabyAttentionUsersService getThisBabyAllAttentionUsers:self.babyId];
}


- (void)confirmBtnTapped:(id)sender{
    [self addPhoneNumber];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addPhoneNumber{
    
    _addBabyFamilyPhoneService = [EHAddBabyFamilyPhoneService new];
    WEAKSELF
    _addBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^
    (WeAppBasicService *service) {
        STRONGSELF
        NSLog(@"serviceDidFinishLoadBlock...");
        
        strongSelf.selectFamilyMemberBlock();
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
        
    };
    _addBabyFamilyPhoneService.serviceDidFailLoadBlock = ^
    (WeAppBasicService *service,NSError *error){
        [WeAppToast toast:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        //[WeAppToast toast:@"编辑中添加失败"];
    };
    EHBabyAttentionUser *attentationUser=[self.familyMemberList objectAtIndex:_currentSecectIndex.row];
    
    NSString *familyphone = attentationUser.user.user_phone;
    NSString *name = [attentationUser relationship];
    
    
    [_addBabyFamilyPhoneService addBabyFamilyPhone:familyphone andRelationship:name andindex:[NSNumber numberWithInteger:-1] byBabyId:self.babyId];
    
    
    
}

@end
