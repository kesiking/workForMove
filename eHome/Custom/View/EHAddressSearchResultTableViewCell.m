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
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    CGFloat height1 = [@"text" sizeWithFontSize:EH_siz3 Width:CGRectGetWidth(self.frame)].height;
    CGFloat height2 = [@"text" sizeWithFontSize:EH_siz6 Width:CGRectGetWidth(self.frame)].height;
    CGFloat nameLabelY = (CGRectGetHeight(self.frame) - height1 - height2 - 5) / 2.0;
    CGFloat addressLabelY = nameLabelY + height1 + 5;

    _nameLabel.frame = CGRectMake(20, nameLabelY, CGRectGetWidth(self.frame) - 40, height1);
    _addressLabel.frame = CGRectMake(20, addressLabelY, CGRectGetWidth(self.frame) - 40, height2);
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.font = EH_font3;
        _nameLabel.textColor = EH_cor3;
    }
    
    return _nameLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _addressLabel.font = EH_font6;
        _addressLabel.textColor = EH_cor4;
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
