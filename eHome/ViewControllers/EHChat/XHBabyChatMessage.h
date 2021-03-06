//
//  XHBabyChatMessage.h
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "XHMessage.h"

typedef enum {
    EHBabyChatMessageStatusSending = 0,   // 发送中
    EHBabyChatMessageStatusSent,          // 已发送
    EHBabyChatMessageStatusReceived,      // 已接收
    EHBabyChatMessageStatusRead,          // 已阅读
    EHBabyChatMessageStatusFailed,        // 发送失败
    //end
} EHBabyChatMessageStatus;

@interface XHBabyChatMessage : XHMessage

+ (NSUInteger)getMessageID;

- (void)configMessageID;

@property (nonatomic, strong) NSNumber               *recieverBabyID;

@property (nonatomic, strong) NSString               *user_nick_name;

@property (nonatomic, assign) EHBabyChatMessageStatus msgStatus;

@property (nonatomic, assign) NSInteger               msgId;

@property (nonatomic, assign) NSUInteger              msgTimestamp;

@property (nonatomic, assign) BOOL                    needShowTimestamp;

@property (nonatomic, assign) BOOL                    messageIsFromBaby;

@end
