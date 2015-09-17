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
@interface EHHealthySettingViewController ()<UIActionSheetDelegate>

@property(nonatomic,strong)UIButton* targetStepBtn;
@property(nonatomic,strong)UILabel* staticLabel;
@property(nonatomic,strong)UILabel* targetLabel;
@property(nonatomic,strong)EHUpdateBabyInfoService *updateBabyInfoService;
@property(nonatomic,strong)EHLoadingHud *loadingHud;

@end

@implementation EHHealthySettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loadingHud=[[EHLoadingHud alloc]init];
    self.title=@"计步设置";
    self.view.backgroundColor=EH_bgcor1;

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _updateBabyInfoService= [EHUpdateBabyInfoService new];
    
    WEAKSELF
    _updateBabyInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"设置完成！");
        [WeAppToast toast:@"更新步数成功"];
        STRONGSELF
            dispatch_async( dispatch_get_main_queue(), ^{
            strongSelf.targetLabel.text=[NSString stringWithFormat:@"%@步",targetSteps];
            });
    };
    _updateBabyInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"更新步数失败"];
    };
    
    EHUpdateBabyInfoReq* babyInfo = [EHUpdateBabyInfoReq new];
    babyInfo.baby_id =[NSNumber numberWithInteger:[[[EHDeviceStatusCenter sharedCenter] getCurrentBabyId] integerValue]];
    babyInfo.user_phone = [KSAuthenticationCenter userPhone];
    babyInfo.baby_target_steps=targetSteps;
    [_updateBabyInfoService updateBabyInfo:babyInfo];
}
@end
