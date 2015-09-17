//
//  MessageModel+EHMessageParse.m
//  eHome
//
//  Created by 孟希羲 on 15/7/13.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "MessageModel+EHMessageParse.h"
#import <objc/runtime.h>

static char MessageModelHistoryMessageKey;

@implementation MessageModel (EHMessageParse)

static inline void eh_message_model_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+(void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eh_message_model_swizzleSelector([self class], @selector(parsedByMessageStr:error:), @selector(EHMessageParsedByMessageStr:error:));
    });
}

+(MessageModel *)EHMessageParsedByMessageStr:(XMPPMessage *)message error:(NSError *)er{
    MessageModel* messageModel = [self EHMessageParsedByMessageStr:message error:er];
    if (message.stringValue) {
        NSError* error = nil;
        NSString* msgStr = message.stringValue;
        NSRange startRang = [msgStr rangeOfString:@"<msg>"];
        NSRange endRang = [msgStr rangeOfString:@"</msg>"];
        if (startRang.location != NSNotFound && endRang.location != NSNotFound && endRang.location > startRang.location) {
            NSRange msgRang = NSMakeRange(startRang.location, endRang.location + endRang.length);
            msgStr = [msgStr substringWithRange:msgRang];
        }
        NSXMLElement* messageXml = [[NSXMLElement alloc] initWithXMLString:msgStr error:&error];
        NSString* msg = [[messageXml elementForName:@"msg_content"] stringValue];
        if (msg) {
            messageModel.msg = msg;
        }
    }
    NSXMLElement* messageDelayXML = [message elementForName:@"delay"];
    if (messageDelayXML) {
        [messageModel setIsHistoryMessage:YES];
    }else{
        [messageModel setIsHistoryMessage:NO];
    }
    
    return messageModel;
}

#pragma 属性

-(void)setIsHistoryMessage:(BOOL)isHistoryMessage
{
    objc_setAssociatedObject(self, &MessageModelHistoryMessageKey,[NSNumber numberWithInteger:isHistoryMessage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isHistoryMessage
{
    return [objc_getAssociatedObject(self, &MessageModelHistoryMessageKey) boolValue];
}

@end
