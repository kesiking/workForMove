//
//  EHRemindListTableViewCell.m
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemindListTableViewCell.h"
#import "SevenSwitch.h"
#import "NSString+StringSize.h"

@interface EHRemindListTableViewCell()

@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UILabel  *workDataLabel;
@property (nonatomic, strong) UILabel  *isRepeatLabel;
@property (nonatomic, strong) UILabel  *commentsLabel;

@end

@implementation EHRemindListTableViewCell
{
    EHRemindType _remindType;
    CGFloat _timeLabelHeight;
    CGFloat _timeLabelY;
    CGFloat _subViewHeight;
    CGFloat _subViewY;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.workDataLabel];
        [self.contentView addSubview:self.isRepeatLabel];
        [self.contentView addSubview:self.isActiveButton];
    }
    return self;
}

- (void)configWithRemindModel:(EHRemindViewModel *)remindModel RemindType:(EHRemindType)remindType{
    _remindType = remindType;
    self.timeLabel.text = remindModel.time;
    self.workDataLabel.text = remindModel.date;
    self.isRepeatLabel.text = [remindModel.is_repeat boolValue]?@"重复":@"仅一次";
    self.isActiveButton.selected = [remindModel.is_active boolValue];
    
    if (remindType == EHRemindTypeBaby) {
        [self.commentsLabel removeFromSuperview];
        [self.contentView addSubview:self.commentsLabel];
        self.commentsLabel.text = remindModel.context;
    }
}

#pragma mark - Events Response
- (void)_isActiveButtonClick:(id)sender {
    self.isActiveButton.selected = !self.isActiveButton.selected;
    //判断代码块是否存在
    !self.activeStatusChangeBlock?:self.activeStatusChangeBlock(self.isActiveButton.selected);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _timeLabelHeight = [@"text" sizeWithFontSize:EH_siz3 Width:MAXFLOAT].height;
    _timeLabelY = (kCellHeight - _timeLabelHeight) / 2.0;
    CGRect timeLabelFrame = CGRectMake(kSpaceX, _timeLabelY, 60, _timeLabelHeight);

    CGRect lineViewFrame = CGRectMake(CGRectGetMaxX(timeLabelFrame) - 0.5, 0, 0.5, CGRectGetHeight(self.frame));
    
    _subViewHeight = [@"text" sizeWithFontSize:EH_siz5 Width:MAXFLOAT].height;
    if (_remindType == EHRemindTypeGeofence) {
        _subViewY = (kCellHeight - _subViewHeight) / 2.0;
    }
    else {
        _subViewY = (kCellHeight - _subViewHeight * 2) / 3.0;
        self.commentsLabel.frame = CGRectMake(CGRectGetMaxX(timeLabelFrame) + kSpaceX, _subViewY * 2 + _subViewHeight, 200, _subViewHeight);
    }
    
    CGFloat workDataLabelWidth = [_workDataLabel.text sizeWithFontSize:EH_siz5 Width:MAXFLOAT].width;
    CGRect workDataLabelFrame = CGRectMake(CGRectGetMaxX(timeLabelFrame) + kSpaceX, _subViewY, workDataLabelWidth, _subViewHeight);
    
    CGRect isRepeatLabelFrame = CGRectMake(CGRectGetMaxX(workDataLabelFrame) + kSpaceX, _subViewY, 60, _subViewHeight);
    
    CGRect isActiveButtonFrame = CGRectMake(CGRectGetWidth(self.frame) - kSpaceX - 20, (kCellHeight - 20) / 2.0, 20, 20);
    
    self.timeLabel.frame = timeLabelFrame;
    self.lineView.frame = lineViewFrame;
    self.workDataLabel.frame = workDataLabelFrame;
    self.isRepeatLabel.frame = isRepeatLabelFrame;
    self.isActiveButton.frame = isActiveButtonFrame;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = EH_font3;
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UILabel *)workDataLabel {
    if (!_workDataLabel) {
        _workDataLabel = [[UILabel alloc]init];
        _workDataLabel.textAlignment = NSTextAlignmentLeft;
        _workDataLabel.font = EH_font5;
    }
    return _workDataLabel;
}

- (UILabel *)isRepeatLabel {
    if (!_isRepeatLabel) {
        _isRepeatLabel = [[UILabel alloc]init];
        _isRepeatLabel.textAlignment = NSTextAlignmentLeft;
        _isRepeatLabel.font = EH_font5;
    }
    return _isRepeatLabel;
}

- (UILabel *)commentsLabel {
    if (!_commentsLabel) {
        _commentsLabel = [[UILabel alloc]init];
        _commentsLabel.textAlignment = NSTextAlignmentLeft;
        _commentsLabel.font = EH_font5;
    }
    return _commentsLabel;
}

- (UIButton *)isActiveButton {
    if (!_isActiveButton) {
        _isActiveButton = [[UIButton alloc]init];
        [_isActiveButton setImage:[UIImage imageNamed:@"btn_checkbox_normal"] forState:UIControlStateNormal];
        [_isActiveButton setImage:[UIImage imageNamed:@"btn_checkbox_press"] forState:UIControlStateSelected];
        [_isActiveButton addTarget:self action:@selector(_isActiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _isActiveButton.selected = YES;
    }
    return _isActiveButton;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
