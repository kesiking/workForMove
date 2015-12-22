//
//  UncaughtExceptionHandler.h
//  UncaughtExceptionHandlerFrameWork
//
//  Created by 慧博创测-刘晓威 on 15/3/31.
//  Copyright (c) 2015年 刘晓威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "exceptionSolve.h"

@interface UncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}



+(void) InstallUncaughtExceptionHandler;
+(NSArray *)backtrace;
- (void)handleException:(NSException *)exception;
void UncaughtExceptionHandlers (NSException *exception);

@end
