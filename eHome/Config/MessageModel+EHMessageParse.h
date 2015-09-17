//
//  MessageModel+EHMessageParse.h
//  eHome
//
//  Created by 孟希羲 on 15/7/13.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <EIM_XMPP/XMPPManager.h>
#import <EIM_XMPP/MessageModel.h>

@interface MessageModel (EHMessageParse)

-(void)setIsHistoryMessage:(BOOL)isHistoryMessage;

-(BOOL)isHistoryMessage;


-(void)setMsgid:(NSString*)msgid;

-(NSString*)msgid;

@end
