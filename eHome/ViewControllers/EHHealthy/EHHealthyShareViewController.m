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

#pragma mark - Life Circle
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
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 123*SCREEN_SCALE));
    }];
    sharedBtnBgView.userInteractionEnabled=YES;
    
    UIButton *weChatBtn=[[UIButton alloc]init];
    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"public_icon_share_wechat"] forState:UIControlStateNormal];
    weChatBtn.tag=EHShareTypeWechatSession;
    [weChatBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sharedBtnBgView addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sharedBtnBgView.mas_top).with.offset(18*SCREEN_SCALE);
        make.left.equalTo(sharedBtnBgView.mas_left).with.offset(77*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_SCALE, 60*SCREEN_SCALE));
    }];
    
    UILabel *weChartLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    weChartLabel.text = @"微信";
//    weChartLabel.textColor = [UIColor redColor];
    weChartLabel.font = EHFont5;
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
        make.top.equalTo(sharedBtnBgView.mas_top).with.offset(18*SCREEN_SCALE);
        make.right.equalTo(sharedBtnBgView.mas_right).with.offset(-77*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_SCALE, 60*SCREEN_SCALE));
    }];
    friendsBtn.tag=EHShareTypeWechatTimeline;
    [friendsBtn addTarget:self action:@selector(sharedButonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *friendsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    friendsLabel.text = @"朋友圈";
//    friendsLabel.textColor = [UIColor redColor];
    friendsLabel.font = EHFont5;
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


#pragma mark - 私有方法
- (void)addSubViews
{
    //宝贝头像
    [self setHeadImageUrl:self.sharedHeadImage withSex:[self.babySex integerValue]];
    
    self.babyHeadImageView.layer.masksToBounds=YES;
    self.babyHeadImageView.layer.cornerRadius=30*SCREEN_SCALE;
    self.babyHeadImageView.layer.borderWidth = 1;
    self.babyHeadImageView.layer.borderColor = EHCor13.CGColor;
    //[self.view addSubview:_babyHeadImageView];
    [self.sharedBgView addSubview:self.babyHeadImageView];
    
    //宝贝名字标签
    self.nameLabel.text=_sharedBabyName;
    //CGFloat
    self.nameLabel.textColor=EH_cor1;
    self.nameLabel.font=EHFont2;
    
    [self.nameLabel sizeToFit];
    if (self.nameLabel.size.width>self.view.size.width - 180*SCREEN_SCALE) {
        CGRect frame = self.nameLabel.frame;
        frame.size.width = self.view.size.width - 180*SCREEN_SCALE;
        self.nameLabel.frame = frame;
    }
    
    [self.sharedBgView addSubview:_nameLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sharedBgView.backgroundColor = [UIColor whiteColor];
    
    //日期标签
    self.dateLabel.text=_sharedDate;
    self.dateLabel.textColor=EH_cor1;
    
    self.dateLabel.font=EHFont1;
    [self.dateLabel sizeToFit];
    //[self.view addSubview:self.dateLabel];
    [self.sharedBgView addSubview:self.dateLabel];
    
    //取消按钮
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, roundf(42*SCREEN_SCALE), roundf(42*SCREEN_SCALE))];
    self.cancelButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.cancelButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
//    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelShareVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
  
    //计步标签
    self.finishedSteps.textColor= EHCor12;
    self.finishedSteps.font = EHFont8;
    self.finishedSteps.textAlignment=NSTextAlignmentCenter;
    NSDictionary *attributes22 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EHSize8]forKey:NSFontAttributeName];
    CGSize labelSize22=[self.finishedSteps.text boundingRectWithSize:CGSizeMake(360, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes22 context:nil].size;
    self.finishedSteps.size=labelSize22;
    ////////完成步数
    [self.sharedBgView addSubview:self.finishedSteps];
    
    self.step=[[UILabel alloc]initWithFrame:CGRectZero];
    self.step.text=@"步";
    self.step.font=[UIFont systemFontOfSize:EHSiz1];
    self.step.textColor= EHCor12;
    [self.step sizeToFit];
    [self.sharedBgView addSubview:self.step];
  
    //目标步数
    //计步标签
    self.babyTargetSteps.textColor=EHCor7;
    self.babyTargetSteps.font = EHFont2;
    self.babyTargetSteps.textAlignment=NSTextAlignmentCenter;
    NSDictionary *attributes12 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EHSiz2]forKey:NSFontAttributeName];
    CGSize labelSize12=[self.babyTargetSteps.text boundingRectWithSize:CGSizeMake(160, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes12 context:nil].size;
    self.babyTargetSteps.size=labelSize12;
    //完成步数
    [self.sharedBgView addSubview:self.babyTargetSteps];

    NSLog(@"\nbaby%@",self.babyTargetSteps);
    
    NSDictionary *attributes3 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:EHSiz2]forKey:NSFontAttributeName];

    CGSize sizeForLabel = [self.distanceLabel.text boundingRectWithSize:CGSizeMake(80, 21) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes3 context:nil].size;
    
    //创建运动距离相关控件
    //距离标签
    self.distanceLabel.text = @"距离";
    self.distanceLabel.textColor = EHCor1;
    self.distanceLabel.font = EHFont5;
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.distanceLabel sizeToFit];
    //self.distanceLabel.layer.borderWidth = 1;
    
    
    self.distanceDigitLabel.textColor=EHCor10;
    self.distanceDigitLabel.font=[UIFont systemFontOfSize:EHSiz2];
    self.distanceDigitLabel.textAlignment=NSTextAlignmentCenter;
    self.distanceDigitLabel.size = [self.distanceDigitLabel.text boundingRectWithSize:CGSizeMake(180, 61) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;

 
    [self.sharedBgView addSubview:self.distanceDigitLabel];
    [self.sharedBgView addSubview:self.distanceLabel];


    //创建消耗能量相关控件
    //消耗能量标签
    self.energyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.energyLabel.text = @"热量";
    self.energyLabel.textColor = EH_cor1;
    self.energyLabel.font = EHFont5;
    self.energyLabel.textAlignment = NSTextAlignmentCenter;
    self.energyLabel.size = sizeForLabel;
    
    
    self.energyDigitLabel.textColor=EHCor9;
    self.energyDigitLabel.font=[UIFont systemFontOfSize:EHSiz2];
    self.energyDigitLabel.textAlignment=NSTextAlignmentCenter;
    self.energyDigitLabel.size = [self.energyDigitLabel.text boundingRectWithSize:CGSizeMake(180, 71) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;
   
   
    [self.sharedBgView addSubview:self.energyDigitLabel];
    [self.sharedBgView addSubview:self.energyLabel];
    
    //完成相关
    //创建完成相关控件
    self.finishRateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.finishRateLabel.text = @"完成";
    self.finishRateLabel.textColor = EH_cor1;
    self.finishRateLabel.font = EHFont5;
    self.finishRateLabel.textAlignment = NSTextAlignmentCenter;
    self.finishRateLabel.size = sizeForLabel;
    
    
    self.finishDigitRateLabel.textColor=EHCor11;
    self.finishDigitRateLabel.font=[UIFont systemFontOfSize:EHSiz2];
    self.finishDigitRateLabel.size = [self.finishDigitRateLabel.text boundingRectWithSize:CGSizeMake(80, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes3 context:nil].size;
    self.finishDigitRateLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.sharedBgView addSubview:self.finishRateLabel];
    [self.sharedBgView addSubview:self.finishDigitRateLabel];
    
    self.lineThree = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 32*SCREEN_SCALE)];
    self.lineThree.backgroundColor = EHCor6;
    [self.sharedBgView addSubview:self.lineThree];
  
    
    self.lineFour = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 34*SCREEN_SCALE)];
    self.lineFour.backgroundColor = EHCor6;
    [self.sharedBgView addSubview:self.lineFour];
   

    //创建底部标语
    self.markedWordsLabel.textColor = EH_cor1;
    self.finishDigitRateLabel.font=[UIFont systemFontOfSize:EHSiz2];
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
    
    //底部标语约束
    [self.markedWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-147*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
    }];

    //创建取消按钮约束
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(50*SCREEN_SCALE);
        make.right.equalTo(superView.mas_right).with.offset(-2*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(42*SCREEN_SCALE, 42*SCREEN_SCALE));
        
    }];
    
    [self.babyTargetSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(58*SCREEN_SCALE);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    
    [self.finishedSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.babyTargetSteps.mas_bottom).offset(17*SCREEN_SCALE+11);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    
    
    [self.step mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishedSteps.mas_right).offset(13*SCREEN_SCALE);
        make.bottom.equalTo(self.finishedSteps.mas_bottom).offset(-11);
        
    }];
    
    [self.distanceDigitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
        make.centerX.equalTo(self.sharedBgView.mas_left).offset(SCREEN_WIDTH/6.0);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.distanceDigitLabel.mas_top).offset(-7*SCREEN_SCALE);
        make.centerX.equalTo(self.distanceDigitLabel.mas_centerX);
        
    }];
   
  
    [self.energyDigitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.energyLabel.mas_centerX);
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
    }];

    [self.energyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
         make.bottom.equalTo(self.energyDigitLabel.mas_top).offset(-7*SCREEN_SCALE);
        
    }];
    
   
    [self.finishDigitRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sharedBgView.mas_right).offset(-SCREEN_WIDTH/6.0);
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
        
        }];
    
    [self.finishRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.finishDigitRateLabel.mas_centerX);
        make.bottom.equalTo(self.finishDigitRateLabel.mas_top).offset(-7*SCREEN_SCALE);
        
        
    }];
    
    
    [self.lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
        make.left.equalTo(self.sharedBgView.mas_left).offset(SCREEN_WIDTH/3.0);
        make.size.mas_equalTo(CGSizeMake(1, 34*SCREEN_SCALE));
    }];
    
    [self.lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sharedBgView.mas_right).offset(-SCREEN_WIDTH/3.0);
        make.bottom.equalTo(self.markedWordsLabel.mas_top).offset(-24*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(1, 34*SCREEN_SCALE));
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
    croppingRect.size.height = croppingRect.size.height - 123*SCREEN_SCALE;
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

#pragma mark - Getters And Setters
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


@end
