//
//  EHDeviceActionForMessage.h
//  eHome
//
//  Created by 孟希羲 on 15/7/20.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRemoteMessageModel.h"

@interface EHDeviceActionForMessage : NSObject

+(void)sendRemoteMessageNotificationForMessage:(EHRemoteMessageModel*)messageModel;

+(void)sendDeviceActionForMessage:(EHRemoteMessageModel*)messageModel;

+(void)sendDeviceAction;

@end
