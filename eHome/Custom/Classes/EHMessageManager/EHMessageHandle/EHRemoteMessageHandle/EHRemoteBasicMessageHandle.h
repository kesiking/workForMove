//
//  EHRemoteBasicMessageHandle.h
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHMessageInfoModel.h"
#import "EHMessageModel.h"

@interface EHRemoteBasicMessageHandle : NSObject

@property (nonatomic, assign)  NSUInteger               remoteMessageCategory;

@property (nonatomic, strong)  EHMessageInfoModel*      messageInfoModel;

@property (nonatomic, strong)  EHMessageModel*          messageModel;

// 消息展现的目标source
@property (nonatomic, strong) UIView*                   sourceView;

- (void)remoteMessageHandle:(EHMessageInfoModel*)messageInfoModel;

- (BOOL)remoteMessageDidfinished:(EHMessageInfoModel*)messageInfoModel;

- (BOOL)isRemoteMessageTimeOverdue:(EHMessageInfoModel*)messageInfoModel;

- (BOOL)isRemoteMessageLogical:(EHMessageInfoModel*)messageInfoModel;

@end
