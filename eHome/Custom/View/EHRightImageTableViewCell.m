//
//  EHRightImageTableViewCell.m
//  eHome
//
//  Created by louzhenhua on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRightImageTableViewCell.h"

@implementation EHRightImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightImageViewClick:)];
    [self.rightImageView addGestureRecognizer:singleTap];
    self.rightImageView.userInteractionEnabled = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)rightImageViewClick:(UITapGestureRecognizer*)sender{

    if (self.rightImageViewClickBlock) {
        self.rightImageViewClickBlock((UIImageView*)sender.view);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rightImageView.layer.cornerRadius = CGRectGetHeight(self.rightImageView.frame)/2;
        self.rightImageView.layer.masksToBounds = YES;
    });

}
@end
