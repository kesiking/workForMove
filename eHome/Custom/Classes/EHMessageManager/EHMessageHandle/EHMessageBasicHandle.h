//
//  EHMessageBasicHandle.h
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHMessageModel.h"

@interface EHMessageBasicHandle : NSObject

@property (nonatomic,strong)   EHMessageModel           *messageModel;

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel;

-(void)handleMessage:(EHMessageModel*)messageModel;

-(BOOL)messageDidfinished:(EHMessageModel*)messageModel;

@end
