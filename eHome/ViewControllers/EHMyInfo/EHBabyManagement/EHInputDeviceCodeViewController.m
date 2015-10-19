//
//  EHInputDeviceCodeViewController.m
//  eHome
//
//  Created by louzhenhua on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHInputDeviceCodeViewController.h"
#import "EHBindingBabyService.h"
#import "EHCheckRandomNumService.h"
#import "EHBindingBabyRsp.h"
#import "EHAddBabyInfoViewController.h"
#import "EHBindSmsCodeAuthViewController.h"
#import "EHSendRandomToManagerService.h"

@interface EHInputDeviceCodeViewController ()<UITextFieldDelegate>
{
    EHBindingBabyService* _bindingBabyService;
    EHSendRandomToManagerService* _sendRandomService;
}
@property (weak, nonatomic) IBOutlet UITextField *deviceCodeTextField;

@property (nonatomic, strong)EHBindingBabyRsp* bindBabyRsp;
@end

@implementation EHInputDeviceCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"输入手表设备码";
    self.view.backgroundColor = EHBgcor1;
    
    self.deviceCodeTextField.placeholder = @"请输入宝贝手表的设备码";
    
    self.deviceCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.deviceCodeTextField.font = [UIFont systemFontOfSize:EH_siz3];
    self.deviceCodeTextField.textColor = EH_cor3;
    self.deviceCodeTextField.delegate = self;
    
    UIBarButtonItem* nextStep = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doNextStep:)];
    nextStep.enabled = NO;
    self.navigationItem.rightBarButtonItem = nextStep;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



- (void)doNextStep:(id)sender
{
    [self.deviceCodeTextField resignFirstResponder];
    
    if (![EHUtils isPureInt:self.deviceCodeTextField.text]) {
        [WeAppToast toast:@"宝贝手表设备码不正确！"];
        return;
    }
    
    _bindingBabyService = [EHBindingBabyService new];
    // service 返回成功 block
    
    WEAKSELF
    _bindingBabyService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        strongSelf.bindBabyRsp = (EHBindingBabyRsp*)service.item;
        if ([strongSelf.bindBabyRsp.exist_gardian integerValue] == 1)
        {
            // 存在管理员，需要获取验证码进行验证
            [strongSelf sendRandomNumToManager];

        }
        else
        {
            // 手表未被绑定，直接成为管理员，完善宝贝信息
            EHAddBabyInfoViewController* addBabyInfoVC = [[EHAddBabyInfoViewController alloc] init];
            addBabyInfoVC.deviceCode = strongSelf.deviceCodeTextField.text;
            [strongSelf.navigationController pushViewController:addBabyInfoVC animated:YES];
        }
        
    };
    
    // service 返回失败 block
    _bindingBabyService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
        
    };
    [_bindingBabyService bindingBabyWithDeviceCode:self.deviceCodeTextField.text userPhone:[KSAuthenticationCenter userPhone]];
}

- (void)sendRandomNumToManager {
    
    _sendRandomService = [EHSendRandomToManagerService new];
    
    WEAKSELF
    _sendRandomService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        
        STRONGSELF
        [WeAppToast toast:@"已经向管理员发送验证短信，等待管理员验证"];
        TBOpenURLFromSourceAndParams(tabbarURL(kEHOMETabHome), strongSelf, nil);
        
        
    };
    
    // service 返回失败 block
    _sendRandomService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    [_sendRandomService sendRandomNumToManager:self.bindBabyRsp.gardian_phone withUserPhone:[KSAuthenticationCenter userPhone] andBabyNmae:self.bindBabyRsp.baby_info.baby.baby_name andBabyId:self.bindBabyRsp.baby_info.baby.baby_id];
    
}

#pragma mark - touch event
//点击屏幕，让键盘弹回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldTextChanged:(NSNotification *)notification{
    UITextField* textField = [notification object];
    if (textField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

//#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (self.deviceCodeTextField.text.length < 14)
//    {
//        return YES;
//    }
//    return NO;
//}
@end
