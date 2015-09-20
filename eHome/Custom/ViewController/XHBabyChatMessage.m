//
//  XHBabyChatMessage.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "XHBabyChatMessage.h"

#define EHChatMessageinfo_ID_Key                  @"EHChatMessageinfo_ID_Key"

@implementation XHBabyChatMessage

+(BOOL)isContainParent
{
    return YES;
}

+(NSString*)getPrimaryKey{
    return @"msgId";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp {
    self = [super initWithText:text sender:sender timestamp:timestamp];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp {
    self = [super initWithPhoto:photo thumbnailUrl:thumbnailUrl originPhotoUrl:originPhotoUrl sender:sender timestamp:timestamp];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp {
    self = [super initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:videoUrl sender:sender timestamp:timestamp];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp {
    
    return [self initWithVoicePath:voicePath voiceUrl:voiceUrl voiceDuration:voiceDuration sender:sender timestamp:timestamp isRead:YES];
}

/**
 *  初始化语音类型的消息。增加已读未读标记
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *  @param isRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                           isRead:(BOOL)isRead {
    self = [super initWithVoicePath:voicePath voiceUrl:voiceUrl voiceDuration:voiceDuration sender:sender timestamp:timestamp isRead:isRead];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                             sender:(NSString *)sender
                          timestamp:(NSDate *)timestamp {
    self = [super initWithEmotionPath:emotionPath sender:sender timestamp:timestamp];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp {
    self = [super initWithLocalPositionPhoto:localPositionPhoto geolocations:geolocations location:location sender:sender timestamp:timestamp];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.msgTimestamp = [self.timestamp timeIntervalSince1970];
}

- (void)configMessageID{
    self.msgId = [XHBabyChatMessage getMessageID];
}

+ (NSUInteger)getMessageID
{
    NSInteger messageID = [[NSUserDefaults standardUserDefaults] integerForKey:EHChatMessageinfo_ID_Key];
    if (messageID == 0) {
        messageID = 1;
    }
    NSInteger resultMessageID = messageID;
    messageID ++;
    [[NSUserDefaults standardUserDefaults] setInteger:messageID forKey:EHChatMessageinfo_ID_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return resultMessageID;
}

@end
