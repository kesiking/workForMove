//
//  KSScrollViewConfigObject.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-25.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewConfigObject.h"

@implementation KSScrollViewConfigObject

-(void)setupStandConfig{
    self.needRefreshView = YES;
    self.needNextPage = YES;
    self.needFootView = YES;
    self.needQueueLoadData = YES;
    self.needErrorView = YES;
    self.scrollViewCacheType = KSScrollViewConfigCacheType_default;
}

@end
