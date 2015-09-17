//
//  EHRemoteBasicMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteBasicMessageHandle.h"
#import "EHRemoteMessageTimeOverdueObject.h"

#define MINUTE_VALID_RANGE_NUMBER (10)

@implementation EHRemoteBasicMessageHandle

- (void)remoteMessageHandle:(EHMessageInfoModel*)messageInfoModel{
    self.messageInfoModel = messageInfoModel;
    self.remoteMessageCategory = [messageInfoModel.category unsignedIntegerValue];
}

- (BOOL)remoteMessageDidfinished:(EHMessageInfoModel*)messageInfoModel{
    return YES;
}

- (BOOL)isRemoteMessageTimeOverdue:(EHMessageInfoModel*)messageInfoModel{
    return [EHRemoteMessageTimeOverdueObject isRemoteMessageTimeOverdue:messageInfoModel];
}

@end
