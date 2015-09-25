//
//  EHChatMessageTimestampCaculater.h
//  eHome
//
//  Created by 孟希羲 on 15/9/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHChatMessageinfoModel.h"

@interface EHChatMessageTimestampCaculater : NSObject

-(void)configChatMessageTimestampAfterChatlist:(NSArray*)chatlist;

-(void)configChatMessageTimestampBeforChatlist:(NSArray*)chatlist;

-(void)configChatMessageEarliestTimestampWithMessage:(XHBabyChatMessage*)chatMessage;

-(void)configChatMessageLastiestTimestampWithMessage:(XHBabyChatMessage*)chatMessage;

@end
