//
//  KSTouchEvent.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/20.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSTouchEvent : NSObject

+(void)configTouch;

+(void)touchWithView:(UIView*)view;

+(void)touchWithView:(UIView*)view eventAttributes:(NSDictionary*)eventAttributes;

+(void)setNeedTouchEventLog:(BOOL)needTouchEventLog;

@end
