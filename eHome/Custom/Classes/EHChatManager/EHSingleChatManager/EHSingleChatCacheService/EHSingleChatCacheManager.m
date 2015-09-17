//
//  EHSingleChatCacheManager.m
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatCacheManager.h"
#import "EHChatMessageLIstService.h"
#import "EHSingleChatCacheService.h"
#import "NSData+EHVoiceDataTransform.h"
#import "LKDBHelper.h"
#import "EHUtils.h"

@implementation EHSingleChatCacheManager

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+ (instancetype)sharedCenter {
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
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark send message to network Method

- (void)sendBabyChatMessage:(XHBabyChatMessage *)message
               writeSuccess:(CacheWriteSuccessCacheBlock)writeSuccessBlock
                sendSuccess:(ServiceWriteSuccessCacheBlock)sendSuccessBlock{
    
    if (message == nil) {
        return;
    }
    
    [self insertBabyChatMessage:message writeSuccess:^(BOOL success) {
        if (writeSuccessBlock) {
            writeSuccessBlock(success, message);
        }
    }];
    
    [self sendBabyChatMessageWithNetwork:message sendSuccess:sendSuccessBlock];
}

- (void)recieveBabyChatMessage:(XHBabyChatMessage *)message{
    if (message == nil) {
        return;
    }
    
    [self insertBabyChatMessage:message writeSuccess:^(BOOL success) {
        if (success) {
            EHLogInfo(@"-----> EHSingleChatCacheManager recieveBabyChatMessage insert Cache success");
        }else{
            EHLogInfo(@"-----> EHSingleChatCacheManager recieveBabyChatMessage insert Cache failed: %@", message.recieverBabyID);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EHRecieveBabyChatMessageNotification object:nil userInfo:@{EHBabyChatMessageModel_DATA:message}];

}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - send network service Method
-(void)sendBabyChatMessageWithNetwork:(XHBabyChatMessage *)message
                         sendSuccess:(ServiceWriteSuccessCacheBlock)sendSuccessBlock{
    NSString *context = nil;
    EHMessageContextType context_type = EHMessageContextType_Text;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText: {
            context_type = EHMessageContextType_Text;
            context = message.text;
            break;
        }
        case XHBubbleMessageMediaTypeVoice: {
            context_type = EHMessageContextType_Voice;
            if (message.voicePath) {
                context = [NSData stringFromVoicePath:message.voicePath];
            }
            break;
        }
        default:
            break;
    }
    
    EHChatMessageLIstService* chatMessageService = [EHChatMessageLIstService new];
    chatMessageService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        if (service.item && [service.item isKindOfClass:[EHChatMessageinfoModel class]]) {
            EHChatMessageinfoModel* chatMessage = (EHChatMessageinfoModel*)service.item;
            if (sendSuccessBlock) {
                sendSuccessBlock(YES, chatMessage.babyChatMessage);
            }
        }else if (sendSuccessBlock) {
            sendSuccessBlock(NO, nil);
        }
    };
    chatMessageService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
        if (sendSuccessBlock) {
            sendSuccessBlock(NO, nil);
        }
    };
    
    [chatMessageService loadChatMessageListWithBabyId:message.recieverBabyID userPhone:[KSAuthenticationCenter userPhone] context:context contextType:[NSString stringWithFormat:@"%@",@(context_type)]];

}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - insert cache Method
-(void)insertBabyChatMessage:(XHBabyChatMessage *)message
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    [self insertCacheWithBabyID:[NSString stringWithFormat:@"%@",message.recieverBabyID] componentItem:[EHChatMessageinfoModel makeMessage:message] writeSuccess:writeSuccessBlock];
}

-(void)insertCacheWithBabyID:(NSString*)babyID
               componentItem:(EHChatMessageinfoModel*)componentItem
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (componentItem == nil) {
        return;
    }
    componentItem.db_tableName = [EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] insertToDB:componentItem];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

-(void)deleteCacheWithBabyID:(NSString*)babyID
                componentItem:(EHChatMessageinfoModel*)componentItem
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (componentItem == nil) {
        return;
    }
    componentItem.db_tableName = [EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] deleteToDB:componentItem];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

-(void)clearCacheWithBabyID:(NSString*)babyID
          componentItemClass:(Class)componentItemClass{
    [[LKDBHelper getUsingLKDBHelper] deleteWithTableName:[EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID] where:nil];
}

@end
