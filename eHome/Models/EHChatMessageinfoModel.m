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

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    self.babyChatMessage = [self getBabyChatMessageWithMessageModel:self];
    self.msgId = self.babyChatMessage.msgId;
}

- (XHBabyChatMessage*)getBabyChatMessageWithMessageModel:(EHChatMessageinfoModel*)message{
    if (message == nil) {
        return nil;
    }
    XHBabyChatMessage *babyChatMessage = nil;
    NSDate* timestamp = [NSDate date];
    if (message.create_time) {
        timestamp = [dateFormatter dateFromString:message.create_time];
    }
    switch ([message.context_type integerValue]) {
        case XHBubbleMessageMediaTypeVideo:{
            babyChatMessage = [[XHBabyChatMessage alloc] initWithVoicePath:nil voiceUrl:message.context voiceDuration:[NSString stringWithFormat:@"%@",message.call_duration] sender:message.sender timestamp:timestamp isRead:YES];
        }
            break;
        case XHBubbleMessageMediaTypeText:{
            babyChatMessage = [[XHBabyChatMessage alloc] initWithText:message.context sender:message.sender timestamp:timestamp];
        }
            break;
        default:
            break;
    }
    babyChatMessage.recieverBabyID = message.baby_id;
    babyChatMessage.msgStatus = EHBabyChatMessageStatusReceived;
    
    return babyChatMessage;
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
    message.context_type = [NSString stringWithFormat:@"%@",@(babyChatMessage.messageMediaType)];
    switch (babyChatMessage.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:{
            message.call_duration = [NSNumber numberWithInteger:[babyChatMessage.voiceDuration integerValue]];
            message.context = babyChatMessage.voicePath;
        }
            break;
        case XHBubbleMessageMediaTypeText:{
            message.context = babyChatMessage.text;
        }
            break;
        default:
            break;
    }
    message.head_imag_small = [KSAuthenticationCenter userComponent].user_head_img;
    message.user_nick_name = [KSAuthenticationCenter userComponent].nick_name;
    message.babyChatMessage = babyChatMessage;
    
    return message;
}

@end
