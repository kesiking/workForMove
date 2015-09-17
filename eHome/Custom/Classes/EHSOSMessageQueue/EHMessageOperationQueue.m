//
//  EHMessageOperationQueue.m
//  eHome
//
//  Created by 孟希羲 on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageOperationQueue.h"
#import "EHMessageManager.h"

@interface EHMessageOperationQueue()

@property (nonatomic, strong)  NSMutableArray* messageQueue;

@end

@implementation EHMessageOperationQueue

+ (instancetype)sharedCenter{
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    _messageQueue = [NSMutableArray array];
}

- (void)addMessageModel:(id)messageMedol{
    if (messageMedol == nil) {
        return;
    }
    if ([self.messageQueue containsObject:messageMedol]) {
        return;
    }
    [self.messageQueue addObject:messageMedol];
    EHLogInfo(@"-----> message add success in message queue with messageModel: %@",messageMedol);
}

- (void)messageHandelFinished:(id)messageMedol{
    if (messageMedol == nil) {
        return;
    }
    if ([self.messageQueue containsObject:messageMedol]) {
        [self.messageQueue removeObject:messageMedol];
    }
    if ([self.messageQueue count] == 0) {
        return;
    }
    id nextMessageMedol = [self.messageQueue firstObject];
    if ([nextMessageMedol isKindOfClass:[EHMessageModel class]]) {
        [[EHMessageManager sharedManager] sendMessage:((EHMessageModel*)nextMessageMedol)];
    }
    EHLogInfo(@"-----> message send success in message queue  with messageModel: %@",messageMedol);
}

@end
