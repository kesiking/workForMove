//
//  EHMapHistoryTracedataSource.m
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTracedataSource.h"

@implementation EHMapHistoryTracedataSource

-(void)setDataWithPageList:(NSArray *)pageList extraDataSource:(NSDictionary*)extraInfoParams{
    NSArray* reversedArray = pageList;
    if (pageList != nil) {
        reversedArray = [[pageList reverseObjectEnumerator] allObjects];
    }
    [super setDataWithPageList:reversedArray extraDataSource:extraInfoParams];
}

@end
