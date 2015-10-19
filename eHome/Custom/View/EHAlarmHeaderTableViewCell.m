//
//  EHAlarmHeaderTableViewCell.m
//  eHome
//
//  Created by jinmiao on 15/9/21.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHAlarmHeaderTableViewCell.h"
#import "Masonry.h"

@interface EHAlarmHeaderTableViewCell()
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UIImageView *babyHeadImageView;
@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation EHAlarmHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.babyHeadImageView];
        [self.contentView addSubview:self.nameLabel];
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
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.left.equalTo(self.contentView.mas_left).with.offset(21);
        //make.centerY.equalTo(self.contentView.mas_centerY);
        //make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        NSLog(@"5self.nameLabel.size.width=%f",self.nameLabel.size.width);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.babyHeadImageView.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-130);
        make.centerY.equalTo(self.contentView.mas_centerY);
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
        UIImage *image = [UIImage imageNamed:@"bg_clock"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 200);
        image = [image resizableImageWithCapInsets:insets];
        _backgroundImageView = [[UIImageView alloc]initWithImage:image];
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
        _nameLabel.font = EHFont2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = EHCor1;
//        _nameLabel.layer.borderWidth = 1;

    }
    return _nameLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
