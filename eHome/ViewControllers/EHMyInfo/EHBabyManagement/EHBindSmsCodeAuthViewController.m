//
//  EHBindSmsCodeAuthViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBindSmsCodeAuthViewController.h"
#import "EHSendRandomToManagerService.h"
#import "EHCheckRandomNumService.h"
#import "EHAddBabyUserService.h"

@interface EHBindSmsCodeAuthViewController ()
{
    EHSendRandomToManagerService* _sendRandomService;
    EHCheckRandomNumService* _checkRandomService;
    EHAddBabyUserService* _addBabyUserService;
}
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSMSCodeBtn;

@end

@implementation EHBindSmsCodeAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = EHBgcor1;
    self.title = @"输入短信验证码";
    
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmClicked:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    
    [self setupViews];
    
    _sendRandomService = [EHSendRandomToManagerService new];
    _checkRandomService = [EHCheckRandomNumService new];
    
    [self getSmsCodeReq:nil];
    
}

- (void)setupViews
{
    self.promptLabel.text = [NSString stringWithFormat:@"已向管理员%@发送您的短信验证码，请向管理员获取后输入", self.adminPhoneNo];
    self.promptLabel.font = [UIFont systemFontOfSize:EH_siz6];
    self.promptLabel.textColor = EH_cor4;
    
    self.smsCodeTextField.background = [UIImage imageNamed:@"public_input_350_press"];
    self.smsCodeTextField.placeholder = @"请输入验证码";
    self.smsCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    [self.getSMSCodeBtn setBackgroundImage:[UIImage imageNamed:@"public_btn_verificationcode_normal"] forState:UIControlStateNormal];
    [self.getSMSCodeBtn setBackgroundImage:[UIImage imageNamed:@"public_btn_verificationcode_press"] forState:UIControlStateDisabled];
    self.getSMSCodeBtn.enabled = NO;
    self.getSMSCodeBtn.titleLabel.font = [UIFont systemFontOfSize:EH_siz3];
    [self.getSMSCodeBtn setTitleColor:EH_cor5 forState:UIControlStateDisabled] ;
    
    [EHUtils showSecondTimeout:60 timerOutHandler:^(BOOL end, NSUInteger remaintime) {
        if (end)
        {
            self.getSMSCodeBtn.enabled = YES;
            [self.getSMSCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            [self.getSMSCodeBtn setTitleColor:EH_cor1 forState:UIControlStateNormal] ;
        }
        else
        {
            [self.getSMSCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%lu)", (unsigned long)remaintime] forState:UIControlStateDisabled];
        }
    }];
}

- (IBAction)getSmsCodeReq:(id)sender {
    

    _sendRandomService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){

        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        
    };
    
    // service 返回失败 block
    _sendRandomService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    [_sendRandomService sendRandomNumToManager:self.adminPhoneNo withUserPhone:[KSAuthenticationCenter userPhone] andBabyNmae:self.babyName andBabyId:self.babyId];
    
}

- (IBAction)confirmClicked:(id)sender
{
    if ([EHUtils isEmptyString:self.smsCodeTextField.text] || ![EHUtils isPureInt:self.smsCodeTextField.text])
    {
        [WeAppToast toast:(@"验证码有误，请重新输入!")];
        return;
    }
    
    WEAKSELF
    _checkRandomService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        [strongSelf addBabyUserByBabyid:strongSelf.babyId];
        
        
    };
    
    // service 返回失败 block
    _checkRandomService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    [_checkRandomService checkRandomNum:self.smsCodeTextField.text withUserPhone:[KSAuthenticationCenter userPhone]];
    
}

-(void)addBabyUserByBabyid:(NSNumber*)babyid
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyListNeedChangeNotification object:nil];
        
    };
    
    // service 返回失败 block
    _addBabyUserService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHBabyUser* babyUser = [EHBabyUser new];
    babyUser.baby_id = babyid;
    babyUser.user_id = [NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]];
    [_addBabyUserService addBabyUser:babyUser];
    
}

@end
