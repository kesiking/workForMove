//
//  EHPickerViewCell.m
//  9.23-test-timeSelector
//
//  Created by xtq on 15/9/24.
//  Copyright © 2015年 one. All rights reserved.
//

#import "EHPickerViewCell.h"

@interface EHPickerViewCell ()

@end

@implementation EHPickerViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.titleLabel.text sizeWithFontSize:EH_siz1 Width:MAXFLOAT];
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.frame) - size.height, CGRectGetWidth(self.frame), size.height);
    self.titleLabel.frame = frame;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = EH_font1;
        _titleLabel.textColor = EHCor4;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
