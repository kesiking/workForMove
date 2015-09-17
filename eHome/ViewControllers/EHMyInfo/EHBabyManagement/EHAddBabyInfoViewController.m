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

@interface EHAddBabyInfoViewController ()<EHSelectRelationProtocol>
{
    EHAddBabyInfoService* _addBabyService;
    EHAddBabyUserService* _addBabyUserService;
}
@property (weak, nonatomic) IBOutlet UILabel *selectBabySexPromptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *boyHeadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *girlHeadImageView;
@property (weak, nonatomic) IBOutlet UIView *infoSettingBackground;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *selectRelationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectBoyImageview;
@property (weak, nonatomic) IBOutlet UIImageView *selectGirlImageview;


@end

@implementation EHAddBabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = EH_bgcor1;
    
    self.infoSettingBackground.backgroundColor = [UIColor whiteColor];
    
    self.selectBabySexPromptLabel.font = [UIFont systemFontOfSize:EH_siz6];
    self.selectBabySexPromptLabel.textColor = EH_cor3;
    self.selectBabySexPromptLabel.text = @"请点击下方头像选择宝贝性别";
    
    self.nameLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.nameLabel.textColor = EH_cor3;
    self.nameLabel.text = @"宝贝姓名";
    self.nameLabel.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_mandatory"]];
    self.nameLabel.rightViewMode = UITextFieldViewModeAlways;
    self.nameLabel.userInteractionEnabled = NO;
    
    self.inputNameTextField.font = [UIFont systemFontOfSize:EH_siz3];
    self.inputNameTextField.textColor = EH_cor6;
    self.inputNameTextField.placeholder = @"请输入";
    
    
    self.relationLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.relationLabel.textColor = EH_cor3;
    self.relationLabel.text = @"您与宝贝的关系";
    
    self.selectRelationLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.selectRelationLabel.textColor = RGB(0xC9, 0xC9, 0xC9);
    self.selectRelationLabel.text = @"家人";

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRelationTapped:)];
    [self.selectRelationLabel addGestureRecognizer:tapGesture];
    self.selectRelationLabel.userInteractionEnabled = YES;
    

    self.selectBoyImageview.hidden = NO;
    self.boyHeadImageView.userInteractionEnabled = YES;
    [self addSingleTapGestureToImageView:self.boyHeadImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    self.selectGirlImageview.hidden = YES;
    self.girlHeadImageView.userInteractionEnabled = YES;
    [self addSingleTapGestureToImageView:self.girlHeadImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    UIBarButtonItem* commitBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commitBabyInfo:)];
    self.navigationItem.rightBarButtonItem = commitBtn;

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
    selectRelationVC.currentRelation = self.selectRelationLabel.text;
    [self.navigationController pushViewController:selectRelationVC animated:YES];
}


#pragma mark - EHSelectRelationProtocol
- (void)selectedRelation:(NSString*)selected
{
    self.selectRelationLabel.text = selected;
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
