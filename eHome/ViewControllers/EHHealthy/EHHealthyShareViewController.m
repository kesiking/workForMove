//
//  EHHealthyShareViewController.m
//  eHome
//
//  Created by 钱秀娟 on 15/7/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyShareViewController.h"
#import "Masonry.h"
#import "UMSocial.h"
#import "EHSocializedSharedMacro.h"
#import "EHSocialShareHandle.h"

@interface EHHealthyShareViewController ()

//分享页面截图
@property (nonatomic,strong) UIView *sharedBgView;
//baby头像视图
@property (nonatomic,strong) UIImageView *babyHeadImageView;
@property (nonatomic,strong) UIView *imageNameView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView  *distanceCircleView;
@property (strong,nonatomic) UILabel *distanceLabel;

@property (nonatomic,strong) UIView *energyCircleView;
@property (strong,nonatomic) UILabel *energyLabel;

@property (nonatomic,strong) UIView *finishedCircleView;
@property (strong,nonatomic) UILabel *finishRateLabel;

@property (nonatomic,assign) CGFloat nameLabelHeight;



@end

@implementation EHHealthyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *sharedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.size.height - 70*SCREEN_SCALE)];
    UIImageView *sharedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_share_health"]];
    sharedBackgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.size.height);
    self.sharedBgView = sharedBackgroundView;
    [self.view addSubview:self.sharedBgView];
    [self addSubViews];
    
    UIImageView *sharedBtnBgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_share_wechatanefriend"]];
    [self.view addSubview:sharedBtnBgView];
    [sharedBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 105*SCREEN_SCALE));
    }];
    sharedBtnBgView.userInteractionEnabled=YES;
    
    UIButton *weChatBtn=[[UIButton alloc]init];
    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_share_wechat"] forState:UIControlStateNormal];
    weChatBtn.tag=EHShareTypeWechatSession;
    [weChatBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sharedBtnBgView addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top).with.offset(16*SCREEN_SCALE);
        make.left.equalTo(sharedBtnBgView.mas_left).with.offset(66*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_SCALE, 60*SCREEN_SCALE));
    }];
    
    UILabel *weChartLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    weChartLabel.text = @"微信";
//    weChartLabel.textColor = [UIColor redColor];
    weChartLabel.font = EH_font6;
    [weChartLabel sizeToFit];
    [sharedBtnBgView addSubview:weChartLabel];
    [weChartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weChatBtn.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.centerX.equalTo(weChatBtn.mas_centerX);

    }];


    UIButton *friendsBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    [friendsBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_share_circleoffriends"] forState:UIControlStateNormal];
    [sharedBtnBgView addSubview:friendsBtn];
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top).with.offset(16*SCREEN_SCALE);
        make.right.equalTo(sharedBtnBgView.mas_right).with.offset(-66*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_SCALE, 60*SCREEN_SCALE));
    }];
    friendsBtn.tag=EHShareTypeWechatTimeline;
    [friendsBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *friendsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    friendsLabel.text = @"朋友圈";
//    friendsLabel.textColor = [UIColor redColor];
    friendsLabel.font = EH_font6;
    [friendsLabel sizeToFit];
    [sharedBtnBgView addSubview:friendsLabel];
    [friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(friendsBtn.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.centerX.equalTo(friendsBtn.mas_centerX);
        
    }];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addConstraintsForSubViews];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //修复iOS7直接崩溃bug
    [self.view layoutIfNeeded];
    if (self.nameLabel.size.width>self.view.size.width - 180*SCREEN_SCALE) {
        CGRect frame = self.nameLabel.frame;
        frame.size.width = self.view.size.width - 180*SCREEN_SCALE;
        self.nameLabel.frame = frame;
    }
}

- (void)addSubViews
{
    //宝贝头像
    [self setHeadImageUrl:self.sharedHeadImage withSex:[self.babySex integerValue]];
    
    self.babyHeadImageView.layer.masksToBounds=YES;
    self.babyHeadImageView.layer.cornerRadius=30*SCREEN_SCALE;
    self.babyHeadImageView.layer.borderWidth = 1;
    self.babyHeadImageView.layer.borderColor = [UIColor redColor].CGColor;
    //[self.view addSubview:_babyHeadImageView];
    [self.sharedBgView addSubview:self.babyHeadImageView];
    
    //宝贝名字标签
    self.nameLabel.text=_sharedBabyName;
    //CGFloat
    self.nameLabel.textColor=EH_cor1;
    self.nameLabel.font=EH_font4;
    
    NSLog(@"self.nameLabel.size.width = %f",self.nameLabel.size.width);
    [self.nameLabel sizeToFit];
    NSLog(@"2self.nameLabel.size.width = %f",self.nameLabel.size.width);
    if (self.nameLabel.size.width>self.view.size.width - 180*SCREEN_SCALE) {
        CGRect frame = self.nameLabel.frame;
        frame.size.width = self.view.size.width - 180*SCREEN_SCALE;
        self.nameLabel.frame = frame;
    }
NSLog(@"3self.nameLabel.size.width = %f",self.nameLabel.size.width);
    
    [self.sharedBgView addSubview:_nameLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sharedBgView.backgroundColor = [UIColor whiteColor];
    
    //日期标签
    self.dateLabel.text=_sharedDate;
    self.dateLabel.textColor=EH_cor1;
    self.dateLabel.font=EH_font2;
    [self.dateLabel sizeToFit];
    //[self.view addSubview:self.dateLabel];
    [self.sharedBgView addSubview:self.dateLabel];
    
    //取消按钮
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, roundf(22*SCREEN_SCALE), roundf(22*SCREEN_SCALE))];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelShareVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
  
    NSNumber *finishedRate = [NSNumber numberWithFloat:[self.finishDigitRateLabel.text floatValue]];
    
    //计步标签
    self.finishedSteps.textColor=[UIColor redColor];
    self.finishedSteps.font = EH_font10;
    self.finishedSteps.textAlignment=NSTextAlignmentCenter;
    NSDictionary *attributes22 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_size10]forKey:NSFontAttributeName];
    CGSize labelSize22=[self.finishedSteps.text boundingRectWithSize:CGSizeMake(360, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes22 context:nil].size;
    self.finishedSteps.size=labelSize22;
    ////////完成步数
    [self.sharedBgView addSubview:self.finishedSteps];
    
    
    
    //目标步数
    //计步标签
    self.babyTargetSteps.textColor=EHCor7;
    self.babyTargetSteps.font = EH_font4;
    self.babyTargetSteps.textAlignment=NSTextAlignmentCenter;
    NSDictionary *attributes12 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz4]forKey:NSFontAttributeName];
    CGSize labelSize12=[self.babyTargetSteps.text boundingRectWithSize:CGSizeMake(160, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes12 context:nil].size;
    self.babyTargetSteps.size=labelSize12;
    ////////完成步数
    [self.sharedBgView addSubview:self.babyTargetSteps];

    NSLog(@"\nbaby%@",self.babyTargetSteps);
    
    NSDictionary *attributes3 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz4]forKey:NSFontAttributeName];
    NSDictionary *attributes4 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EH_siz8]forKey:NSFontAttributeName];

    CGSize sizeForLabel = [self.distanceLabel.text boundingRectWithSize:CGSizeMake(80, 21) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes3 context:nil].size;
    
    //创建运动距离相关控件
    //距离标签
    self.distanceLabel.text = @"距离";
    self.distanceLabel.textColor = EHCor1;
    self.distanceLabel.font = EH_font6;
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.distanceLabel sizeToFit];
    //self.distanceLabel.layer.borderWidth = 1;
    
    
    self.distanceDigitLabel.textColor=EHCor11;
    self.distanceDigitLabel.font=[UIFont systemFontOfSize:EH_siz4];
    self.distanceDigitLabel.textAlignment=NSTextAlignmentCenter;
    self.distanceDigitLabel.size = [self.distanceDigitLabel.text boundingRectWithSize:CGSizeMake(180, 61) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;

    [self.sharedBgView addSubview:self.distanceLabel];
    [self.sharedBgView addSubview:self.distanceDigitLabel];


    //创建消耗能量相关控件
    //消耗能量标签
    self.energyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.energyLabel.text = @"热量";
    self.energyLabel.textColor = EH_cor1;
    self.energyLabel.font = EH_font6;
    self.energyLabel.textAlignment = NSTextAlignmentCenter;
    self.energyLabel.size = sizeForLabel;
    
    
    self.energyDigitLabel.textColor=EHCor9;
    self.energyDigitLabel.font=[UIFont systemFontOfSize:EH_siz4];
    self.energyDigitLabel.textAlignment=NSTextAlignmentCenter;
    self.energyDigitLabel.size = [self.energyDigitLabel.text boundingRectWithSize:CGSizeMake(180, 71) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;
   
    [self.sharedBgView addSubview:self.energyLabel];
    [self.sharedBgView addSubview:self.energyDigitLabel];
    
    //完成相关
    //创建完成相关控件
    self.finishRateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.finishRateLabel.text = @"完成";
    self.finishRateLabel.textColor = EH_cor1;
    self.finishRateLabel.font = EH_font6;
    self.finishRateLabel.textAlignment = NSTextAlignmentCenter;
    self.finishRateLabel.size = sizeForLabel;
    
    
    self.finishDigitRateLabel.textColor=EHCor11;
    self.finishDigitRateLabel.font=[UIFont systemFontOfSize:EH_siz4];
    self.finishDigitRateLabel.size = [self.finishDigitRateLabel.text boundingRectWithSize:CGSizeMake(80, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;
    self.finishDigitRateLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.sharedBgView addSubview:self.finishRateLabel];
    [self.sharedBgView addSubview:self.finishDigitRateLabel];

    //创建底部标语
    self.markedWordsLabel.textColor = EH_cor1;
    self.finishDigitRateLabel.font=[UIFont systemFontOfSize:EH_siz4];
    [self.markedWordsLabel sizeToFit];
    [self.sharedBgView addSubview:self.markedWordsLabel];
}

- (void)addConstraintsForSubViews
{
    UIView *superView = self.sharedBgView;
    [_babyHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(41*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_SCALE, 60*SCREEN_SCALE));
        NSLog(@"5self.nameLabel.size.width=%f",self.nameLabel.size.width);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.babyHeadImageView.mas_bottom).with.offset(11*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(11*SCREEN_SCALE);

    }];
    
    
    //创建取消按钮约束
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(60*SCREEN_SCALE);
        make.right.equalTo(superView.mas_right).with.offset(-12*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(22*SCREEN_SCALE, 22*SCREEN_SCALE));
        
    }];
    
    [self.babyTargetSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(58*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    
    [self.finishedSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.babyTargetSteps.mas_bottom).offset(17*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(42*SCREEN_SCALE);
        make.top.equalTo(self.markedWordsLabel.mas_top).offset(-56*SCREEN_SCALE);
        
    }];
   
    [self.distanceDigitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
        make.centerX.equalTo(self.distanceLabel.mas_centerX);
    }];
    

    [self.energyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
         make.top.equalTo(self.markedWordsLabel.mas_top).offset(-56*SCREEN_SCALE);
        
    }];
    
    [self.energyDigitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.energyLabel.mas_centerX);
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
    }];

    [self.finishRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-42*SCREEN_SCALE);
        make.top.equalTo(self.markedWordsLabel.mas_top).offset(-56*SCREEN_SCALE);
        

    }];
    
    [self.finishDigitRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.finishRateLabel.mas_centerX);
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
        
        }];
    //底部标语约束
    [self.markedWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-126*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
    }];


}



-(void)setHeadImageUrl:(NSString*)imageUrl withSex:(NSUInteger)sex{
    if ([KSAuthenticationCenter isTestAccount]) {
        [self.babyHeadImageView setImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_testaccount_80"]];
    }else{
        if (sex == EHBabySexType_girl) {
            [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.sharedBabyId newPlaceHolderImagePath:imageUrl defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]]];
        }else{
            [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.sharedBabyId newPlaceHolderImagePath:imageUrl defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]]];
        }
    }
}

#pragma mark - 点击取消按钮取消分享页面
-(void)cancelShareVC:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 点击分享按钮响应事件
- (void)sharedButonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case EHShareTypeWechatSession:
        {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:[self screenshotForCroppingRect:self.sharedBgView.layer.visibleRect] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微信好友分享成功！");
                }
            }];
        }
            
            break;
        case EHShareTypeWechatTimeline:
        {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:[self screenshotForCroppingRect:self.sharedBgView.layer.visibleRect] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"朋友圈分享成功！");
                }
            }];
        }
            break;
        default:
            break;
    }
}




- (UIImage *)screenshotForCroppingRect:(CGRect)croppingRect
{
    UIGraphicsBeginImageContextWithOptions(croppingRect.size, NO, [UIScreen mainScreen].scale);
    // Create a graphics context and translate it the view we want to crop so
    // that even in grabbing (0,0), that origin point now represents the actual
    // cropping origin desired:
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) return nil;
    CGContextTranslateCTM(context, -croppingRect.origin.x, -croppingRect.origin.y);
    
    [self.view layoutIfNeeded];
    [self.sharedBgView.layer renderInContext:context];
    
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

-(UIImageView *)babyHeadImageView{
    if (!_babyHeadImageView) {
        _babyHeadImageView = [[UIImageView alloc]init];
    }
    return _babyHeadImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
    }
    return _nameLabel;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
    }
    return _dateLabel;
}

-(UILabel *)finishedSteps{
    if (!_finishedSteps) {
        _finishedSteps = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _finishedSteps;
}



-(UILabel *)babyTargetSteps{
    if (!_babyTargetSteps) {
        _babyTargetSteps = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _babyTargetSteps;
}

-(UILabel *)distanceLabel{
    if(!_distanceLabel){
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _distanceLabel;
}
-(UILabel *)distanceDigitLabel{
    if (!_distanceDigitLabel) {
        _distanceDigitLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _distanceDigitLabel;
}

-(UILabel *)energyDigitLabel{
    if (!_energyDigitLabel) {
        _energyDigitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _energyDigitLabel;
}

-(UILabel *)finishDigitRateLabel{
    if (!_finishDigitRateLabel) {
        _finishDigitRateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _finishDigitRateLabel;
}


-(UILabel *)markedWordsLabel{
    if (!_markedWordsLabel) {
        _markedWordsLabel = [[UILabel alloc]initWithFrame:CGRectZero];

    }
    return _markedWordsLabel;
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