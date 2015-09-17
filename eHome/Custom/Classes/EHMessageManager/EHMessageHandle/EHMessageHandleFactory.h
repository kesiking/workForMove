//
//  EHMessageHandleFactory.h
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHMessageBasicHandle.h"

@interface EHMessageHandleFactory : NSObject

+ (EHMessageBasicHandle*)getMessageHandleByType:(NSString * )type;

+ (BOOL)addMessageHandleClass:(Class)messageHandleClass withKey:(NSString*)key;



@end
