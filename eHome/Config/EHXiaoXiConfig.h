//
//  EHXiaoXiConfig.h
//  eHome
//
//  Created by 孟希羲 on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHXiaoXiConfig : NSObject

@property (nonatomic, assign)  BOOL    isXiaoXiOnline;

+ (instancetype)sharedCenter;

+ (void)configXiaoXi;

+ (void)setDeviceToken:(NSData*)deviceToken;

+ (void)goOffLine;

+ (void)setUnReadMessageCount:(NSInteger)count;

- (void)sendRemoteMessageWithMessage:(NSString*)message;

/**
 *  单聊发送声音消息
 *  @param model
 *  @param userName
 */

-(void)sendVoice:(NSString *)path voiceLength:(NSInteger)length
              to:(NSString *)userName
    messageSuccessBlock:(void(^)(void))messageSuccessBlock
    messageFailBlock:(void(^)(NSError* error))messageFailBlock;

@end
