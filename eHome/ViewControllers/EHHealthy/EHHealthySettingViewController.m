//
//  EHHealthySettingViewController.m
//  eHome
//
//  Created by jweigang on 15/7/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthySettingViewController.h"
#import "Masonry.h"
#import "RMActionController.h"
#import "EHUpdateBabyInfoService.h"
#import "EHLoadingHud.h"
#import "EHDeviceStatusCenter.h"
#import "GroupedTableView.h"

@interface EHHealthySettingViewController ()<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)UIButton* targetStepBtn;
@property(nonatomic,strong)UILabel* staticLabel;
@property(nonatomic,strong)UILabel* targetLabel;
@property(nonatomic,strong)GroupedTableView *tableView;
@property(nonatomic,strong)EHUpdateBabyInfoService *updateBabyInfoService;
@property(nonatomic,strong)EHLoadingHud *loadingHud;

@property(nonatomic,strong)UIButton *lazyBtn;
@property(nonatomic,strong)UIButton *normalBtn;
@property(nonatomic,strong)UIButton *crazyBtn;
@property(nonatomic,strong)UIButton *currentSelectBtn;
@property(nonatomic,assign)NSInteger selectCellIndex;
@end

@implementation EHHealthySettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loadingHud=[[EHLoadingHud alloc]init];
    self.title=@"计步设置";
    //self.view.backgroundColor=[UIColor clearColor];
    [self configTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
//点击整个cell有效，该方法暂未使用 2015.10.15
- (void)buttonSelected:(UIButton *)sender
{
    if ((self.currentSelectBtn == self.lazyBtn&&sender.tag == 1000)||(self.currentSelectBtn == self.normalBtn&&sender.tag == 1001)||(self.currentSelectBtn == self.crazyBtn&&sender.tag == 1002)) {
        return;
    }
    switch (sender.tag) {
        case 1000:{
            [self updateTargetSteps:@4000];
            break;
        }
        case 1001:{
            [self updateTargetSteps:@6000];
            break;
        }
        case 1002:{
            [self updateTargetSteps:@8000];
            break;
        }
        default:
            break;
    }
}
- (void)configUI
{
    _targetStepBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    _targetStepBtn.backgroundColor=[UIColor whiteColor];
    [_targetStepBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:EH_font3 forKey:NSFontAttributeName];
    CGSize sizeForLabel=[self.staticLabel.text boundingRectWithSize:CGSizeMake(80, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _staticLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _staticLabel.text=@"步数设定";
    _staticLabel.textColor=EH_cor4;
    _staticLabel.font=EH_font3;
    _staticLabel.size=sizeForLabel;
    
    _targetLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _targetLabel.text=[NSString stringWithFormat:@"%@步",_currentTargetSteps];
    _targetLabel.textColor=EH_cor5;
    _targetLabel.font=EH_font3;
    _targetLabel.size=sizeForLabel;
    
    [self.view addSubview:_targetStepBtn];
    [self.targetStepBtn addSubview:_staticLabel];
    [self.targetStepBtn addSubview:_targetLabel];
    
    [self.targetStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [self.staticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20*SCREEN_SCALE);
        make.centerY.equalTo(_targetStepBtn.mas_centerY);
    }];
    [self.targetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20*SCREEN_SCALE);
        make.centerY.equalTo(_targetStepBtn.mas_centerY);
    }];

}
- (void)configTableView
{
    self.tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(12, 20, SCREEN_WIDTH-20, SCREEN_HEIGHT)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableFooterView = [[UIView alloc] init];
}
-(void)showActionSheet:(id)sender
{
    RMAction *lazyAction=[RMAction actionWithTitle:@"懒人模式  4000步" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self updateTargetSteps:@4000];
    }];
    lazyAction.titleColor=EH_cor3;
    lazyAction.titleFont=EH_font2;
    RMAction *normalAction=[RMAction actionWithTitle:@"正常模式  6000步" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self updateTargetSteps:@6000];
    }];
    normalAction.titleColor=EH_cor3;
    normalAction.titleFont=EH_font2;
    RMAction *strongAction=[RMAction actionWithTitle:@"运动小强  8000步" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self updateTargetSteps:@8000];
    }];
    strongAction.titleColor=EH_cor3;
    strongAction.titleFont=EH_font2;
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor=EH_cor3;
    cancelAction.titleFont=EH_font2;
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleDefault];
    actionSheet.seperatorViewColor=EH_cor8;
    [actionSheet addAction:strongAction];
    [actionSheet addAction:normalAction];
    [actionSheet addAction:lazyAction];
    [actionSheet addAction:cancelAction];
    actionSheet.contentView=[[UIView alloc]initWithFrame:CGRectZero];
    actionSheet.disableBlurEffects=YES;
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)updateTargetSteps:(NSNumber *)targetSteps
{
    if (!_updateBabyInfoService) {
        _updateBabyInfoService= [EHUpdateBabyInfoService new];
        WEAKSELF
        _updateBabyInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            EHLogInfo(@"设置完成！");
            [WeAppToast toast:@"更新步数成功"];
            STRONGSELF
            dispatch_async( dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
//                strongSelf.targetLabel.text=[NSString stringWithFormat:@"%@步",targetSteps];
            });
        };
        _updateBabyInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"更新步数失败"];
        };
    }
    EHUpdateBabyInfoReq* babyInfo = [EHUpdateBabyInfoReq new];
    babyInfo.baby_id =[NSNumber numberWithInteger:[[[EHDeviceStatusCenter sharedCenter] getCurrentBabyId] integerValue]];
    babyInfo.user_phone = [KSAuthenticationCenter userPhone];
    babyInfo.baby_target_steps=targetSteps;
    self.currentTargetSteps = targetSteps;
    [_updateBabyInfoService updateBabyInfo:babyInfo];
}
- (UIButton *)lazyBtn
{
    if (!_lazyBtn) {
        _lazyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 44, 0, 44, 44)];
        _lazyBtn.tag = 1000;
        _lazyBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        _lazyBtn.userInteractionEnabled=NO;
//        [_lazyBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lazyBtn;
}
- (UIButton *)normalBtn
{
    if (!_normalBtn) {
        _normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 44, 0, 44, 44)];
        _normalBtn.tag = 1001;
        _normalBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        _normalBtn.userInteractionEnabled=NO;
//        [_normalBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _normalBtn;
}
- (UIButton *)crazyBtn
{
    if (!_crazyBtn) {
        _crazyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 44, 0, 44, 44)];
        _crazyBtn.tag = 1002;
        _crazyBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        _crazyBtn.userInteractionEnabled=NO;
//        [_crazyBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _crazyBtn;
}
#pragma mark - tableView DataSource &Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kEHHealehySetCellID = @"kEHHealehySettingCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEHHealehySetCellID];
    UILabel *modelLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    modelLabel.textColor = EHCor5;
    modelLabel.font = EH_font4;
    UILabel *targetSteps = [[UILabel alloc]initWithFrame:CGRectZero];
    targetSteps.textColor = EHCor3;
    targetSteps.font = EH_font5;
    targetSteps.textAlignment = NSTextAlignmentRight;
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kEHHealehySetCellID];
        [cell addSubview:modelLabel];
        [cell addSubview:targetSteps];
        [modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(12);
            make.centerY.equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100*SCREEN_SCALE, 20));
        }];
        [targetSteps mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right).offset(-50);
            make.centerY.equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100*SCREEN_SCALE, 20));
        }];
    }
    switch (indexPath.row) {
        case 0:{
            modelLabel.text = @"懒人模式";
            targetSteps.text = @"4000步";
            [cell addSubview:self.lazyBtn];
            if([_currentTargetSteps integerValue] == 4000){
                [_lazyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
                self.currentSelectBtn = _lazyBtn;
                self.selectCellIndex = 2000;
            }else
            {
                [_lazyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
            }
            break;
        }
        case 1:{
            modelLabel.text = @"正常模式";
            targetSteps.text = @"6000步";
            [cell addSubview:self.normalBtn];
            if([_currentTargetSteps integerValue] == 6000){
                [_normalBtn setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
                self.currentSelectBtn = _normalBtn;
                self.selectCellIndex = 2001;
            }else
            {
                [_normalBtn setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
            }
            break;
        }
        case 2:{
            modelLabel.text = @"运动模式";
            targetSteps.text = @"8000步";
            [cell addSubview:self.crazyBtn];
            if([_currentTargetSteps integerValue] == 8000){
                [_crazyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
                self.currentSelectBtn = _crazyBtn;
                self.selectCellIndex = 2002;
            }else
            {
                [_crazyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
            }
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            if (self.selectCellIndex == 2000) {
                break;
            }
            [self updateTargetSteps:@4000];
            break;
        case 1:
            if (self.selectCellIndex == 2001) {
                break;
            }
            [self updateTargetSteps:@6000];
            break;
        case 2:
            if (self.selectCellIndex == 2002) {
                break;
            }
            [self updateTargetSteps:@8000];
            break;
        default:
            break;
    }
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
@end
