//
//  EHAlarmCommentTableViewCell.m
//  eHome
//
//  Created by jinmiao on 15/9/28.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHAlarmCommentTableViewCell.h"
#import "Masonry.h"

@interface EHAlarmCommentTableViewCell ()<UITextViewDelegate>

@property (strong,nonatomic) UILabel *commentLabel;
@property (strong,nonatomic) UILabel *characterCountLable;
@property (strong,nonatomic) UILabel *commentPlaceHolder;
@property (strong,nonatomic) UITextView *commentTextView;
@property (strong,nonatomic) UIImageView *characterCountImageView;
@property (assign,nonatomic) BOOL isTextViewEmpty;

@end

@implementation EHAlarmCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.characterCountImageView];
        [self.contentView addSubview:self.characterCountLable];
        
        [self.contentView addSubview:self.commentTextView];
        self.isTextViewEmpty = YES;
        [self addConstraints];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)addConstraints{
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.left.equalTo(self.contentView.mas_left).with.offset(12);
    }];
    
    [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        //make.size.mas_equalTo(CGSizeMake(self.contentView.width - 24, 80));
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-12);
        
    }];
    
    [_characterCountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
    }];
    
    [_characterCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.size.mas_equalTo(CGSizeMake(60, 22));
        
    }];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (_isTextViewEmpty) {
        textView.text = nil;
        textView.textColor = EHCor5;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = @"输入备注内容";
        textView.textColor = EHCor3;
        _isTextViewEmpty = YES;
    }
    else {
        _isTextViewEmpty = NO;
    }
    
    
//    self.commentAddBlock(self.commentTextView.text);
//    !self.commentAddBlock?:self.dateBtnClickBlock((NSS);

}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.commentTextView.markedTextRange == nil && self.commentTextView.text.length > 30 ) {
        NSString *subString = [self.commentTextView.text substringToIndex:30];
        self.commentTextView.text = subString;
    }
    _characterCountLable.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)_commentTextView.text.length];
    !self.commentAddBlock?:self.commentAddBlock(self.commentTextView.text);

}

- (NSString *)comment {
    
    return self.commentTextView.text;
}

- (void)setComment:(NSString *)comment {
    self.commentTextView.text = comment;
    
    self.characterCountLable.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)comment.length];
    
    if (comment.length == 0) {
        self.commentTextView.text = @"输入备注内容";
        self.commentTextView.textColor = EHCor3;
        _isTextViewEmpty = YES;
    }
    else {
        self.commentTextView.textColor = EHCor5;
        _isTextViewEmpty = NO;
    }
    
}

-(UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel  = [[UILabel alloc]init];
        _commentLabel.font = EHFont2;
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        _commentLabel.textColor = EHCor5;
        _commentLabel.text = @"备注";
    }
    return _commentLabel;
}

-(UILabel *)characterCountLable{
    if (!_characterCountLable) {
        _characterCountLable = [[UILabel alloc]init];
        _characterCountLable.textAlignment = NSTextAlignmentCenter;
        _characterCountLable.font = EHFont5;
        _characterCountLable.textColor = EHCor3;
    }
    return _characterCountLable;
}

-(UITextView *)commentTextView{
    if (!_commentTextView) {
        _commentTextView = [[UITextView alloc]init];
        _commentTextView.textAlignment = NSTextAlignmentLeft;
        _commentTextView.font = EHFont5;
        _commentTextView.textColor = EHCor3;
        _commentTextView.text = @"输入备注内容";
        _commentTextView.delegate = self;
    }
    return _commentTextView;
}

//-(UILabel *)commentPlaceHolder{
//    if (!_commentPlaceHolder) {
//        _commentPlaceHolder = [[UILabel alloc]init];
//        _commentPlaceHolder.textAlignment = NSTextAlignmentLeft;
//        _commentPlaceHolder.font = EHFont5;
//        _commentPlaceHolder.textColor = EHCor3;
//        _commentPlaceHolder.text = @"输入备注内容";
//        _commentPlaceHolder.enabled = NO;
//        _commentPlaceHolder.layer.borderWidth = 1;
//        
//    }
//    return _commentPlaceHolder;
//}

-(UIImageView *)characterCountImageView{
    if (!_characterCountImageView) {
        _characterCountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_number"]];
    }
    return _characterCountImageView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
