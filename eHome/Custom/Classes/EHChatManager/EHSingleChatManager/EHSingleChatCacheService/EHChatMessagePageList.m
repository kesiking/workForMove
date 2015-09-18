//
//  EHChatMessagePageList.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessagePageList.h"
#import "EHChatMessagePaginationItem.h"

@implementation EHChatMessagePageList

-(void)refresh{
    if ([_pagination isKindOfClass:[EHChatMessagePaginationItem class]]) {
        EHChatMessagePaginationItem* pagination = (EHChatMessagePaginationItem*)_pagination;
        pagination.isTimestampEnable = NO;
        pagination.curPage = 0;
        pagination.reallyCurpage = 0;
        
        pagination.beforTimestampStr = nil;
        if (pagination.useTimesatmpAsReference) {
            pagination.afterTimestampStr = [self timestampStrAtIndex:self.count - 1];
        }else {
            pagination.afterTimestampStr = nil;
        }
        
        pagination.direction = EHChatMessagePaginationDirectionBetweenTimestampAndNow;
        self.isRefresh = YES;
    }else{
        [super refresh];
    }
}

-(void)nextPage{
    if ([_pagination isKindOfClass:[EHChatMessagePaginationItem class]]) {
        EHChatMessagePaginationItem* pagination = (EHChatMessagePaginationItem*)_pagination;
        pagination.isTimestampEnable = YES;
        pagination.curPage ++;
        
        pagination.beforTimestampStr = [self timestampStrAtIndex:0];
        pagination.afterTimestampStr = nil;
        
        pagination.direction = EHChatMessageaginationDirectionNextPage;
        self.isRefresh = NO;
    }else{
        [super nextPage];
    }
    
}

-(NSString*)timestampStrAtIndex:(NSInteger)index{
    if (self.count <= 0) {
        return nil;
    }
    
    if ([self objectAtIndex:index]) {
        id obj = [self objectAtIndex:index];
        
        if ([obj respondsToSelector:@selector(create_time)]) {
            return [obj valueForKey:@"create_time"];
        }
    }
    
    return nil;
}

@end
