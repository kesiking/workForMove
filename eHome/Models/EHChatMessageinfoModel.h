//
//  EHChatMessageinfoModel.h
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "XHBabyChatMessage.h"

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
@property(nonatomic,strong) NSString *head_imag_small;
@property(nonatomic,strong) NSString *user_nick_name;

// for app native
@property(nonatomic,assign) NSInteger  msgId;

@property(nonatomic,assign) NSUInteger msgTimestamp;

@property(nonatomic,strong) XHBabyChatMessage *babyChatMessage;

@property(nonatomic,strong) EHChatMessageBabyInfoModel       *babyInfoModel;

@property(nonatomic,strong) EHChatMessageUserPhoneInfoModel  *userInfoModel;

+ (EHChatMessageinfoModel *)makeMessage:(XHBabyChatMessage *)babyChatMessage;

- (XHBabyChatMessage*)getBabyChatMessageWithMessageModel:(EHChatMessageinfoModel*)message;

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
