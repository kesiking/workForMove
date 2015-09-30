//
//  EHChatMessagePageList.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessagePageList.h"
#import "EHChatMessagePaginationItem.h"
#import "EHChatMessageinfoModel.h"

@implementation EHChatMessagePageList

-(void)refresh{
    self.isForceRecordAllObject = YES;
    if ([_pagination isKindOfClass:[EHChatMessagePaginationItem class]]) {
        EHChatMessagePaginationItem* pagination = (EHChatMessagePaginationItem*)_pagination;
        pagination.isTimestampEnable = NO;
        pagination.curPage = 0;
        pagination.reallyCurpage = 0;
        
        pagination.beforTimestampStr = nil;
        if (pagination.useTimesatmpAsReference) {
            pagination.afterTimestampStr = [self timestampStrAtIndex:self.count - 1];
        }
        if (pagination.afterTimestampStr == nil) {
            pagination.afterTimestampStr = @"";
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
        if (pagination.beforTimestampStr == nil) {
            pagination.beforTimestampStr = @"";
        }
        
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

//解析调用
-(void)parsePageListWithJsonValue:(NSDictionary*)jsonValue{
    if (jsonValue == nil || ![jsonValue isKindOfClass:[NSDictionary class]]) {
        self.newDataCount = 0;
        return;
    }
    
    if ([jsonValue count] <= 0) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    NSDictionary *myDataJosnValue = jsonValue;
    
    if(self.pagination == nil) {
        self.pagination = [[WeAppPaginationItem alloc]init];
    }
    
    if ([myDataJosnValue objectForKey:@"pageSize"]) {
        self.pagination.pageSize = [[myDataJosnValue objectForKey:@"pageSize"] intValue];
    }
    
    if (self.listPath == nil) {
        self.listPath = @"list";
    }
    
    id object = [myDataJosnValue objectForKey:self.listPath];
    
    if (IS_NULL(object)) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    id arrayObject = object;
    
    if (arrayObject == nil || ![arrayObject isKindOfClass:[NSArray class]]) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    NSArray *newDataList = nil;
    
    if (self.itemClass != nil && [self.itemClass isSubclassOfClass:[EHChatMessageinfoModel class]]) {
        newDataList = [self.itemClass modelArrayWithJSON:object];
        /*
        {
            NSString* head_imag_small = nil;
            if ([myDataJosnValue objectForKey:@"head_imag_small"]) {
                head_imag_small = [myDataJosnValue objectForKey:@"head_imag_small"];
            }
            
            NSString* user_nick_name = nil;
            if ([myDataJosnValue objectForKey:@"user_nick_name"]) {
                user_nick_name = [myDataJosnValue objectForKey:@"user_nick_name"];
            }
            
            if (head_imag_small && user_nick_name) {
                for (EHChatMessageinfoModel* chatMessageinfoModel in newDataList) {
                    [chatMessageinfoModel configHeadImagSmall:head_imag_small andUserNickName:user_nick_name];
                }
            }
        }
         */
        
    }else{
        newDataList = (NSArray*)arrayObject;
    }
    
    if (newDataList == nil) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    if ([self isRefresh]) {
        //如果是刷新就将老数据清除掉
        if (self.isForceRecordAllObject) {
            self.isForceRecordAllObject = NO;
            
            [self addObjectsFromArray:newDataList];

        }else{
            [self removeAllObjects];
            [self addObjectsFromArray:newDataList];
        }
        
    }else {
        [self paginationPlus];
        NSRange range = NSMakeRange(0, [newDataList count]);
        [self insertObjects:newDataList atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    }
    
    // 设置newDataCount
    self.newDataCount = newDataList.count;
    
    self.isNeedRefresh = NO;
    if ([self isRefresh] && newDataList.count > 0) {
        self.isNeedRefresh = YES;
    }
}

@end
