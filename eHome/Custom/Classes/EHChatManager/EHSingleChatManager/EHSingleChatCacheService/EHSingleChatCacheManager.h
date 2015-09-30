//
//  EHSingleChatCacheManager.h
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHChatMessageinfoModel.h"
#import "XHBabyChatMessage.h"

typedef void(^CacheWriteSuccessCacheBlock)(BOOL success, XHBabyChatMessage* chatMessage);
typedef void(^ServiceWriteSuccessCacheBlock)(BOOL success, XHBabyChatMessage* chatMessage);

@interface EHSingleChatCacheManager : NSObject

+ (instancetype)sharedCenter;

- (void)sendBabyChatMessage:(XHBabyChatMessage *)message
               writeSuccess:(CacheWriteSuccessCacheBlock)writeSuccessBlock
                sendSuccess:(ServiceWriteSuccessCacheBlock)sendSuccessBlock;

- (void)recieveBabyChatMessage:(EHChatMessageinfoModel *)message;

- (void)updateBabyChatMessage:(XHBabyChatMessage *)message
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock;


@end
