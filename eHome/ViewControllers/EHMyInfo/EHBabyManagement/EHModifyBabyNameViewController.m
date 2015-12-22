//
//  EHModifyBabyNameViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHModifyBabyNameViewController.h"
#import "EHUpdateBabyInfoService.h"
#import "EHUpdateBabyUserService.h"

@interface EHModifyBabyNameViewController ()<UITextFieldDelegate>
{
}
@property (strong, nonatomic)UITextField *babyNameTextField;
@property (strong, nonatomic)EHUpdateBabyInfoService* updateBabyInfoService;
@property (strong, nonatomic)EHUpdateBabyUserService* updateBabyUserService;

@end

@implementation EHModifyBabyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([EHUtils isAuthority:self.authory])
    {
        self.title = @"修改宝贝名字";
    }
    else
    {
        self.title = @"修改昵称";
    }
    
    self.view.backgroundColor = EHBgcor1;
    
    self.babyNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, CGRectGetWidth([UIScreen mainScreen].bounds) - 30, 49)];
    self.babyNameTextField.font = [UIFont systemFontOfSize:EH_siz3];
    //self.babyNameTextField.backgroundColor = [UIColor whiteColor];
    self.babyNameTextField.textColor = EH_cor3;
    self.babyNameTextField.background = [UIImage imageNamed:@"public_input_670_press"];
    self.babyNameTextField.text = self.babyName;
    self.babyNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.babyNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.babyNameTextField];
 
    
    UIBarButtonItem* submitBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmit:)];
    submitBtn.tintColor = EHCor6;
    self.navigationItem.rightBarButtonItem = submitBtn;
    
}


- (void)doSubmit:(id)sender
{
    [self.babyNameTextField resignFirstResponder];
    

    NSString* babyName = [EHUtils trimmingHeadAndTailSpaceInstring:self.babyNameTextField.text];
    
    if ([babyName length] > EHPersonNameLength) {
        [WeAppToast toast:(@"宝贝名字超过最大长度20!")];
        return;
    }
    if ([EHUtils isAuthority:self.authory])
    {
        // 管理员修改宝贝名字
        if ([EHUtils isEmptyString:babyName])
        {
            self.babyNameTextField.text=@"";
            [WeAppToast toast:(@"请输入宝贝名字!")];
            return;
        }
        
        [self modifyBabyName:babyName];
    }
    
    else
    {
        // 修改昵称
        if ([EHUtils isEmptyString:babyName])
        {
            self.babyNameTextField.text=@"";
            [WeAppToast toast:(@"请输入宝贝昵称!")];
            return;
        }
        // 非管理员修改昵称
        [self modifyBabyNickName:babyName];
    }

}


- (void)modifyBabyName:(NSString*)babyName
{
    WEAKSELF
    
    self.updateBabyInfoService = [EHUpdateBabyInfoService new];
    
    self.updateBabyInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        if (strongSelf.modifyBabyNameSuccess)
        {
            strongSelf.modifyBabyNameSuccess(babyName);
        }
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    };
    
    // service 返回失败 block
    self.updateBabyInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHUpdateBabyInfoReq* babyIno = [EHUpdateBabyInfoReq new];
    babyIno.baby_id = self.babyId;
    babyIno.user_phone = [KSAuthenticationCenter userPhone];
    babyIno.baby_name = babyName;
    [self.updateBabyInfoService updateBabyInfo:babyIno];
}


- (void)modifyBabyNickName:(NSString*)babyName
{
    WEAKSELF
    
    self.updateBabyUserService = [EHUpdateBabyUserService new];
    
    self.updateBabyUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        if (strongSelf.modifyBabyNameSuccess)
        {
            strongSelf.modifyBabyNameSuccess(babyName);
        }
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    };
    
    // service 返回失败 block
    self.updateBabyUserService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHBabyUser* babyUser = [EHBabyUser new];
    babyUser.baby_id = self.babyId;
    babyUser.user_id = [NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]];
    babyUser.baby_nickname = babyName;
    [self.updateBabyUserService updateBabyUser:babyUser];
}

#pragma mark - touch event
//点击屏幕，让键盘弹回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
