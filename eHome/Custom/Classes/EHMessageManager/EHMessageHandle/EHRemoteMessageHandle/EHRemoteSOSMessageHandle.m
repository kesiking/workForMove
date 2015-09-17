//
//  EHRemoteSOSMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteSOSMessageHandle.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EHSOSAlertView.h"
#import "EHMessageOperationQueue.h"

@interface EHRemoteSOSMessageHandle()

@property (nonatomic,strong)   NSTimer          *timer;
@property (nonatomic,strong)   EHSOSAlertView   *aleatView;

@end

static BOOL isSOSMessageOn = NO;
static SystemSoundID EHWorningSoundID = 1005;

#define worningSoundSecond (60.0*2)

@implementation EHRemoteSOSMessageHandle

+(void)initialize{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)initTimer{
    [self releaseTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:worningSoundSecond target:self selector:@selector(stopWorning) userInfo:nil repeats:NO];
}

- (void)releaseTimer{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)initAlertViewWithMessageInfo:(NSString*)messageInfo messageInfoModel:(EHMessageInfoModel *)messageInfoModel{
    if (_aleatView == nil) {
        WEAKSELF
        _aleatView = [[EHSOSAlertView alloc] initWithTitle:nil message:messageInfo clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
            STRONGSELF
            if (index == 0) {
                [strongSelf stopWorning];
                NSMutableDictionary* params = [NSMutableDictionary dictionary];
                if (messageInfoModel.babyId) {
                    [params setObject:messageInfoModel.babyId forKey:kEHOMETabHomeGetBabyId];
                    if (messageInfoModel.message_time) {
                        [params setObject:messageInfoModel.message_time forKey:kEHOMETabHomeGetBabyTimer];
                    }
                    [params setObject:@YES forKey:kEHOMETabHomeSwitchToBaby];
                }
                TBOpenURLFromSourceAndParams(tabbarURL(kEHOMETabHome), strongSelf.sourceView, params);
            }
        } cancelButtonTitle:nil otherButtonTitles:@"马上查看", nil];
        EHGetBabyListRsp *babyListRsp = [[EHBabyListDataCenter sharedCenter] getBabyListRspWithBabyId:messageInfoModel.babyId];
        NSString* messageTriggerName = babyListRsp.babyNickName;
        if (!messageTriggerName) {
            messageTriggerName = messageInfoModel.trigger_name?[NSString stringWithFormat:@"%@",messageInfoModel.trigger_name]:messageInfoModel.recipient;
        }
        NSString* messageTitle = [NSString stringWithFormat:@"%@发出sos求救信号！",messageTriggerName];
        
        [_aleatView.sosCustomView setTitleText:messageTitle messageText:messageInfo];
    }
    [_aleatView show];
}

- (void)hideAlertView{
    [_aleatView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dealloc{
    [self releaseTimer];
}

-(void)remoteMessageHandle:(EHMessageInfoModel *)messageInfoModel{
    [super remoteMessageHandle:messageInfoModel];
    if (self.remoteMessageCategory == EHMessageInfoCatergoryType_SOS && !isSOSMessageOn) {
        isSOSMessageOn = YES;
        // to do 声音 震动
        NSString* subMessageInfo = messageInfoModel.info;
        NSString* addressString = @"地点";
        if (addressString) {
            NSRange range = [messageInfoModel.info rangeOfString:addressString];
            if (range.location != NSNotFound) {
                subMessageInfo = [messageInfoModel.info substringFromIndex:range.location];
            }
        }
        EHGetBabyListRsp *babyListRsp = [[EHBabyListDataCenter sharedCenter] getBabyListRspWithBabyId:messageInfoModel.babyId];
        NSString* messageTriggerName = babyListRsp.babyNickName;
        if (!messageTriggerName) {
            messageTriggerName = messageInfoModel.trigger_name?[NSString stringWithFormat:@"%@",messageInfoModel.trigger_name]:messageInfoModel.recipient;
        }
        NSString* messageInfo = subMessageInfo?:[NSString stringWithFormat:@"%@发出sos求救信号！",messageTriggerName];
        if (![KSAuthenticationCenter isTestAccount]) {
#ifdef EH_USE_NAVIGATION_NOTIFICATION
            [MPNotificationView notifyWithText:messageTriggerName
                                        detail:messageInfo
                                         image:nil
                                      duration:worningSoundSecond
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     EHLogInfo(@"-----> Received touch for notification with text: %@ %@", notificationView.textLabel.text,notificationView.detailTextLabel.text);
                                 }];
#else
            NSMutableDictionary* userInfo = [NSMutableDictionary new];
            if (messageInfoModel.babyId) {
                [userInfo setObject:messageInfoModel.babyId forKey:EHMESSAGE_BABY_ID_DATA];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:EHBabySOSMessageNotification object:nil userInfo:userInfo];
            [self initAlertViewWithMessageInfo:messageInfo messageInfoModel:messageInfoModel];
#endif
        }
        [self initTimer];
        [self startWorning];
    }
}

- (BOOL)remoteMessageDidfinished:(EHMessageInfoModel*)messageInfoModel{
    return !isSOSMessageOn;
}

- (void)startWorning{
    [self playVibrate];
    [self playWorningSound];
    [self performSelector:@selector(startWorning) withObject:nil afterDelay:2.0];
}

- (void)stopWorning{
    isSOSMessageOn = NO;
    [self stopVibrate];
    [self stopWorningSound];
    [self releaseTimer];
    [self hideAlertView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startWorning) object:nil];
    [[EHMessageOperationQueue sharedCenter] messageHandelFinished:self.messageModel];
}

- (void)playVibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)stopVibrate{
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

- (void)playWorningSound{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"sosalerm" ofType:@"mp3"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &EHWorningSoundID);
    }
    AudioServicesPlaySystemSound(EHWorningSoundID);
}

-(void)stopWorningSound{
    AudioServicesDisposeSystemSoundID(EHWorningSoundID);
}

@end
