//
//  EHSingleChatCacheManager.m
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatCacheManager.h"
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
    
    [self insertBabyChatMessage:message writeSuccess:^(BOOL success) {
        if (writeSuccessBlock) {
            writeSuccessBlock(success, message);
        }
    }];
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

/*!
 *  @author 孟希羲, 15-09-17 14:09:48
 *
 *  @brief  sendBabyChatMessage 发送message 并存入缓存
 *
 *  @return void
 *
 *  @since 1.0.9
 */
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
