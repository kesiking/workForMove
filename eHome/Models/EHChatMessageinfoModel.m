//
//  EHChatMessageinfoModel.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessageinfoModel.h"

@implementation EHChatMessageinfoModel

static NSDateFormatter *dateFormatter = nil;

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"createTime":@"create_time",@"userPhone":@"user_phone"};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

+(void)initialize{
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
}

+(NSString*)getPrimaryKey{
    return @"msgId";
}

+(BOOL)isContainParent
{
    return YES;
}

+(void)dbDidSeleted:(NSObject *)entity{
    if (![entity isKindOfClass:[self class]]) {
        return;
    }
    EHChatMessageinfoModel* chatMessageInfoModel = (EHChatMessageinfoModel*)entity;
    chatMessageInfoModel.head_imag_small = chatMessageInfoModel.userInfoModel.head_imag_small?:(chatMessageInfoModel.babyInfoModel.head_imag_small?:chatMessageInfoModel.head_imag_small);
    chatMessageInfoModel.user_nick_name = chatMessageInfoModel.userInfoModel.user_nick_name?:(chatMessageInfoModel.babyInfoModel.user_nick_name?:chatMessageInfoModel.user_nick_name);
    
    chatMessageInfoModel.babyChatMessage.avatarUrl = chatMessageInfoModel.head_imag_small?:chatMessageInfoModel.babyChatMessage.avatarUrl;
    //自己发送的消息，不取数据库缓存的头像url，从[KSAuthenticationCenter userComponent].user_head_img取回url
    if (!chatMessageInfoModel.babyChatMessage.messageIsFromBaby && chatMessageInfoModel.user_phone && [chatMessageInfoModel.user_phone isEqualToString:[KSAuthenticationCenter userPhone]]) {
        chatMessageInfoModel.babyChatMessage.avatarUrl = [KSAuthenticationCenter userComponent].user_head_img;
    }

}

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    if (dict != nil) {
        self.babyChatMessage = [self getBabyChatMessageWithMessageModel:self];
        self.msgId = self.babyChatMessage.msgId;
        self.msgTimestamp = self.babyChatMessage.msgTimestamp;
        self.babyInfoModel = [EHChatMessageBabyInfoModel modelWithJSON:dict];
        self.userInfoModel = [EHChatMessageUserPhoneInfoModel modelWithJSON:dict];
    }
}

- (void)configHeadImagSmall:(NSString*)head_imag_small andUserNickName:(NSString*)user_nick_name{
    self.user_nick_name = user_nick_name;
    self.head_imag_small = head_imag_small;
    self.babyInfoModel.head_imag_small = head_imag_small;
    self.babyInfoModel.user_nick_name = user_nick_name;
    self.userInfoModel.head_imag_small = head_imag_small;
    self.userInfoModel.user_nick_name = user_nick_name;
    self.babyChatMessage.avatarUrl = head_imag_small;
    self.babyChatMessage.originPhotoUrl = head_imag_small;
    self.babyChatMessage.user_nick_name = user_nick_name;
}

- (XHBabyChatMessage*)getBabyChatMessageWithMessageModel:(EHChatMessageinfoModel*)message{
    if (message == nil) {
        return nil;
    }
    XHBabyChatMessage *babyChatMessage = nil;
    NSDate* timestamp = [NSDate date];
    if (message.create_time) {
        timestamp = [dateFormatter dateFromString:message.create_time]?:timestamp;
    }else{
        message.create_time = [dateFormatter stringFromDate:timestamp];
    }
    if ([message.context_type isEqualToString:CONTEXT_TYPE_TEXT]) {
        if (message.context == nil) {
            message.context = @"";
        }
        message.context = [message.context stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        babyChatMessage = [[XHBabyChatMessage alloc] initWithText:message.context sender:message.user_phone timestamp:timestamp];
    }else if([message.context_type isEqualToString:CONTEXT_TYPE_EMOTION]){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EHChatEmotionEncode" ofType:@"plist"];
        NSDictionary *emotionsDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        NSArray *emotionEncodings = [emotionsDic allKeys];
        if (message.context == nil||![emotionEncodings containsObject:message.context]) {
            //服务器返回数据有错，保护处理
            message.context = emotionEncodings[0];
        }
        babyChatMessage = [[XHBabyChatMessage alloc] initWithPhoto:nil thumbnailUrl:nil originPhotoUrl:nil sender:message.user_phone timestamp:timestamp];
        babyChatMessage.text = message.context;
    }else if ([message.context_type isEqualToString:CONTEXT_TYPE_VOICE]) {
        babyChatMessage = [[XHBabyChatMessage alloc] initWithVoicePath:nil voiceUrl:message.context voiceDuration:[NSString stringWithFormat:@"%@",message.call_duration] sender:message.user_phone timestamp:timestamp isRead:NO];
    }else{
        babyChatMessage = [[XHBabyChatMessage alloc] initWithText:message.context?:@"" sender:message.user_phone timestamp:timestamp];
    }
    babyChatMessage.avatarUrl = message.head_imag_small;
    babyChatMessage.originPhotoUrl = message.head_imag_small;
    babyChatMessage.recieverBabyID = message.baby_id;
    babyChatMessage.user_nick_name = message.user_nick_name;
    babyChatMessage.messageIsFromBaby = [message.sender boolValue];
    if (!babyChatMessage.messageIsFromBaby && message.user_phone && [message.user_phone isEqualToString:[KSAuthenticationCenter userPhone]]) {
        babyChatMessage.bubbleMessageType = XHBubbleMessageTypeSending;
        babyChatMessage.isRead = YES;
        babyChatMessage.shouldShowUserName =  NO;
    }else{
        babyChatMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
        babyChatMessage.shouldShowUserName = YES;
    }
    babyChatMessage.msgStatus = EHBabyChatMessageStatusReceived;
    [babyChatMessage configMessageID];
    
    return babyChatMessage;
}

-(void)updateMessgeWithChatMessageinfoModel:(EHChatMessageinfoModel *)chatMessageinfoModel{
    if (chatMessageinfoModel == nil) {
        return;
    }
    self.user_nick_name = chatMessageinfoModel.user_nick_name?:self.user_nick_name;
    self.head_imag_small = chatMessageinfoModel.head_imag_small?:self.head_imag_small;
    self.create_time = chatMessageinfoModel.create_time?:self.create_time;
    self.uuid = chatMessageinfoModel.uuid?:self.uuid;
    if (self.babyChatMessage.messageMediaType == XHBubbleMessageMediaTypeVoice) {
        self.babyChatMessage.voiceUrl = chatMessageinfoModel.context?:chatMessageinfoModel.babyChatMessage.voiceUrl;
    }
}

+ (EHChatMessageinfoModel *)makeMessage:(XHBabyChatMessage *)babyChatMessage
{
    EHChatMessageinfoModel* message = [[EHChatMessageinfoModel alloc] init];
    message.msgId = babyChatMessage.msgId;
    message.baby_id = babyChatMessage.recieverBabyID;
    message.user_phone = [KSAuthenticationCenter userPhone];
    message.sender = babyChatMessage.sender;
    if (babyChatMessage.timestamp) {
        message.create_time = [dateFormatter stringFromDate:babyChatMessage.timestamp];
    }
    switch (babyChatMessage.messageMediaType) {
        case XHBubbleMessageMediaTypeVoice:{
            message.call_duration = [NSNumber numberWithInteger:[babyChatMessage.voiceDuration integerValue]];
            message.context = babyChatMessage.voicePath;
            message.context_type = CONTEXT_TYPE_VOICE;
        }
            break;
        case XHBubbleMessageMediaTypeText:{
            message.context = babyChatMessage.text;
            message.context_type = CONTEXT_TYPE_TEXT;
        }
            break;
        //表情 使用了photo控件
        case XHBubbleMessageMediaTypePhoto:{
            message.context = babyChatMessage.text;
            message.context_type = CONTEXT_TYPE_EMOTION;
        }
            break;
        default:{
            message.context = babyChatMessage.text;
            message.context_type = CONTEXT_TYPE_TEXT;
        }
            break;
    }
    message.head_imag_small = babyChatMessage.avatarUrl?:[KSAuthenticationCenter userComponent].user_head_img;
    message.user_nick_name = babyChatMessage.user_nick_name?:[KSAuthenticationCenter userComponent].nick_name;
    message.msgTimestamp = babyChatMessage.msgTimestamp;

    message.babyInfoModel = [EHChatMessageBabyInfoModel new];
    message.babyInfoModel.baby_id = message.baby_id;
    message.babyInfoModel.user_nick_name = message.user_nick_name;
    message.babyInfoModel.head_imag_small = message.head_imag_small;
    
    message.userInfoModel = [EHChatMessageUserPhoneInfoModel new];
    message.userInfoModel.user_phone = message.user_phone;
    message.userInfoModel.user_nick_name = message.user_nick_name;
    message.userInfoModel.head_imag_small = message.head_imag_small;
    
    message.babyChatMessage = babyChatMessage;
    
    return message;
}

@end

@implementation EHChatMessageBabyInfoModel

+(NSString*)getPrimaryKey{
    return @"baby_id";
}

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"userPhone":@"user_phone"};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

@end

@implementation EHChatMessageUserPhoneInfoModel

+(NSString*)getPrimaryKey{
    return @"user_phone";
}

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"userPhone":@"user_phone"};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

@end
