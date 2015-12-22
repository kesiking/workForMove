//
//  EHChatMessageSendServiceQueue.h
//  eHome
//
//  Created by 孟希羲 on 15/9/21.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHChatMessageSendServiceQueue : NSObject

+ (EHChatMessageSendServiceQueue *) shareInstance;

- (void)addSendMessageService:(WeAppBasicService*)service;

@end
