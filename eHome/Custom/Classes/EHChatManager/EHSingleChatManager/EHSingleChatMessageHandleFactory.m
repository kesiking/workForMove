//
//  EHSingleChatMessageHandleFactory.m
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatMessageHandleFactory.h"

@interface EHSingleChatMessageHandleFactory()

@property(nonatomic, strong) NSMutableDictionary * messageHandelClassDic;

@end

@implementation EHSingleChatMessageHandleFactory

+ (EHSingleChatMessageHandleFactory *)shareInstance {
    static EHSingleChatMessageHandleFactory * shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (EHSingleChatMessageBasicHandle*)getMessageHandleByType:(NSString * )type{
    return [[self shareInstance] getMessageHandleByType:type];
}

+ (BOOL)addMessageHandleClass:(Class)messageHandleClass withKey:(NSString*)key{
    return [[self shareInstance] addMessageHandleClass:messageHandleClass withKey:key];
}

+ (NSString*)getMessageTypeWithEHMessageFileType:(EHMessageFileType)messageFileType{
    return [NSString stringWithFormat:@"EHMessageFileType_%lu",messageFileType];
}

- (NSMutableDictionary *) messageHandelClassDic {
    if (!_messageHandelClassDic) {
        _messageHandelClassDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  NSClassFromString(@"EHSingleChatBabyRemoteMessageHandle"),[EHSingleChatMessageHandleFactory getMessageTypeWithEHMessageFileType:EHMessageFileType_text],
                                  NSClassFromString(@"EHSingleChatVoiceMessageHandle"),[EHSingleChatMessageHandleFactory getMessageTypeWithEHMessageFileType:EHMessageFileType_voice],nil];
    }
    return _messageHandelClassDic;
}

- (EHSingleChatMessageBasicHandle*)getMessageHandleByType:(NSString * )type{
    Class messageHandleClass = [self getMessageHandleClassByType:type];
    if (messageHandleClass == nil || ![messageHandleClass isSubclassOfClass:[EHSingleChatMessageBasicHandle class]]) {
        messageHandleClass = [EHSingleChatMessageBasicHandle class];
    }
    return [messageHandleClass new];
}

- (Class)getMessageHandleClassByType:(NSString * )type {
    Class messageHandleClass = nil;
    
    if (type && type.length > 0) {
        messageHandleClass = [self.messageHandelClassDic objectForKey:type];
    }
    
    return messageHandleClass;
}

- (BOOL)addMessageHandleClass:(Class)messageHandleClass withKey:(NSString*)key{
    if (messageHandleClass && self.messageHandelClassDic && key && key.length > 0) {
        [self.messageHandelClassDic setObject:messageHandleClass forKey:key];
        return YES;
    }
    return NO;
}

@end
