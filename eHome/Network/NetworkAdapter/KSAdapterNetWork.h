//
//  KSAdapterNetWork.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "BasicNetWorkAdapter.h"

@interface KSAdapterNetWork : BasicNetWorkAdapter
+ (instancetype)sharedAdapterNetWork;
@property(nonatomic, assign) BOOL                needLogin;
@property (nonatomic, assign)BOOL isStartNetWorkMonitor;

@end
