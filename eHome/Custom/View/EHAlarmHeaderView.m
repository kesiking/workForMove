//
//  EHAlarmHeaderView.m
//  eHome
//
//  Created by jinmiao on 15/9/28.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHAlarmHeaderView.h"
#import "Masonry.h"

@interface EHAlarmHeaderView()

@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UIImageView *babyHeadImageView;
@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation EHAlarmHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.babyHeadImageView];
        [self addSubview:self.nameLabel];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=1.5;
        [self addConstraints];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_backgroundImageView setFrame:CGRectMake(0, 0, self.frame.size.width, 81.f)];
}

- (void)addConstraints{
    [_babyHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(21);
        //make.centerY.equalTo(self.contentView.mas_centerY);
        //make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        NSLog(@"5self.nameLabel.size.width=%f",self.nameLabel.size.width);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.babyHeadImageView.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    
    
}

- (void)configWithBabyInfo:(EHGetBabyListRsp *)babyInfo{
    NSString* defaultImageStr = @"headportrait_boy_160";
    if ([EHUtils isGirl:babyInfo.babySex]) {
        defaultImageStr = @"headportrait_girl_160";
    }
    NSURL *imageUrl = [NSURL URLWithString:babyInfo.babyHeadImage];
    [self.babyHeadImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:babyInfo.babyId newPlaceHolderImagePath:babyInfo.babyHeadImage defaultHeadImage:[UIImage imageNamed:defaultImageStr]]];
    
    NSString *nameStr;
    if ([EHUtils isAuthority:babyInfo.authority]) {
        nameStr = babyInfo.babyName;
    }
    else
    {
        nameStr = babyInfo.babyNickName ? babyInfo.babyNickName : babyInfo.babyName;
    }
    self.nameLabel.text = nameStr;
    
}


-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_clock"]];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _babyHeadImageView.layer.masksToBounds=YES;
        _babyHeadImageView.layer.cornerRadius=3;
    }
    return _backgroundImageView;
}

-(UIImageView *)babyHeadImageView{
    if (!_babyHeadImageView) {
        _babyHeadImageView = [[UIImageView alloc]init];
        _babyHeadImageView.layer.masksToBounds=YES;
        _babyHeadImageView.layer.cornerRadius=20;
    }
    return _babyHeadImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = EH_font2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = EHCor5;
        
    }
    return _nameLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
