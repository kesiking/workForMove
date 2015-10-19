//
//  EHAddressSearchResultTableViewCell.m
//  eHome
//
//  Created by xtq on 15/7/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddressSearchResultTableViewCell.h"
#import "NSString+StringSize.h"
@implementation EHAddressSearchResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height1 = [@"text" sizeWithFontSize:EHSiz2 Width:CGRectGetWidth(self.frame)].height;
    CGFloat height2 = [@"text" sizeWithFontSize:EHSiz5 Width:CGRectGetWidth(self.frame)].height;
    CGFloat nameLabelY = (CGRectGetHeight(self.frame) - height1 - height2 - 9) / 2.0 + 2.5;
    CGFloat addressLabelY = nameLabelY + height1 + 9;

    _nameLabel.frame = CGRectMake(12, nameLabelY, CGRectGetWidth(self.frame) - 24, height1);
    _addressLabel.frame = CGRectMake(12, addressLabelY, CGRectGetWidth(self.frame) - 24, height2);
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.font = EHFont2;
        _nameLabel.textColor = EHCor5;
    }
    
    return _nameLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _addressLabel.font = EHFont5;
        _addressLabel.textColor = EHCor4;
    }
    
    return _addressLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
