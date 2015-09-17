//
//  EHFeedbackTextView.m
//  eHome
//
//  Created by xtq on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#define kTextViewSpaceX 15
#define kTextViewSpaceY 8
#define kMaxLineCount   5
#define kMaxWordCount   280

#import "EHFeedbackTextView.h"

@interface EHFeedbackTextView()<UITextViewDelegate>

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)UIImageView *lineView;

@property (nonatomic, strong)UIButton *sendButton;

@end

@implementation EHFeedbackTextView
{
    CGFloat _singleLineHeight;
    CGFloat _textViewHeight;
    CGFloat _minTextViewHeight;
    NSInteger _lineNum;
    CGRect _initFrame;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _initFrame = frame;
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"input_feedback_send"];
        _singleLineHeight = [self singlLineHeight];
        NSLog(@"_singleLineHeight = %f",_singleLineHeight);
        _textViewHeight = kTextViewHeight - 1 - kTextViewSpaceY * 2;
        _minTextViewHeight = _textViewHeight;
        _lineNum = 1;
        
        [self addSubview:self.textView];
        [self addSubview:self.lineView];
        [self addSubview:self.sendButton];
        self.sendButton.enabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - Events Response
- (void)sendButtonClick:(id)sender{
    !self.sendBlock?:self.sendBlock(self.textView.text);
}

#pragma mark - UITextViewDelegate
- (void)textViewTextChanged:(NSNotification *)notification{
    UITextView* textView = [notification object];
    
    if (textView.text.length > 0) {
        self.sendButton.enabled = YES;
        if (textView.markedTextRange == nil && textView.text.length > kMaxWordCount) {
            NSString *substring = [textView.text substringToIndex:kMaxWordCount];
            textView.text = substring;
            return;
        }
    }
    else {
        self.sendButton.enabled = NO;
    }
    
    CGSize size = [textView.text sizeWithAttributes:@{NSFontAttributeName:self.textView.font}];
    NSInteger length = size.height;
    
    NSInteger nnum = [[textView.text componentsSeparatedByString:@"\n"] count]-1;
    NSInteger rnum = [[textView.text componentsSeparatedByString:@"\r"] count]-1;
    
    NSInteger lineNumber = textView.contentSize.height/length + nnum + rnum;
    if (_lineNum != lineNumber) {
        CGFloat height;
        if (lineNumber < kMaxLineCount) {
            height = MAX(_minTextViewHeight, _singleLineHeight * lineNumber);
        }
        else {
            height = _singleLineHeight * kMaxLineCount;
        }
        [self resetFrameWithHeight:height];
        _lineNum = lineNumber;
    }

    CGFloat y = _textView.contentSize.height - _textView.bounds.size.height - 8.32400;
    y = MAX(0, y);
    [self.textView setContentOffset:CGPointMake(0, y) animated:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods
- (void)resetFrameWithHeight:(CGFloat)height{
    CGFloat offset = height - _textViewHeight;
    _textViewHeight = height;
    
    CGRect frame = self.frame;
    frame.origin.y -= offset;
    frame.size.height += offset;
        self.frame = frame;
    
    !self.frameChangedBlock?:self.frameChangedBlock(offset);
}

- (void)finishSend{
    self.textView.text = nil;
    self.sendButton.enabled = NO;
    [self resetFrameWithHeight:_minTextViewHeight];
}

#pragma mark - Getters And Setters
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(kTextViewSpaceX, 1 + kTextViewSpaceY, CGRectGetWidth(self.frame) - kTextViewHeight - kTextViewSpaceX * 2, _minTextViewHeight)];
        _textView.font = EH_font3;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_ico_feedback"]];
    }
    return _lineView;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setImage:[UIImage imageNamed:@"ico_feedback_send_press"] forState:UIControlStateNormal];
        [_sendButton setImage:[UIImage imageNamed:@"ico_feedback_send_normal"] forState:UIControlStateDisabled];
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (CGFloat)singlLineHeight{
    NSString *textString = @"Text";
    CGSize fontSize = [textString sizeWithAttributes:@{NSFontAttributeName:self.textView.font}];
    return fontSize.height;
}

#pragma mark - Common Methods
- (void)layoutSubviews{
    [super layoutSubviews];
    _textView.frame = CGRectMake(kTextViewSpaceX, 1 + kTextViewSpaceY, CGRectGetWidth(self.frame) - kTextViewHeight - kTextViewSpaceX * 2, CGRectGetHeight(self.frame) - 1 - kTextViewSpaceY * 2);
    _lineView.frame = CGRectMake(CGRectGetWidth(self.frame) - 51, (CGRectGetHeight(self.frame) - kTextViewHeight) / 2.0, 1, kTextViewHeight);
    _sendButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, (CGRectGetHeight(self.frame) - kTextViewHeight) / 2.0, kTextViewHeight - 1, kTextViewHeight -1);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
