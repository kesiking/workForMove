//
//  EHChatMessageinfoModel.h
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "XHBabyChatMessage.h"

#define SEND_MESSAGE_FROM_APP_USER     @"0"
#define SEND_MESSAGE_FROM_BABY_WATCH   @"1"
#define CONTEXT_TYPE_TEXT              @"0"
#define CONTEXT_TYPE_VOICE             @"1"
#define CONTEXT_TYPE_EMOTION           @"2"

@class EHChatMessageBabyInfoModel;
@class EHChatMessageUserPhoneInfoModel;

@interface EHChatMessageinfoModel : WeAppComponentBaseItem

@property(nonatomic,strong) NSString *uuid;
@property(nonatomic,strong) NSNumber *baby_id;
@property(nonatomic,strong) NSString *user_phone;
@property(nonatomic,strong) NSString *context;
@property(nonatomic,strong) NSString *create_time;
@property(nonatomic,strong) NSString *context_type;
@property(nonatomic,strong) NSString *sender;
@property(nonatomic,strong) NSNumber *call_duration;
@property(nonatomic,strong) NSNumber *is_read;
@property(nonatomic,strong) NSString *head_imag_small;
@property(nonatomic,strong) NSString *user_nick_name;

// for app native
@property(nonatomic,assign) NSInteger msgId;

@property(nonatomic,assign) NSUInteger msgTimestamp;

@property(nonatomic,strong) XHBabyChatMessage *babyChatMessage;

@property(nonatomic,strong) EHChatMessageBabyInfoModel       *babyInfoModel;

@property(nonatomic,strong) EHChatMessageUserPhoneInfoModel  *userInfoModel;

+ (EHChatMessageinfoModel *)makeMessage:(XHBabyChatMessage *)babyChatMessage;

- (XHBabyChatMessage*)getBabyChatMessageWithMessageModel:(EHChatMessageinfoModel*)message;

- (void)updateMessgeWithChatMessageinfoModel:(EHChatMessageinfoModel *)chatMessageinfoModel;

// 平台将head_imag_small与user_nick_name数据作为公共数据返回，因此需要提取出来后赋值
- (void)configHeadImagSmall:(NSString*)head_imag_small andUserNickName:(NSString*)user_nick_name;

@end

@interface EHChatMessageBabyInfoModel : WeAppComponentBaseItem

@property(nonatomic,strong) NSNumber *baby_id;
@property(nonatomic,strong) NSString *head_imag_small;
@property(nonatomic,strong) NSString *user_nick_name;

@end

@interface EHChatMessageUserPhoneInfoModel : WeAppComponentBaseItem

@property(nonatomic,strong) NSString *user_phone;
@property(nonatomic,strong) NSString *head_imag_small;
@property(nonatomic,strong) NSString *user_nick_name;

@end
