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

@interface EHSingleChatCacheManager()

@property (nonatomic,strong) EHChatMessageLIstService* chatMessageListService;

@property (nonatomic,strong) EHSingleChatCacheService* chatCacheService;

@end

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

- (void)loadChatMessageListWithBabyId:(NSNumber*)babyId
                         successBlock:(void(^)(NSArray* chatMessageList))successBlock
                         failedBlock:(void(^)(NSError* error))failedBlock{
    
}

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

- (void)recieveBabyChatMessage:(EHChatMessageinfoModel *)message{
    if (message == nil || message.babyChatMessage == nil) {
        return;
    }
    
    [self insertCacheWithBabyID:[NSString stringWithFormat:@"%@",message.babyChatMessage.recieverBabyID] componentItem:message writeSuccess:^(BOOL success) {
        if (success) {
            EHLogInfo(@"-----> EHSingleChatCacheManager recieveBabyChatMessage insert Cache success");
        }else{
            EHLogInfo(@"-----> EHSingleChatCacheManager recieveBabyChatMessage insert Cache failed: %@", message.babyChatMessage.recieverBabyID);
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
    
//    [chatMessageService loadChatMessageListWithBabyId:message.recieverBabyID userPhone:[KSAuthenticationCenter userPhone] context:context contextType:[NSString stringWithFormat:@"%@",@(context_type)]];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - insert cache Method

-(EHSingleChatCacheService *)chatCacheService{
    if (_chatCacheService == nil) {
        _chatCacheService = [EHSingleChatCacheService new];
    }
    return _chatCacheService;
}

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
    componentItem.babyChatMessage.db_tableName = [NSString stringWithFormat:@"XHBabyChatMessage_%@",[EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID]];
    [self.chatCacheService writeCacheWithApiName:KEHGetChatMessageListApiName withParam:@{@"baby_id":babyID} componentItem:componentItem writeSuccess:writeSuccessBlock];
}

-(void)deleteCacheWithBabyID:(NSString*)babyID
               componentItem:(EHChatMessageinfoModel*)componentItem
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (componentItem == nil) {
        return;
    }
    componentItem.babyChatMessage.db_tableName = [NSString stringWithFormat:@"XHBabyChatMessage_%@",[EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID]];
    NSDictionary* fechtCondtionDict = @{@"where":[NSString stringWithFormat:@"msgId = '%ld'",componentItem.msgId]};
    [self.chatCacheService deleteCacheWithApiName:KEHGetChatMessageListApiName withParam:@{@"baby_id":babyID} withFetchCondition:fechtCondtionDict componentItem:componentItem writeSuccess:writeSuccessBlock];
}

-(void)clearCacheWithBabyID:(NSString*)babyID
         componentItemClass:(Class)componentItemClass{
    [self.chatCacheService clearCacheWithApiName:KEHGetChatMessageListApiName withParam:@{@"baby_id":babyID} withFetchCondition:nil componentItemClass:componentItemClass];
}

@end
