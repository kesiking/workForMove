//
//  EHNewApplyFamilyMemberTableViewCell.m
//  eHome
//
//  Created by jss on 15/8/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHNewApplyFamilyMemberTableViewCell.h"

@implementation EHNewApplyFamilyMemberTableViewCell
- (IBAction)agreeBtn:(id)sender {
    [sender setEnabled:NO];
    self.agreeBtnClickBlock();
}

- (void)awakeFromNib {
    self.titleLabel.textColor=EH_cor3;
    self.titleLabel.font=EH_font3;

    self.phoneLabel.textColor=EH_cor4;
    self.phoneLabel.font=EH_font5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
