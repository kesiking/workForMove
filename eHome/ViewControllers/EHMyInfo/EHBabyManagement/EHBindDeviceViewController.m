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
@property (weak, nonatomic) IBOutlet UILabel *chargePrompt;
@property (weak, nonatomic) IBOutlet UILabel *openPrompt;
@property (weak, nonatomic) IBOutlet UIImageView *sampleWatchImageView;
@property (weak, nonatomic) IBOutlet UIButton *inputDeviceCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *freeUseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sampleImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sampleImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sampleImageViewTop;

@property (nonatomic, strong)EHBindingBabyRsp* bindBabyRsp;
@end

@implementation EHBindDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绑定手表";
    
    self.view.backgroundColor = EH_bgcor1;
    self.chargePrompt.text = @"对手表进行充电15分钟以上，并且可以开机";
    self.chargePrompt.textColor = EH_cor3;
    self.chargePrompt.font = [UIFont systemFontOfSize:EH_siz1];
    self.openPrompt.text = @"长按开关键2秒以上开机";
    self.openPrompt.textColor = EH_cor3;
    self.openPrompt.font = [UIFont systemFontOfSize:EH_siz6];
    
    self.scanQRCodeBtn.backgroundColor = [UIColor whiteColor];
    self.scanQRCodeBtn.titleLabel.text = @"    扫描二维码绑定";
    self.scanQRCodeBtn.titleLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.scanQRCodeBtn.titleLabel.textColor = EH_cor3;
    
    self.inputDeviceCodeBtn.backgroundColor = [UIColor whiteColor];
    self.inputDeviceCodeBtn.titleLabel.text = @"    输入设备码绑定";
    self.inputDeviceCodeBtn.titleLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.inputDeviceCodeBtn.titleLabel.textColor = EH_cor3;
    

    self.freeUseBtn.backgroundColor = [UIColor whiteColor];
    self.freeUseBtn.titleLabel.text = @"试用体验";
    self.freeUseBtn.titleLabel.font = [UIFont systemFontOfSize:EH_siz3];
    self.freeUseBtn.titleLabel.textColor = EH_cor3;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.sampleImageViewHeight.constant = 255*SCREEN_SCALE;
    self.sampleImageViewWidth.constant = 200*SCREEN_SCALE;
    self.sampleImageViewTop.constant = 145*SCREEN_SCALE;
    [self.view layoutIfNeeded];
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
            EHAddBabyInfoViewController* addBabyInfoVC = [[EHAddBabyInfoViewController alloc] initWithNibName:@"EHAddBabyInfoViewController" bundle:[NSBundle mainBundle]];
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
