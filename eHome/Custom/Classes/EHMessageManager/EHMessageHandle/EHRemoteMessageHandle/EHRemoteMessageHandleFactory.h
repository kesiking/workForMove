//
//  EHRemoteMessageHandleFactory.h
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRemoteBasicMessageHandle.h"

@interface EHRemoteMessageHandleFactory : NSObject

+ (EHRemoteBasicMessageHandle*)getMessageHandleByCategory:(NSUInteger)category;

@end
