//
//  EHBabySafeModeViewController.m
//  eHome
//
//  Created by jss on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyLocationModeViewController.h"
#import "Masonry.h"
#import "RMActionController.h"
#import "EHSetLocationModeService.h"


@interface EHBabyLocationModeViewController ()

@property (nonatomic,strong) UIButton *locationModeBtn;
@property (nonatomic,strong) UILabel *locationModeLabel;
@property (nonatomic,strong) UILabel *babyLocationModeLabel;
@property (nonatomic,strong) EHSetLocationModeService *setLocationModeService;

@end

@implementation EHBabyLocationModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"定位模式";
    self.view.backgroundColor=EH_bgcor1;
    
    _locationModeBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    _locationModeBtn.backgroundColor=[UIColor whiteColor];
    [_locationModeBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:EH_font3 forKey:NSFontAttributeName];
    CGSize sizeForLabel=[self.locationModeLabel.text boundingRectWithSize:CGSizeMake(80, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _locationModeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _locationModeLabel.text=@"定位模式";
    _locationModeLabel.textColor=EH_cor4;
    _locationModeLabel.font=EH_font3;
    _locationModeLabel.size=sizeForLabel;
    
    _babyLocationModeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _babyLocationModeLabel.text = [self getBabyLocationMode:self.locationMode];
    _babyLocationModeLabel.textColor=EH_cor5;
    _babyLocationModeLabel.font=EH_font3;
    _babyLocationModeLabel.size=sizeForLabel;
    
    [self.view addSubview:_locationModeBtn];
    [self.locationModeBtn addSubview:_locationModeLabel];
    [self.locationModeBtn addSubview:_babyLocationModeLabel];
    
    [self.locationModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [self.locationModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20*SCREEN_SCALE);
        make.centerY.equalTo(_locationModeBtn.mas_centerY);
    }];
    [self.babyLocationModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20*SCREEN_SCALE);
        make.centerY.equalTo(_locationModeBtn.mas_centerY);
    }];

}


-(NSString *)getBabyLocationMode:(NSString *)mode{

    if ([mode isEqualToString: @"1"]) {
        return @"追踪模式";
    }else if([mode isEqualToString: @"2"]){
        return @"普通模式";
    }else{
        return @"省电模式";
    }
}

-(void) showActionSheet:(id)sender{
    RMAction *precisionMode=[RMAction actionWithTitle:@"追踪模式  2min" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self changLocationMode:@"1"];
    }];
    
    
//    RMAction *test=[RMAction actionWithTitle:<#(NSString *)#> style:<#(RMActionStyle)#> andHandler:<#^(RMActionController *controller)handler#>];
    
    precisionMode.titleColor=EH_cor3;
    precisionMode.titleFont=EH_font2;
    RMAction *normalMode=[RMAction actionWithTitle:@"普通模式  10min" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self changLocationMode:@"2"];
    }];
    normalMode.titleColor=EH_cor3;
    normalMode.titleFont=EH_font2;
    RMAction *powerSavingMode=[RMAction actionWithTitle:@"省电模式  20min" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self changLocationMode:@"3"];
    }];
    powerSavingMode.titleColor=EH_cor3;
    powerSavingMode.titleFont=EH_font2;
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor=EH_cor3;
    cancelAction.titleFont=EH_font2;
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleDefault];
    actionSheet.seperatorViewColor=EH_cor8;
    [actionSheet addAction:powerSavingMode];
    [actionSheet addAction:normalMode];
    [actionSheet addAction:precisionMode];
    [actionSheet addAction:cancelAction];
    actionSheet.contentView=[[UIView alloc]initWithFrame:CGRectZero];
    actionSheet.disableBlurEffects=YES;
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)changLocationMode:(NSString *)locationMode
{
    _setLocationModeService= [EHSetLocationModeService new];
    NSString *mode=[self getBabyLocationMode:locationMode];
    
    WEAKSELF
    _setLocationModeService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"设置完成！");
        [WeAppToast toast:@"定位模式设置成功"];
        STRONGSELF
        dispatch_async( dispatch_get_main_queue(), ^{
            strongSelf.babyLocationModeLabel.text=mode;
        });
        
        if (strongSelf.modifyLocationModeSuccess)
        {
            strongSelf.modifyLocationModeSuccess(locationMode);
        }
    };
    _setLocationModeService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"定位模式设置失败"];
    };
    
//    EHGetBabyListRsp* currentBabyUserInfo=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    NSString *baby_Id=[NSString stringWithFormat:@"%@",self.babyId];
    
    [_setLocationModeService setLocationMode:baby_Id babyLocationMode:locationMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
