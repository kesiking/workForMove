//
//  EHMessageOperationQueue.h
//  eHome
//
//  Created by 孟希羲 on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHMessageOperationQueue : NSObject

+ (instancetype)sharedCenter;

- (void)addMessageModel:(id)messageMedol;

- (void)messageHandelFinished:(id)messageMedol;

@end
