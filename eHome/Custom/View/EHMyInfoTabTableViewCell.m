//
//  EHMyInfoTabTableViewCell.m
//  eHome
//
//  Created by xtq on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMyInfoTabTableViewCell.h"
#import "UIImageView+WebCache.h"
#define kQRcodeImageViewTag 100
#define kAdminImageViewTag  101
#define kImageHeight        25
#define kSpaceCellX         20
#define kSpaceCellY         12

@implementation EHMyInfoTabTableViewCell
{
    UIImageView *_headImageView;
    UILabel  *_namelabel;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSpaceCellX, kSpaceCellY, kImageHeight, kImageHeight)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageViewClick:)];
        [_headImageView addGestureRecognizer:singleTap];
        
        _namelabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceCellX * 2 + kImageHeight, kSpaceCellY, CGRectGetWidth([UIScreen mainScreen].bounds)- 145, kImageHeight)];
        _namelabel.textAlignment = NSTextAlignmentLeft;
        _namelabel.font = EH_font3;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_namelabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
}

/**
 *  通过参数配置cell
 *
 *  @param params imageStr、nameStr、QRcodeImage、adminImageStr
 */
- (void)configWithParams:(NSDictionary *)params{
    //左图片
    NSURL *imageUrl = [NSURL URLWithString:[params objectForKey:@"imageStr"]];
    NSNumber* babyId = [params objectForKey:@"currentBabyId"];
    if (babyId) {
        [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:babyId newPlaceHolderImagePath:[params objectForKey:@"imageStr"] defaultHeadImage:[UIImage imageNamed:[params objectForKey:@"defaultImageStr"]]] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];

    }
    else
    {
        [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:[params objectForKey:@"defaultImageStr"]] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];

    }
    _headImageView.layer.cornerRadius = CGRectGetHeight(_headImageView.frame)/2;
    _headImageView.layer.masksToBounds = YES;
    
    if ([[params objectForKey:@"nameStr"] isEqualToString:kCellNameStr]) {
        _headImageView.userInteractionEnabled = YES;
        _namelabel.textColor = EH_cor5;
        //_namelabel.font = EH_font3;
    }
    else {
        _headImageView.userInteractionEnabled = NO;
        _namelabel.textColor = [UIColor blackColor];
    }
    //左名字
    _namelabel.text = [params objectForKey:@"nameStr"];
    
    if ([self.contentView viewWithTag:kQRcodeImageViewTag]) {
        [[self.contentView viewWithTag:kQRcodeImageViewTag] removeFromSuperview];
    }
    if ([self.contentView viewWithTag:kAdminImageViewTag]) {
        [[self.contentView viewWithTag:kAdminImageViewTag] removeFromSuperview];
    }
    
    //二维码图片
    if ([params objectForKey:@"QRcodeImage"]) {
        UIButton *QRImageView = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - kImageHeight - kSpaceCellX - 10, kSpaceCellY, kImageHeight, kImageHeight)];
        QRImageView.tag = kQRcodeImageViewTag;
        [QRImageView setImage:[params objectForKey:@"QRcodeImage"] forState:UIControlStateNormal];
        [QRImageView addTarget:self action:@selector(QRImageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:QRImageView];
        //_headImageView.frame = CGRectMake(kSpaceCellX, 10, 30, 30);
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.frame) / 2.0;
    }
    else {
        //_headImageView.frame = CGRectMake(kSpaceCellX, kSpaceCellY, kImageHeight, kImageHeight);
        _headImageView.layer.cornerRadius = 0;
    }
    
    if ([[params objectForKey:@"isHeadImage"] boolValue])
    {
        _headImageView.frame = CGRectMake(kSpaceCellX, kSpaceCellY, kImageHeight, kImageHeight);
    }
    else
    {
        _headImageView.frame = CGRectMake(kSpaceCellX, 15, 20, 20);
    }
    
    //管理员图片
    if ([params objectForKey:@"adminImageStr"]) {
        UIImageView *adminImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[params objectForKey:@"adminImageStr"]]];
        adminImageView.tag = kAdminImageViewTag;
        adminImageView.frame = CGRectMake(SCREEN_WIDTH - kSpaceCellX - 19 - kImageHeight * 2, kSpaceCellY, kImageHeight, kImageHeight);
        [self.contentView addSubview:adminImageView];
    }
}

- (void)headImageViewClick:(id)sender{
    !self.addBtnClickBlock?:self.addBtnClickBlock();
}

- (void)QRImageViewClick:(id)sender{
    !self.qrImageViewClickBlock?:self.qrImageViewClickBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
