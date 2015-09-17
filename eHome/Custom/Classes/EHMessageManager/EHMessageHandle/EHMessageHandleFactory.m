//
//  EHMessageHandleFactory.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageHandleFactory.h"
#import "EHMessageMaroc.h"

@interface EHMessageHandleFactory()

@property(nonatomic, strong) NSMutableDictionary * messageHandelClassDic;

@end

@implementation EHMessageHandleFactory

+ (EHMessageHandleFactory *)shareInstance {
    static EHMessageHandleFactory * shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (EHMessageBasicHandle*)getMessageHandleByType:(NSString * )type{
    return [[self shareInstance] getMessageHandleByType:type];
}

+ (BOOL)addMessageHandleClass:(Class)messageHandleClass withKey:(NSString*)key{
    return [[self shareInstance] addMessageHandleClass:messageHandleClass withKey:key];
}

- (NSMutableDictionary *) messageHandelClassDic {
    if (!_messageHandelClassDic) {
        _messageHandelClassDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  NSClassFromString(@"EHDeviceBindingMessageHandle"),kEHDeviceBindingMessageType,
                                  NSClassFromString(@"EHDeviceStatusMessageHandle"),kEHDeviceStatusMessageType,
                                  NSClassFromString(@"EHRemoteMessageHandle"),kEHRemoteMessageType,
                                  NSClassFromString(@"EHNoneMessageHandle"),kEHNoneMessageType,
                                  NSClassFromString(@"EHAttentionViewChangeMessageHandle"),kEHAttentionViewMessageType,
                                  NSClassFromString(@"EHNetworkMessageHandle"),kEHNetworkMessageType,nil];
    }
    return _messageHandelClassDic;
}

- (EHMessageBasicHandle*)getMessageHandleByType:(NSString * )type{
    Class messageHandleClass = [self getMessageHandleClassByType:type];
    if (messageHandleClass == nil || ![messageHandleClass isSubclassOfClass:[EHMessageBasicHandle class]]) {
        messageHandleClass = [EHMessageBasicHandle class];
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
