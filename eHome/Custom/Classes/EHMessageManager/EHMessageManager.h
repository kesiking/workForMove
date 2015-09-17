//
//  EHMessageManager.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHMessageModel.h"

@interface EHMessageManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) id      sourceTarget;

-(void)sendMessage:(EHMessageModel*)messageModel;

@end
