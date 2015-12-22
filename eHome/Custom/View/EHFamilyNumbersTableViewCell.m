//
//  EHFamilyNumbersTableViewCell.m
//  eHome
//
//  Created by jinmiao on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyNumbersTableViewCell.h"





@implementation EHFamilyNumbersTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nickNameLabel.textColor = EHCor5;
    self.nickNameLabel.font = [UIFont systemFontOfSize:EHSiz2];
    self.phoneLabel.textColor = EHCor6;
    self.phoneLabel.font = [UIFont systemFontOfSize:EHSiz5];
    self.phoneLabel.text=@"";
 //   self.rankImage.image = [UIImage imageNamed:@"bg_familyphone"];
    self.rankImage.backgroundColor=EHCor23;
    self.rankLabel.font = [UIFont boldSystemFontOfSize: EH_siz6];
    self.rankLabel.textColor = EHCor22;
    self.rankLabel.textAlignment=NSTextAlignmentCenter;
  //  self.colorfulRankImage.backgroundColor=EHCor20;
    self.colorfulRankImage.image = [UIImage imageNamed:@"bg_familyphone"];
    self.selectImage.hidden = YES;
    self.line.image=[UIImage imageNamed:@"line_606"];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.arrowImage.hidden=NO;
    self.arrowImage.image=[UIImage imageNamed:@"public_icon_arrow"];
    self.relationImage.image=[UIImage imageNamed:@"icon_family100"];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    _cellSeparator.frame = CGRectMake(20, 48.5, self.frame.size.width - 20, 0.5);
//    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
//    

//    self.rankLabel.frame = CGRectMake(20, 14.5, 20, 20);
//    self.rankImage.frame = CGRectMake(20, 14.5, 20, 20);
//    self.colorfulRankImage.frame = CGRectMake(20, 14.5, 20, 20);


//}

//-(UIView *)cellSeparator{
//    if (!_cellSeparator) {
//        _cellSeparator = [TBDetailUITools drawDivisionLine:20.0 yPos:49.0 lineWidth:self.frame.size.width-20.0];
//        [self.contentView addSubview:_cellSeparator];
//    }
//    return _cellSeparator;
//}


//+(UIView *)drawDivisionLine:(CGFloat)x yPos:(CGFloat)y lineWidth:(CGFloat)lineWidth
//{
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, lineWidth, 0.5)];
//    [line setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_LineColor1]];
//    return line;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)SetContentToCell:(id)data markHide:(BOOL)hide
{
    if ([data isKindOfClass:[EHBabyFamilyPhone class]]) {
        EHBabyFamilyPhone *model = (EHBabyFamilyPhone *)data;
        self.nickNameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
       // self.rankImage.hidden = YES;
        self.selectImage.hidden = hide;
        //self.markButton.hidden = hide;
        self.nickNameLabel.text = model.relationship;
        self.phoneLabel.text = model.phoneNumber;
        self.arrowImage.hidden=!hide;
    }else {
        self.nickNameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
     //   self.rankImage.hidden = NO;
        self.selectImage.hidden = YES;
        self.arrowImage.hidden=NO;
        //self.markButton.hidden = YES;
        self.nickNameLabel.text = @"";
        self.phoneLabel.text = @"";
    }
}

@end
