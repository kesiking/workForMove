//
//  EHAddBabyInfoViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddBabyInfoViewController.h"
#import "EHSelectRelationToBabyViewController.h"
#import "EHAddBabyInfoService.h"
#import "EHAddBabyUserService.h"
#import "EHBabyInfo.h"
#import "KSInsetsTextField.h"

@interface EHAddBabyInfoViewController ()<EHSelectRelationProtocol>
{
    EHAddBabyInfoService* _addBabyService;
    EHAddBabyUserService* _addBabyUserService;
}
@property (strong, nonatomic) UILabel *selectBabySexPromptLabel;
@property (strong, nonatomic) UIImageView *leftLineImageView;
@property (strong, nonatomic) UIImageView *rightLineImageView;

@property (strong, nonatomic) UIImageView *boyHeadImageView;
@property (strong, nonatomic) UIImageView *girlHeadImageView;
@property (strong, nonatomic) UITextField *nameLabel;
@property (strong, nonatomic) UILabel *relationLabel;
@property (strong, nonatomic) KSInsetsTextField *inputNameTextField;
@property (strong, nonatomic) KSInsetsTextField *relationTextField;
@property (strong, nonatomic) UILabel *selectRelationLabel;
@property (strong, nonatomic) UIImageView *selectBoyImageview;
@property (strong, nonatomic) UIImageView *selectGirlImageview;


@end

@implementation EHAddBabyInfoViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = EH_bgcor1;
    self.title = @"完善宝贝信息";
    [self setupSelectSexPrompt];
    [self setupHeadImageView];
    
    [self setupInputNameTextField];
    
    [self setupRelationTextField];

    UIBarButtonItem* commitBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commitBabyInfo:)];
    self.navigationItem.rightBarButtonItem = commitBtn;

}

- (void)setupSelectSexPrompt {
    self.selectBabySexPromptLabel = [[UILabel alloc] init];
    self.selectBabySexPromptLabel.font = [UIFont systemFontOfSize:EHSiz2];
    self.selectBabySexPromptLabel.textColor = EHCor3;
    self.selectBabySexPromptLabel.text = @"性别选择";
    [self.view addSubview:self.selectBabySexPromptLabel];
    [self.selectBabySexPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    self.leftLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_leftLineImageView];
    [self.leftLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectBabySexPromptLabel.mas_centerY);
        make.right.equalTo(self.selectBabySexPromptLabel.mas_left).offset(-8);
        make.height.equalTo(@1);
        make.width.equalTo(@100);
    }];
    
    self.rightLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_rightLineImageView];
    [self.rightLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectBabySexPromptLabel.mas_centerY);
        make.left.equalTo(self.selectBabySexPromptLabel.mas_right).offset(8);
        make.height.equalTo(@1);
        make.width.equalTo(@100);
    }];
}

- (void)setupHeadImageView {
    
    self.boyHeadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headportrait_boy_160"]];
    self.boyHeadImageView.userInteractionEnabled = YES;
    [self addSingleTapGestureToImageView:self.boyHeadImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    [self.view addSubview:self.boyHeadImageView];
    [self.boyHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(60);
        make.left.equalTo(self.view.mas_left).offset(60);
    }];
    
    self.selectBoyImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pitchon"]];
    self.selectBoyImageview.hidden = NO;
    [self.view addSubview:self.selectBoyImageview];
    [self.selectBoyImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(50);
        make.left.equalTo(self.view.mas_left).offset(110);
    }];
    

    
    self.girlHeadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headportrait_girl_160"]];
    self.girlHeadImageView.userInteractionEnabled = YES;
    [self addSingleTapGestureToImageView:self.girlHeadImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    [self.view addSubview:self.girlHeadImageView];
    [self.girlHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-60);
    }];
    
    self.selectGirlImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pitchon"]];
    self.selectGirlImageview.hidden = YES;
    [self.view addSubview:self.selectGirlImageview];
    [self.selectGirlImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-55);
    }];
}

- (void)setupInputNameTextField {
    self.nameLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    self.nameLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.nameLabel.textColor = EH_cor3;
    self.nameLabel.text = @"宝贝姓名";
    self.nameLabel.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_mandatory"]];
    self.nameLabel.rightViewMode = UITextFieldViewModeAlways;
    self.nameLabel.userInteractionEnabled = NO;
    
    self.inputNameTextField = [[KSInsetsTextField alloc] init];
    self.inputNameTextField.textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.inputNameTextField.rightViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.inputNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputNameTextField.font = [UIFont systemFontOfSize:EHSiz2];
    self.inputNameTextField.textColor = EHCor3;
    self.inputNameTextField.textAlignment = NSTextAlignmentRight;
    self.inputNameTextField.placeholder = @"请输入";
    self.inputNameTextField.leftView = self.nameLabel;
    self.inputNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.inputNameTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_list"]];
    self.inputNameTextField.rightViewMode = UITextFieldViewModeAlways;

    
    [self.view addSubview:self.inputNameTextField];
    
    [self.inputNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.boyHeadImageView.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@44);
    }];
}

- (void)setupRelationTextField
{

    self.relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    self.relationLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.relationLabel.textColor = EH_cor3;
    self.relationLabel.text = @"您与宝贝的关系";


    
    
    self.relationTextField = [[KSInsetsTextField alloc] init];
    self.relationTextField.textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.relationTextField.rightViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.relationTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.relationTextField.font = [UIFont systemFontOfSize:EHSiz2];
    self.relationTextField.textColor = EHCor3;
    self.relationTextField.textAlignment = NSTextAlignmentRight;
    self.relationTextField.placeholder = @"请选择";
    self.relationTextField.leftView = self.relationLabel;
    self.relationTextField.leftViewMode = UITextFieldViewModeAlways;
    self.relationTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_list"]];
    self.relationTextField.rightViewMode = UITextFieldViewModeAlways;
    self.relationTextField.userInteractionEnabled = NO;
    
    [self.view addSubview:self.relationTextField];
    
    [self.relationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.inputNameTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@44);
    }];
    
    self.selectRelationLabel = [[UILabel alloc] init];
    self.selectRelationLabel.backgroundColor = [UIColor clearColor];
    self.selectRelationLabel.text = @"";
    [self.view addSubview:self.selectRelationLabel];
    [self.selectRelationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.relationTextField);
    }];
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRelationTapped:)];
    [self.selectRelationLabel addGestureRecognizer:tapGesture];
    self.selectRelationLabel.userInteractionEnabled = YES;
    
    
}

- (IBAction)commitBabyInfo:(id)sender
{
    if ([EHUtils isEmptyString:self.inputNameTextField.text])
    {
        [WeAppToast toast:(@"请输入宝贝名字!")];
        return;
    }
    
    
    // 管理员添加宝贝信息
    [self addBabyInfo];
    // 添加宝贝关联信息
    
    
    
}

- (IBAction)selectRelationTapped:(id)sender
{
    EHLogInfo(@"click");
    
    EHSelectRelationToBabyViewController* selectRelationVC = [[EHSelectRelationToBabyViewController alloc] init];
    selectRelationVC.selectedRelationdelegate = self;
    selectRelationVC.currentRelation = [EHUtils isEmptyString:self.relationTextField.text] ? @"家人" : self.relationTextField.text ;
    [self.navigationController pushViewController:selectRelationVC animated:YES];
}


#pragma mark - EHSelectRelationProtocol
- (void)selectedRelation:(NSString*)selected
{
    self.relationTextField.text = selected;
}


- (void)relationImageViewClick:(UITapGestureRecognizer*)sender
{
    UIImageView* clickImageView = (UIImageView*)sender.view;
    if (clickImageView == self.boyHeadImageView)
    {
        self.selectBoyImageview.hidden = NO;
        self.selectGirlImageview.hidden = YES;
        
    }
    else if (clickImageView == self.girlHeadImageView)
    {
        self.selectBoyImageview.hidden = YES;
        self.selectGirlImageview.hidden = NO;
    }
}

#pragma mark - touch event
//点击屏幕，让键盘弹回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark helper functions
-(void)addSingleTapGestureToImageView:(UIImageView*)imageview withTarget:(id)target andAction:(SEL)action
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [imageview addGestureRecognizer:singleTap];
    imageview.userInteractionEnabled = YES;
}

#pragma mark private functions
- (void)addBabyInfo
{
    _addBabyService = [EHAddBabyInfoService new];
    WEAKSELF
    _addBabyService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        [strongSelf addBabyUserByBabyid:[(EHBabyInfo*)service.item baby_id]];
        

    };
    
    // service 返回失败 block
    _addBabyService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHAddBabyInfoReq* babyInfo = [EHAddBabyInfoReq new];
    babyInfo.device_code = self.deviceCode;
    babyInfo.baby_name = self.inputNameTextField.text;
    babyInfo.baby_sex = self.selectBoyImageview.hidden ? [NSNumber numberWithInteger:2] : [NSNumber numberWithInteger:1];
    [_addBabyService addBabyInfo:babyInfo];

}

-(void)addBabyUserByBabyid:(NSNumber*)babayid
{
    WEAKSELF
    _addBabyUserService = [EHAddBabyUserService new];
    _addBabyUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        TBOpenURLFromSourceAndParams(tabbarURL(kEHOMETabHome), strongSelf, nil);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBindBabySuccessNotification object:nil];
        
    };
    
    // service 返回失败 block
    _addBabyUserService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHBabyUser* babyUser = [EHBabyUser new];
    babyUser.baby_id = babayid;
    babyUser.user_id = [NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]];
    babyUser.baby_nickname = self.inputNameTextField.text;
    babyUser.relationship = self.selectRelationLabel.text;
    [_addBabyUserService addBabyUser:babyUser];
    
}
@end
