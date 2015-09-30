//
//  EHFamilyMemberTableViewCell.m
//  eHome
//
//  Created by louzhenhua on 15/7/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyMemberTableViewCell.h"

@implementation EHFamilyMemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.textColor = EHCor5;
    self.nameLabel.font = EHFont2;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    self.phoneLabel.textColor = EHCor4;
    self.phoneLabel.font = EHFont5;
    
    
    
//    self.checkImageView.hidden = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.headImageView.layer.cornerRadius = CGRectGetHeight(self.headImageView.frame)/2;
        self.headImageView.layer.masksToBounds = YES;
    });
}

@end
