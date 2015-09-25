//
//  EHChatMessageSendServiceQueue.m
//  eHome
//
//  Created by 孟希羲 on 15/9/21.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessageSendServiceQueue.h"

@interface EHChatMessageSendServiceQueue()

@property (nonatomic, strong) NSMutableArray *sendMessageServiceQueue;

@end

@implementation EHChatMessageSendServiceQueue

+ (EHChatMessageSendServiceQueue *) shareInstance
{
    static EHChatMessageSendServiceQueue * _shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    
    return _shareInstance;
}

- (id) init
{
    self = [super init];
    if(self){
        _sendMessageServiceQueue = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)addSendMessageService:(WeAppBasicService*)service{
    if (service == nil) {
        return;
    }
    [service addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context: (__bridge void *)service];
    [self.sendMessageServiceQueue addObject:service];
}

-(void)removeServiceObserveWithService:(WeAppBasicService*)service{
    if (service == nil) {
        return;
    }
    [service removeObserver:self forKeyPath:@"finished"];
    [self.sendMessageServiceQueue removeObject:service];
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context) {
        WeAppBasicService* service = (__bridge WeAppBasicService*)context;
        if ([keyPath isEqualToString:@"finished"]) {
            if (service.finished) {
                [self removeServiceObserveWithService:service];
            }
        }
    }
}

@end
