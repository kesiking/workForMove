//
//  EHFamilyMemberFirstSectionTableViewCell.m
//  eHome
//
//  Created by jss on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyMemberFirstSectionTableViewCell.h"

@implementation EHFamilyMemberFirstSectionTableViewCell

- (void)awakeFromNib {
    self.titleLable.textColor=EH_cor3;
    self.titleLable.font=EH_font3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
