//
//  EHRemindDateTableViewCell.m
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemindDateTableViewCell.h"

#define kBtnSpace 10
#define kSubViewTag   100

@implementation EHRemindDateTableViewCell
{
    NSMutableString *_dateStr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dateStr = [[NSMutableString alloc]initWithString:@"0000000"];
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        dateLabel.tag = kSubViewTag;
        dateLabel.text = @"日期";
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:dateLabel];
        
        NSArray *dateArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];
        
        for (NSInteger i = 1; i < 8; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.tag = kSubViewTag +i;
            [btn setTitle:dateArray[i - 1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.layer.borderWidth = 0.3;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
    }
    return self;
}

- (void)selectWorkDate:(NSString *)work_date {
    _dateStr = [work_date mutableCopy];
    for (NSInteger i = 1; i < 8; i++) {
        NSRange range = NSMakeRange(i-1, 1);
        BOOL selectedStatus = [[work_date substringWithRange:range] integerValue];
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:(kSubViewTag + i)];
        btn.selected = selectedStatus;
        if (btn.selected) {
            btn.backgroundColor = [UIColor blueColor];
        }
        else {
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor blueColor];
    }
    else {
        btn.backgroundColor = [UIColor whiteColor];
    }
    EHLogInfo(@"click - %ld",btn.tag - kSubViewTag);
    NSRange range = NSMakeRange(btn.tag - kSubViewTag - 1, 1);
    [_dateStr replaceCharactersInRange:range withString:[@(btn.selected) stringValue]];
    !self.dateBtnClickBlock?:self.dateBtnClickBlock((NSString *)_dateStr);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UILabel *label = (UILabel *)[self.contentView viewWithTag:kSubViewTag];
    label.frame = CGRectMake(kSpaceX, kSpaceX, 100, 20);
    
    
    CGFloat btnWidth = (CGRectGetWidth(self.frame) - kBtnSpace * 8) / 7;
    CGFloat btnY = CGRectGetMaxY(label.frame) + (CGRectGetHeight(self.frame) - CGRectGetMaxY(label.frame) - btnWidth) / 2.0;
    CGFloat btnX;
    for (NSInteger i = 1; i < 8; i++) {
        btnX = kBtnSpace + (kBtnSpace + btnWidth) * (i - 1);
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
