//
//  EHFeedbackTableViewCell.m
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFeedbackTableViewCell.h"

@implementation EHFeedbackTableViewCell
{
    UIImageView *_headImageView;
    UIImageView *_bubbleImageView;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _bubbleImageView = [[UIImageView alloc]init];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = EHCor3;
        _timeLabel.font = EHFont6;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.numberOfLines = 0;
        _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = EHCor5;
        _contentLabel.font = EHFont2;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_bubbleImageView];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)configWithViewModel:(EHFeedbackViewModel *)feedbackViewModel{
    [_timeLabel removeFromSuperview];
    if (feedbackViewModel.showedTime) {
        _timeLabel.text = feedbackViewModel.showedTime;
        _timeLabel.frame = feedbackViewModel.timeLabelFrame;
        [self.contentView addSubview:_timeLabel];
    }
    
    _headImageView.frame = feedbackViewModel.headImageFrame;
    _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.frame) / 2.0;

    NSString *imageName = feedbackViewModel.userHeadImageName;
    NSURL *imageUrl = [NSURL URLWithString:imageName];
    if ([imageName isEqualToString:kHeadportrait_administrator]) {
        _headImageView.image = [UIImage imageNamed:imageName];
    }
    else {
        [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getUserHeadPlaceHolderImage:[NSNumber numberWithInteger:feedbackViewModel.userId] newPlaceHolderImagePath:imageName defaultHeadImage:[UIImage imageNamed:kHeadportrait_me]] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    _bubbleImageView.frame = feedbackViewModel.bubbleImageFrame;
    UIImage *bubble = [UIImage imageNamed:feedbackViewModel.bubbleImageName];
    _bubbleImageView.image = [bubble stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    _contentLabel.frame = feedbackViewModel.contentLabelFrame;
    _contentLabel.text = feedbackViewModel.showedContent;
    _contentLabel.textColor = feedbackViewModel.contentColor;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
