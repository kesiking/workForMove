//
//  EHMessageAttentionView.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageAttentionView.h"

@interface EHMessageAttentionView()

@property (nonatomic, strong) UIImageView           *bgImageView;

@property (nonatomic, strong) UIImageView           *iconImageView;

@property (nonatomic, strong) UIButton              *closeBtn;

@property (nonatomic, strong) UIButton              *bgBtn;

@property (nonatomic, strong) UILabel               *messageLabel;

@property (nonatomic, strong) NSMutableDictionary   *messageDisableDict;

@end

@implementation EHMessageAttentionView

-(void)setupView{
    [super setupView];
    [self initSubviewLayer];
    [self initMessageDisableDict];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.hidden = YES;
}

-(void)initSubviewLayer{
//    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    [self addSubview:_bgImageView];
    
    _bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [_bgBtn addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bgBtn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_bgBtn];
    
    _messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [_messageLabel setTextColor:EH_cor1];
    [_messageLabel setFont:[UIFont systemFontOfSize:12]];
    [_messageLabel setTextAlignment:NSTextAlignmentCenter];
    [_messageLabel setNumberOfLines:1];
    [self addSubview:_messageLabel];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height - 14)/2, 14, 14)];
    [_iconImageView setImage:[UIImage imageNamed:@"ico_dropdown_cautionpoint"]];
    [self addSubview:_iconImageView];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 20 - 20, (self.height - 20)/2, 20, 20)];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"ico_delete"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
}

-(void)initMessageDisableDict{
    self.messageDisableDict = [NSMutableDictionary dictionary];
}

-(NSString*)getDisableDictKey{
    NSString* currentBabyId = [[EHBabyListDataCenter sharedCenter] currentBabyId];
    return [NSString stringWithFormat:@"%@_%ld",currentBabyId,(long)self.messageAttentionType];
}

-(BOOL)canAttentionViewShow{
    return self.messageAttentionType == EHMessageAttentionType_None ? YES : ![[self.messageDisableDict objectForKey:[self getDisableDictKey]] boolValue];
}

-(void)closeButtonClicked:(id)sender{
    self.hidden = YES;
    // 关闭过记录下来，下次不再打开
    [self.messageDisableDict setObject:@YES forKey:[self getDisableDictKey]];
    // 关闭的回调
    if (self.attentionCloseClickedBlock) {
        self.attentionCloseClickedBlock();
    }
}

-(void)bgButtonClicked:(id)sender{
    if (self.attentionViewClickedBlock) {
        self.attentionViewClickedBlock();
    }
}

-(void)setMessageInfo:(NSString*)message{
    [self.messageLabel setText:message];
    [self.messageLabel sizeToFit];
    [self layoutIfNeeded];
}

-(void)setMessageIconShow:(BOOL)show{
    self.iconImageView.hidden = !show;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.messageLabel setOrigin:CGPointMake((self.width - self.messageLabel.width)/2, (self.height - self.messageLabel.height)/2)];
    [self.iconImageView setOrigin:CGPointMake(self.messageLabel.left - self.iconImageView.width - 5, (self.height - self.iconImageView.height)/2)];
    [self.closeBtn setOrigin:CGPointMake(self.width - self.closeBtn.width - 20, (self.height - self.closeBtn.height)/2)];
    [self.bgBtn setFrame:self.bounds];
}

@end
