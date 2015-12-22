//
//  EHModifyBabyPhoneViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHModifyBabyPhoneViewController.h"
#import "EHUpdateBabyDeviceSmsCardService.h"


@interface EHModifyBabyPhoneViewController ()<UITextFieldDelegate>
{
    EHUpdateBabyDeviceSmsCardService* _updateBabyDeviceSmsCardService;
}
@property (strong, nonatomic)UITextField *babyPhoneTextField;
@end

@implementation EHModifyBabyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"宝贝号码编辑";
    self.view.backgroundColor = EHBgcor1;
    
    self.babyPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, CGRectGetWidth([UIScreen mainScreen].bounds) - 30, 49)];
    self.babyPhoneTextField.font = [UIFont systemFontOfSize:EH_siz3];
    //self.babyNameTextField.backgroundColor = [UIColor whiteColor];
    self.babyPhoneTextField.textColor = EH_cor3;
    self.babyPhoneTextField.background = [UIImage imageNamed:@"public_input_670_press"];
    self.babyPhoneTextField.text = self.babyPhone;
    self.babyPhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.babyPhoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.babyPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.babyPhoneTextField];
 
    
    UIBarButtonItem* submitBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmit:)];
    submitBtn.tintColor = EHCor6;
    self.navigationItem.rightBarButtonItem = submitBtn;
    if ([EHUtils isEmptyString:self.babyPhone]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
}


- (void)doSubmit:(id)sender
{
    [self.babyPhoneTextField resignFirstResponder];
    

    NSString* babyPhone = [EHUtils trimmingHeadAndTailSpaceInstring:self.babyPhoneTextField.text];
    
    if (![EHUtils isValidMobile:babyPhone]) {
        [WeAppToast toast:(@"您输入的手机号码格式有误，请重新输入!")];
        return;
    }
    
    [self modifyBabyPhone:babyPhone];
}


- (void)modifyBabyPhone:(NSString*)babyPhone
{
    if (_updateBabyDeviceSmsCardService == nil)
    {
        _updateBabyDeviceSmsCardService = [EHUpdateBabyDeviceSmsCardService new];
        WEAKSELF
        _updateBabyDeviceSmsCardService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            
            if (strongSelf.modifyBabyPhoneSuccess)
            {
                strongSelf.modifyBabyPhoneSuccess(babyPhone);
            }
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        };
        
        // service 返回失败 block
        _updateBabyDeviceSmsCardService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            
            NSDictionary* userInfo = error.userInfo;
            EHLogError(@"error userinfo = %@", userInfo);
            [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
        };

    }
    
    [_updateBabyDeviceSmsCardService updateBabyDeviceSmsCard:babyPhone byBabyId:self.babyId];
}


- (void)textFieldTextChanged:(NSNotification *)notification{
    UITextField* textField = [notification object];
    if (textField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (![EHUtils isPureInt:textField.text]) {
            textField.text = nil;
            [WeAppToast toast:(@"请输入正确的手机号码!")];
        }
        
        if (textField.text.length >= 11 && ![EHUtils isValidMobile:textField.text]) {
            NSString *substring = [textField.text substringToIndex:11];
            textField.text = substring;
            [WeAppToast toast:(@"请输入正确的手机号码!")];
        }
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - touch event
//点击屏幕，让键盘弹回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
