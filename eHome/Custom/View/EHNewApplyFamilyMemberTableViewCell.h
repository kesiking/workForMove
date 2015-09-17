//
//  EHNewApplyFamilyMemberTableViewCell.h
//  eHome
//
//  Created by jss on 15/8/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AgreeBtnClickBlock)();


@interface EHNewApplyFamilyMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (nonatomic,copy)AgreeBtnClickBlock agreeBtnClickBlock;
@end
