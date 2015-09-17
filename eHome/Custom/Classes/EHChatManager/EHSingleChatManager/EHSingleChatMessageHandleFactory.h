//
//  EHSingleChatMessageHandleFactory.h
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHSingleChatMessageBasicHandle.h"
#import "EHSingleChatBabyRemoteMessageHandle.h"

@interface EHSingleChatMessageHandleFactory : NSObject

+ (EHSingleChatMessageBasicHandle*)getMessageHandleByType:(NSString * )type;

+ (BOOL)addMessageHandleClass:(Class)singleChatMessageHandleClass withKey:(NSString*)key;

+ (NSString*)getMessageTypeWithEHMessageFileType:(EHMessageFileType)messageFileType;

@end
