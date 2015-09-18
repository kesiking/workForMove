//
//  EHBabyMessageTableViewCell.m
//  eHome
//
//  Created by 孟希羲 on 15/9/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyMessageTableViewCell.h"
#import "XHBabyChatMessage.h"

@interface EHBabyMessageTableViewCell()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UIButton             *faileSendButton;

@end

@implementation EHBabyMessageTableViewCell

-(instancetype)initWithMessage:(id<XHMessageModel>)message displaysTimestamp:(BOOL)displayTimestamp reuseIdentifier:(NSString *)cellIdentifier{
    self = [super initWithMessage:message displaysTimestamp:displayTimestamp reuseIdentifier:cellIdentifier];
    if (self) {
        // 1、是否显示更新
        if (!_activityIndicatorView) {
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            CGRect bubbleFrame = [self.messageBubbleView bubbleFrame];
            CGRect frame = CGRectMake(bubbleFrame.origin.x - activityIndicatorView.width,
                                      self.avatarButton.origin.y + (self.avatarButton.height - activityIndicatorView.height)/2,
                                      activityIndicatorView.width,
                                      activityIndicatorView.height);
            
            [activityIndicatorView setFrame:frame];
            [self.contentView addSubview:activityIndicatorView];
            [self.contentView bringSubviewToFront:activityIndicatorView];
            _activityIndicatorView = activityIndicatorView;
        }
        
        if (!_faileSendButton) {
            UIButton *faileSendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            CGRect bubbleFrame = [self.messageBubbleView bubbleFrame];
            CGRect frame = CGRectMake(bubbleFrame.origin.x - faileSendButton.width,
                                      self.avatarButton.origin.y + (self.avatarButton.height - faileSendButton.height)/2,
                                      faileSendButton.width,
                                      faileSendButton.height);
            
            [faileSendButton setFrame:frame];
            faileSendButton.hidden = YES;
            [faileSendButton setBackgroundImage:[UIImage imageNamed:@"question_mark.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:faileSendButton];
            [self.contentView bringSubviewToFront:faileSendButton];
            _faileSendButton = faileSendButton;
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect bubbleFrame = [self.messageBubbleView bubbleFrame];
    CGRect activityIndicatorViewFrame = CGRectMake(bubbleFrame.origin.x - self.activityIndicatorView.width,
                                                   self.messageBubbleView.origin.y + (self.messageBubbleView.height - self.faileSendButton.height)/2,
                                                   self.activityIndicatorView.width,
                                                   self.activityIndicatorView.height);
    [self.activityIndicatorView setFrame:activityIndicatorViewFrame];
    
    CGRect failSendButtonFrame = CGRectMake(bubbleFrame.origin.x - self.faileSendButton.width,
                                            self.messageBubbleView.origin.y + (self.messageBubbleView.height - self.faileSendButton.height)/2,
                                            self.faileSendButton.width,
                                            self.faileSendButton.height);
    [self.faileSendButton setFrame:failSendButtonFrame];
}

- (void)configureCellWithMessage:(id <XHMessageModel>)message
               displaysTimestamp:(BOOL)displayTimestamp {
    // 1、是否显示Time Line的label
    [super configureCellWithMessage:message displaysTimestamp:displayTimestamp];
    [self configureActivityIndicatorView:message];
}

-(void)configureActivityIndicatorView:(id <XHMessageModel>)message{
    if (![message isKindOfClass:[XHBabyChatMessage class]]) {
        return;
    }
    XHBabyChatMessage* chatMessage = (XHBabyChatMessage*)message;
    self.faileSendButton.hidden = YES;
    if (chatMessage.bubbleMessageType == XHBubbleMessageTypeReceiving) {
        [self stopAnimating];
        return;
    }
    switch (chatMessage.msgStatus) {
        case EHBabyChatMessageStatusSending:
            [self startAnimating];
            break;
        case EHBabyChatMessageStatusFailed:
            self.faileSendButton.hidden = NO;
            [self stopAnimating];
            break;
        case EHBabyChatMessageStatusSent:
        default:
            [self stopAnimating];
            break;
    }
}

-(void)startAnimating{
    [self.activityIndicatorView startAnimating];
}

- (void)stopAnimating{
    [self.activityIndicatorView stopAnimating];
}

@end
