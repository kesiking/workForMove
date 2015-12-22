//
//  EHBabyMessageTableViewCell.m
//  eHome
//
//  Created by 孟希羲 on 15/9/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyMessageTableViewCell.h"
#import "XHBabyChatMessage.h"
#import "EHAudioPlayDownLoader.h"
#import "EHAleatView.h"

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
                                      self.messageBubbleView.origin.y + (self.messageBubbleView.height - activityIndicatorView.height)/2,
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
                                      self.messageBubbleView.origin.y + (self.messageBubbleView.height - faileSendButton.height)/2,
                                      faileSendButton.width,
                                      faileSendButton.height);
            
            [faileSendButton setFrame:frame];
            faileSendButton.hidden = YES;
            [faileSendButton setImage:[UIImage imageNamed:@"icon_messagefail"] forState:UIControlStateNormal];
            [faileSendButton setImageEdgeInsets:UIEdgeInsetsMake((faileSendButton.height - 14)/2, (faileSendButton.width - 14)/2, (faileSendButton.height - 14)/2, (faileSendButton.width - 14)/2)];
            [faileSendButton addTarget:self action:@selector(faileSendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:faileSendButton];
            [self.contentView bringSubviewToFront:faileSendButton];
            _faileSendButton = faileSendButton;
        }
        [self.messageBubbleView.bubbleImageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.messageBubbleView.voiceDurationLabel addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.userNameLabel setTextColor:RGB(0x99, 0x99, 0x99)];
    }
    return self;
}

-(void)dealloc{
    [self.messageBubbleView.bubbleImageView removeObserver:self forKeyPath:@"frame"];
    [self.messageBubbleView.voiceDurationLabel removeObserver:self forKeyPath:@"frame"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateMessageFrame];
}

-(void)updateMessageFrame{
//    CGRect bubbleFrame = [self.messageBubbleView bubbleFrame];
    CGRect bubbleImageViewFrame = [self.messageBubbleView.bubbleImageView convertRect:self.messageBubbleView.bubbleImageView.bounds toView:self.contentView];
    if (CGRectEqualToRect(bubbleImageViewFrame, CGRectZero)) {
        return;
    }
    CGFloat border = self.messageBubbleView.voiceDurationLabel.hidden ? 0 : self.messageBubbleView.voiceDurationLabel.width;
    CGRect activityIndicatorViewFrame = CGRectMake(bubbleImageViewFrame.origin.x - self.activityIndicatorView.width - border - 5,
                                                   bubbleImageViewFrame.origin.y + (bubbleImageViewFrame.size.height - self.activityIndicatorView.height)/2,
                                                   self.activityIndicatorView.width,
                                                   self.activityIndicatorView.height);
    [self.activityIndicatorView setFrame:activityIndicatorViewFrame];
    
    CGRect failSendButtonFrame = CGRectMake(bubbleImageViewFrame.origin.x - self.faileSendButton.width - border - 5,
                                            bubbleImageViewFrame.origin.y + (bubbleImageViewFrame.size.height - self.faileSendButton.height)/2,
                                            self.faileSendButton.width,
                                            self.faileSendButton.height);
    [self.faileSendButton setFrame:failSendButtonFrame];
}

- (void)configureCellWithMessage:(id <XHMessageModel>)message
               displaysTimestamp:(BOOL)displayTimestamp {
    
    // 根据表情编码message.text，获取本地的表情图片
    if(((XHBabyChatMessage*)message).messageMediaType == XHBubbleMessageMediaTypePhoto)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EHChatEmotionEncode" ofType:@"plist"];
        NSDictionary *emotionsDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        NSDictionary *modelDic = [emotionsDic objectForKey:((XHBabyChatMessage*)message).text];
        NSString *imageName = [modelDic objectForKey:@"imageName"];
        ((XHBabyChatMessage*)message).photo = [UIImage imageNamed: imageName];
    }
    // 1、是否显示Time Line的label
    [super configureCellWithMessage:message displaysTimestamp:displayTimestamp];
    [self configureActivityIndicatorView:message];
    [self downLoadAudioPlayData:message];
}

- (void)configUserNameWithMessage:(id <XHMessageModel>)message {
    if (![message isKindOfClass:[XHBabyChatMessage class]]) {
        [super configUserNameWithMessage:message];
        return;
    }
    XHBabyChatMessage* chatMessage = (XHBabyChatMessage*)message;
    self.userNameLabel.text = [chatMessage user_nick_name];
    self.userNameLabel.hidden = !chatMessage.shouldShowUserName;
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

-(void)downLoadAudioPlayData:(id <XHMessageModel>)message{
    if (![message isKindOfClass:[XHBabyChatMessage class]]) {
        return;
    }
    XHBabyChatMessage* chatMessage = (XHBabyChatMessage*)message;
    if ([self needDownloadAudioPlayDataWithMessage:chatMessage]) {
        [[EHAudioPlayDownLoader sharedManager] loadAudioPlayDataWithUrl:[NSURL URLWithString:chatMessage.voiceUrl] completeBlock:^(NSData *AudioData, EHAudioDataCacheType cacheType, BOOL finished, NSURL *url, NSError *error) {
            if (error) {
                EHLogError(@"-----> download url %@ audio data error",url);
            }else{
                EHLogInfo(@"-----> download url %@ audio data success",url);
            }
        }];
    }
}

-(BOOL)needDownloadAudioPlayDataWithMessage:(XHBabyChatMessage*)chatMessage{
    return chatMessage.messageMediaType == XHBubbleMessageMediaTypeVoice && chatMessage.voicePath == nil && chatMessage.voiceUrl;
}

-(void)startAnimating{
    [self.activityIndicatorView startAnimating];
}

- (void)stopAnimating{
    [self.activityIndicatorView stopAnimating];
}

-(void)faileSendButtonClicked:(id)sender{
    WEAKSELF
    EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:@"重发该消息？" clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
        STRONGSELF
        if (index == 1 && strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didSelectedReSendBtnOnChatMessage:atIndexPath:)]) {
            id <EHMessageTableViewCellDelegate> delegate = (id <EHMessageTableViewCellDelegate>)strongSelf.delegate;
            [delegate didSelectedReSendBtnOnChatMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [aleatView show];
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.messageBubbleView.bubbleImageView && [keyPath isEqualToString:@"frame"]) {
        [self updateMessageFrame];
    }else if (self.messageBubbleView.voiceDurationLabel && !self.messageBubbleView.voiceDurationLabel.hidden && [keyPath isEqualToString:@"frame"]){
        [self updateMessageFrame];
    }
}

@end
