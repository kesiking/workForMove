//
//  XHEmotionCollectionViewCell.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewCell.h"

@interface XHEmotionCollectionViewCell ()

/**
 *  显示表情封面的控件
 */
@property (nonatomic, weak) UIImageView *emotionImageView;

/**
 *  显示表情的文本注释label
 */
@property (nonatomic, weak) UILabel     *emotionLabel;

/**
 *  配置默认控件和参数
 */
- (void)setup;
@end

@implementation XHEmotionCollectionViewCell

#pragma setter method

- (void)setEmotion:(XHEmotion *)emotion {
    _emotion = emotion;
    
    // TODO:
    self.emotionImageView.image = emotion.emotionConverPhoto;
    self.emotionLabel.text = emotion.text;
}

#pragma mark - Life cycle

- (void)setup {
    if (!_emotionImageView) {
        UIImageView *emotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kEHEmotionImageViewWidth, kEHEmotionImageViewHeight)];
        emotionImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:emotionImageView];
        self.emotionImageView = emotionImageView;
    }
    if (!_emotionLabel) {
        UILabel *emotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionImageView.frame) + 2, kEHEmotionLabelWidth, kEHEmotionLabelHeight)];
        emotionLabel.font = [UIFont systemFontOfSize:11];
        emotionLabel.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
        emotionLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:emotionLabel];
        self.emotionLabel = emotionLabel;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotion = nil;
}

@end
