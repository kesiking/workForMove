//
//  EHBabyDetailTableViewCell.m
//  eHome
//
//  Created by louzhenhua on 15/9/21.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyDetailTableViewCell.h"

@implementation EHBabyDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.babyNameLabel.textColor = EHCor5;
    self.babyNameLabel.font = EHFont2;
    
    self.babyDetalLabel.text = @"宝贝详情";
    self.babyDetalLabel.textColor = EHCor5;
    self.babyDetalLabel.font = EHFont5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.babyHeadImageView.layer.cornerRadius = CGRectGetHeight(self.babyHeadImageView.frame)/2;
        self.babyHeadImageView.layer.masksToBounds = YES;
    });
    
}

@end
