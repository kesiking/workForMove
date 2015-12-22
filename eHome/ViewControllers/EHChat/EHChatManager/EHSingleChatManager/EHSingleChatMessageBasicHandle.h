//
//  EHSingleChatMessageBasicHandle.h
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHSingleChatMessageModel.h"

typedef NS_ENUM(NSInteger, EHMessageChatType) {
    EHMessageChatType_single          = 0,  //为单聊,1为群聊,3为群发消息,
    EHMessageChatType_group           = 1,
};

typedef NS_ENUM(NSInteger, EHMessageFileType) {
    EHMessageFileType_text              = 0,  //0为普通文本,1为图片,2为声音,7为群组创建信息,8为单点登录消息(收到要下线),
    EHMessageFileType_picture           = 1,
    EHMessageFileType_voice             = 2,
};

@interface EHSingleChatMessageBasicHandle : NSObject

@property (nonatomic, strong) EHSingleChatMessageModel            *chatMessagemodel;

-(void)sendRemoteMessageWithMessage:(EHSingleChatMessageModel*)chatMessagemodel;

@end
