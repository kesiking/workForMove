//
//  EHRemindListTableViewCell.m
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemindListTableViewCell.h"
#import "NSString+StringSize.h"

#define kSpace 12

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
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.workDataLabel];
        [self.contentView addSubview:self.isRepeatLabel];
        [self.contentView addSubview:self.isActiveSwitch];
    }
    return self;
}

- (void)configWithRemindModel:(EHRemindViewModel *)remindModel RemindType:(EHRemindType)remindType{
    _remindType = remindType;
    self.timeLabel.text = remindModel.time;
    self.workDataLabel.text = remindModel.date;
    self.isRepeatLabel.text = [remindModel.is_repeat boolValue]?@"重复":@"仅一次";
    self.isActiveSwitch.on = [remindModel.is_active boolValue];
    
//    if (remindType == EHRemindTypeBaby) {
//        [self.commentsLabel removeFromSuperview];
//        [self.contentView addSubview:self.commentsLabel];
//        self.commentsLabel.text = remindModel.context;
//        self.commentsLabel.text= [remindModel.is_repeat boolValue]?@"重复":@"仅一次";
//    }
}

#pragma mark - Events Response
- (void)_isActiveButtonClick:(id)sender {
    self.isActiveButton.selected = !self.isActiveButton.selected;
    //判断代码块是否存在
    !self.activeStatusChangeBlock?:self.activeStatusChangeBlock(self.isActiveButton.selected);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    
    CGFloat _subViewHeight = [@"text" sizeWithFontSize:EHSiz5 Width:MAXFLOAT].height;
    CGFloat _subViewY1 = (cellHeight - _subViewHeight * 2) / 3.0;
    CGFloat _subViewY2 = _subViewY1 * 2 + _subViewHeight;

    //时间
    _timeLabelHeight = [@"text" sizeWithFontSize:EHSiz1 Width:MAXFLOAT].height;
    _timeLabelY = (cellHeight - _timeLabelHeight) / 2.0;
    CGRect timeLabelFrame = CGRectMake(0, 0, 80, cellHeight);

    //竖线
    CGRect lineViewFrame = CGRectMake(CGRectGetMaxX(timeLabelFrame) - 0.5, 0, 0.5, CGRectGetHeight(self.frame));
    
    //一周
    CGFloat workDataLabelWidth = [_workDataLabel.text sizeWithFontSize:EHSiz5 Width:MAXFLOAT].width;
    CGRect workDataLabelFrame = CGRectMake(CGRectGetMaxX(timeLabelFrame) + kSpace, _subViewY1, workDataLabelWidth, _subViewHeight);
    
    //开关
    CGRect isActiveSwitchFrame = CGRectMake(CGRectGetWidth(self.frame) - kSpace - 45, (cellHeight - 25) / 2.0, 45, 25);

    //重复、备注
    CGRect isRepeatLabelFrame;
    CGRect commentsLabelFrame;
 //   if (_remindType == EHRemindTypeGeofence) {
        isRepeatLabelFrame = CGRectMake(CGRectGetMaxX(timeLabelFrame) + kSpace, _subViewY2, 60, _subViewHeight);
        commentsLabelFrame = CGRectZero;
//    }
//    else {
//        isRepeatLabelFrame = CGRectMake(CGRectGetMaxX(workDataLabelFrame) + kSpace, _subViewY1, 60, _subViewHeight);
//        CGFloat commentsLabelWidth =(CGRectGetWidth(self.frame) - CGRectGetWidth(timeLabelFrame) - CGRectGetWidth(isActiveSwitchFrame) - kSpace * 2);
//        commentsLabelFrame = CGRectMake(CGRectGetMaxX(timeLabelFrame) + kSpace, _subViewY2, commentsLabelWidth, _subViewHeight);
//    }
    
    self.timeLabel.frame = timeLabelFrame;
    self.lineView.frame = lineViewFrame;
    self.workDataLabel.frame = workDataLabelFrame;
    self.isActiveSwitch.frame = isActiveSwitchFrame;
    self.isRepeatLabel.frame = isRepeatLabelFrame;
  //  self.commentsLabel.frame = commentsLabelFrame;
}

#pragma mark - Getters And Setters
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = EHFont1;
        _timeLabel.textColor = EHCor5;
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    }
    return _lineView;
}

- (UILabel *)workDataLabel {
    if (!_workDataLabel) {
        _workDataLabel = [[UILabel alloc]init];
        _workDataLabel.textAlignment = NSTextAlignmentLeft;
        _workDataLabel.font = EHFont5;
        _workDataLabel.textColor = EHCor4;
    }
    return _workDataLabel;
}

- (UILabel *)isRepeatLabel {
    if (!_isRepeatLabel) {
        _isRepeatLabel = [[UILabel alloc]init];
        _isRepeatLabel.textAlignment = NSTextAlignmentLeft;
        _isRepeatLabel.font = EHFont5;
        _isRepeatLabel.textColor = EHCor4;
    }
    return _isRepeatLabel;
}

- (UILabel *)commentsLabel {
    if (!_commentsLabel) {
        _commentsLabel = [[UILabel alloc]init];
        _commentsLabel.textAlignment = NSTextAlignmentLeft;
        _commentsLabel.font = EHFont5;
        _commentsLabel.textColor = EHCor4;
        
    }
    return _commentsLabel;
}

-(EHSwitch *)isActiveSwitch {
    if (!_isActiveSwitch) {
        _isActiveSwitch = [[EHSwitch alloc]init];
        WEAKSELF
        _isActiveSwitch.switchChangedBlock = ^(BOOL on){
            !weakSelf.activeStatusChangeBlock?:weakSelf.activeStatusChangeBlock(on);
            NSLog(@"on? - %d",on);
        };
    }
    return _isActiveSwitch;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
