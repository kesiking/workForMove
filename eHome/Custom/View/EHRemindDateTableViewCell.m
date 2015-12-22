//
//  EHRemindDateTableViewCell.m
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemindDateTableViewCell.h"
#import "NSString+StringSize.h"

#define kBtnSpace 11
#define kSideSpace 12

#define kSubViewTag   100

@implementation EHRemindDateTableViewCell
{
    NSMutableString *_changedDateStr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _changedDateStr = [[NSMutableString alloc]initWithString:@"0000000"];
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        dateLabel.tag = kSubViewTag;
        dateLabel.font = EHFont2;
        dateLabel.textColor = EHCor5;
        dateLabel.text = @"日期";
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:dateLabel];
        
        NSArray *dateArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];
        
        for (NSInteger i = 1; i < 8; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.tag = kSubViewTag +i;
            [btn setTitle:dateArray[i - 1] forState:UIControlStateNormal];
            btn.titleLabel.font = EHFont2;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_day_off"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_day_on"] forState:UIControlStateSelected];

            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.layer.borderWidth = 0.3;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
    }
    return self;
}


//work_date格式为"1111111"，从周日开始到周六
- (void)selectWorkDate:(NSString *)work_date {
    //先将第一天的周日移到最后方便处理
//    NSString *changedWorkDate = [NSString stringWithFormat:@"%@%@",[work_date substringFromIndex:1],[work_date substringToIndex:1]];
//    _changedDateStr = [changedWorkDate mutableCopy];
    _changedDateStr=[work_date mutableCopy];
    for (NSInteger i = 1; i < 8; i++) {
        NSRange range = NSMakeRange(i-1, 1);
        BOOL selectedStatus = [[work_date substringWithRange:range] integerValue];
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:(kSubViewTag + i)];
        btn.selected = selectedStatus;
    }
}

- (void)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;

    NSRange range = NSMakeRange(btn.tag - kSubViewTag - 1, 1);
    [_changedDateStr replaceCharactersInRange:range withString:[@(btn.selected) stringValue]];
  //  NSString *dateStr = [NSString stringWithFormat:@"%@%@",[_changedDateStr substringFromIndex:6],[_changedDateStr substringToIndex:6]];
    !self.dateBtnClickBlock?:self.dateBtnClickBlock(_changedDateStr);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelHeight = [@"text" sizeWithFontSize:EHSiz2 Width:CGRectGetWidth(self.frame)].height;
    UILabel *label = (UILabel *)[self.contentView viewWithTag:kSubViewTag];
    label.frame = CGRectMake(12, 15, CGRectGetWidth(self.frame), labelHeight);
    
    
    CGFloat btnWidth = (CGRectGetWidth(self.frame) - kBtnSpace * 6 - kSideSpace * 2) / 7;
    CGFloat btnY = CGRectGetMaxY(label.frame) + 21;
    CGFloat btnX;
    for (NSInteger i = 1; i < 8; i++) {
        btnX = kSideSpace + (kBtnSpace + btnWidth) * (i - 1);
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:(kSubViewTag + i)];
        btn.frame = CGRectMake(btnX, btnY, btnWidth, btnWidth);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btnWidth / 2.0;
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
