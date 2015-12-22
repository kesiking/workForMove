//
//  EHFeedbackTextView.m
//  eHome
//
//  Created by xtq on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#define kTextViewSpaceX 7
#define kTextViewSpaceY 7
#define kBtnWidth       135/2.0
#define kMaxLineCount   5
#define kMaxWordCount   280

#import "EHFeedbackTextView.h"

@interface EHFeedbackTextView()<UITextViewDelegate>

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)UIButton *sendButton;

@end

@implementation EHFeedbackTextView
{
    CGFloat _singleLineHeight;      //单行的高度
    CGFloat _textViewHeight;        //textView的动态高度
    CGFloat _minTextViewHeight;     //textView的最小高度
    NSInteger _lineNum;             //动态行数
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = EHBgcor1;
        _singleLineHeight = [self singlLineHeight];
        _textViewHeight = kTextViewHeight - kTextViewSpaceY * 2;
        _minTextViewHeight = _textViewHeight;
        _lineNum = 1;
        
        [self addSubview:self.textView];
        [self addSubview:self.sendButton];
        
        CALayer *separatorLineLayer = [CALayer layer];
        separatorLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.5);
        separatorLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:separatorLineLayer];
        
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
            [WeAppToast toast:@"意见反馈最多支持280个字"];
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
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(kTextViewSpaceX, kTextViewSpaceY, CGRectGetWidth(self.frame) - kBtnWidth - kTextViewSpaceX * 3, CGRectGetHeight(self.frame) - kTextViewSpaceY * 2)];
        _textView.font = EH_font3;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.backgroundColor = EHCor1;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 3;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = EHLinecor1.CGColor;
    }
    return _textView;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn_send_h"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn_send_s"] forState:UIControlStateHighlighted];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn_send_d"] forState:UIControlStateDisabled];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = EHFont2;
        [_sendButton setTitleColor:EHCor1 forState:UIControlStateNormal];
        [_sendButton setTitleColor:EHCor5 forState:UIControlStateDisabled];
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
    _textView.frame = CGRectMake(kTextViewSpaceX, kTextViewSpaceY, CGRectGetWidth(self.frame) - kBtnWidth - kTextViewSpaceX * 3, CGRectGetHeight(self.frame) - kTextViewSpaceY * 2);
    CGFloat btnHeight = kTextViewHeight - kTextViewSpaceY * 2;
    _sendButton.frame = CGRectMake(CGRectGetWidth(self.frame) - kTextViewSpaceX - kBtnWidth, CGRectGetHeight(self.frame) - btnHeight - kTextViewSpaceY, kBtnWidth, btnHeight);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
