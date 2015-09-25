//
//  EHBindDeviceViewController.m
//  eHome
//
//  Created by louzhenhua on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBindDeviceViewController.h"
#import "EHInputDeviceCodeViewController.h"
#import "EHQRCodeReaderViewController.h"
#import "EHBindingBabyService.h"
#import "EHBindingBabyRsp.h"
#import "EHBindSmsCodeAuthViewController.h"
#import "EHAddBabyInfoViewController.h"
#import "EHSendRandomToManagerService.h"

@interface EHBindDeviceViewController ()
{
    EHBindingBabyService* _bindingBabyService;
    EHSendRandomToManagerService* _sendRandomService;
}

@property(nonatomic, strong)UIImageView* backgroundImageView;
@property (strong, nonatomic) UIButton *inputDeviceCodeBtn;
@property (strong, nonatomic) UIButton *scanQRCodeBtn;

@property (nonatomic, strong)EHBindingBabyRsp* bindBabyRsp;
@end

@implementation EHBindDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绑定手表";

    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bingdingwatch"]];
    [self.view addSubview:_backgroundImageView];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    self.scanQRCodeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.scanQRCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_purple_n"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 100, 10, 100) ] forState:UIControlStateNormal];
    [self.scanQRCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_purple_p"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 100, 10, 100) ] forState:UIControlStateHighlighted];
    [self.scanQRCodeBtn setTitle:@"扫描二维码绑定" forState:UIControlStateNormal];
    [self.scanQRCodeBtn setTitleColor:EHCor1 forState:UIControlStateNormal];
    self.scanQRCodeBtn.titleLabel.font = EHFont2;
    
    [self.scanQRCodeBtn addTarget:self action:@selector(bindingUseQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scanQRCodeBtn];
    [self.scanQRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(32);
        make.right.equalTo(self.view.mas_right).offset(-32);
        if (SCREEN_HEIGHT < 568) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        }
        else
        {
            make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        }
        
        make.height.equalTo(@40);

    }];
    
    self.inputDeviceCodeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.inputDeviceCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_n"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 100, 10, 100) ] forState:UIControlStateNormal];
    [self.inputDeviceCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_p"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 100, 10, 100) ] forState:UIControlStateHighlighted];
    [self.inputDeviceCodeBtn setTitle:@"输入设备码绑定" forState:UIControlStateNormal];
    [self.inputDeviceCodeBtn setTitleColor:EHCor1 forState:UIControlStateNormal];
    self.inputDeviceCodeBtn.titleLabel.font = EHFont2;
    [self.inputDeviceCodeBtn addTarget:self action:@selector(bindingUseDeviceCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.inputDeviceCodeBtn];
    
    [self.inputDeviceCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(32);
        make.right.equalTo(self.view.mas_right).offset(-32);
        if (SCREEN_HEIGHT < 568) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
        else
        {
            make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        }
        
        make.height.equalTo(@40);
        
        
    }];
    
}


- (IBAction)bindingUseQRCode:(id)sender {
    EHQRCodeReaderViewController* qrcodeVC = [[EHQRCodeReaderViewController alloc] init];
    qrcodeVC.qrCodeScanSuccess = ^(NSString* qrcode){
        [self bindBaby:qrcode];
    };
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

- (IBAction)bindingUseDeviceCode:(id)sender {
    EHInputDeviceCodeViewController* inputVC = [[EHInputDeviceCodeViewController alloc] initWithNibName:NSStringFromClass([EHInputDeviceCodeViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:inputVC animated:YES];
}


- (IBAction)tryFree:(id)sender {
}

- (void)bindBaby:(NSString*)qrcode
{
    if (![EHUtils isPureInt:qrcode]) {
        [WeAppToast toast:@"宝贝手表设备码不正确！"];
        return;
    }
    
    
    MBProgressHUD* _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

        [_hud hide:YES];
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
            addBabyInfoVC.deviceCode = qrcode;
            [strongSelf.navigationController pushViewController:addBabyInfoVC animated:YES];
        }
        
    };
    
    // service 返回失败 block
    _bindingBabyService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){

        [_hud hide:YES];
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
        
    };
    [_bindingBabyService bindingBabyWithDeviceCode:qrcode userPhone:[KSAuthenticationCenter userPhone]];
    
    
    
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
@end
