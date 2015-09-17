//
//  EHChatMessagePageList.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessagePageList.h"

@implementation EHChatMessagePageList

-(void)refresh{
    _pagination.isTimestampEnable = NO;
    _pagination.curPage = 0;
    _pagination.reallyCurpage = 0;
    
    _pagination.beforTimestamp = 0;
    if (_pagination.useTimesatmpAsReference) {
        _pagination.afterTimestamp = [self timestampAtIndex:self.count - 1];
    }else {
        _pagination.afterTimestamp = 0;
    }
    
    _pagination.direction = WeAppPaginationDirectionBetweenTimestampAndNow;
    self.isRefresh = YES;

}

-(void)nextPage{
    _pagination.isTimestampEnable = YES;
    _pagination.curPage ++;
    
    _pagination.beforTimestamp = [self timestampAtIndex:0];
    _pagination.afterTimestamp = 0;

    _pagination.direction = WeAppPaginationDirectionNextPage;

    self.isRefresh = NO;
}

@end
