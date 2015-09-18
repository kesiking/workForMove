//
//  EHCHatMessageLIstService.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessageLIstService.h"
#import "EHChatMessagePageList.h"
#import "EHChatMessagePaginationItem.h"
#import "EHSingleChatCacheService.h"
#import "EHChatMessageinfoModel.h"
#import "EHUtils.h"

@interface EHChatMessageLIstService(){
    NSInteger       _count;
}

@end

@implementation EHChatMessageLIstService

-(void)setupService{
    [super setupService];
    [self setPageListClass:[EHChatMessagePageList class]];
    EHSingleChatCacheService* cacheService = [EHSingleChatCacheService new];
    [self setCacheService:cacheService];
}

-(void)loadChatMessageListWithBabyId:(NSNumber*)babyId userPhone:(NSString*)userPhone{
    
    if ([EHUtils isEmptyString:userPhone]) {
        return;
    }
    if (babyId == nil) {
        return;
    }
    
    NSString* apiName = KEHGetChatMessageListApiName;

    EHChatMessagePaginationItem* paginationItem = [EHChatMessagePaginationItem new];
    NSDictionary* params = @{@"baby_id":babyId,@"userPhone":userPhone};
    
    self.jsonTopKey = nil;
    self.listPath = @"responseData";
    self.itemClass = [EHChatMessageinfoModel class];
    
    if (self.pagedList) {
        [self.pagedList refresh];
        [self.pagedList removeAllObjects];
    }
    
    WEAKSELF
    _count = [self getChatMessageListCacheTotleCountWithAPIName:apiName params:params pagination:paginationItem withFetchCondition:nil];
    NSDictionary* fechtCondtionDict = [self getFetchDictionaryWithPagination:paginationItem];
    [self getChatMessageListCacheWithAPIName:apiName params:params pagination:paginationItem withFetchCondition:fechtCondtionDict readSuccess:^(NSMutableArray *componentItems) {
        STRONGSELF
        if (componentItems && [componentItems count] > 0) {
            [strongSelf configPagelistWithCacheComponentItems:componentItems];
            [strongSelf.requestModel setModelWithAPIName:apiName params:params returnDataType:WeAppDataTypePagedList pagination:paginationItem version:nil];
            [strongSelf modelDidFinishLoad:strongSelf.requestModel];
            [strongSelf refreshPagedList];
        }else{
            [strongSelf loadPagedListWithAPIName:apiName params:params pagination:paginationItem version:nil];
        }
    }];
    
}

-(NSInteger)getChatMessageListCacheTotleCountWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination withFetchCondition:(NSDictionary*)fetchCondition{
    return [self.cacheService rowCountWithApiName:apiName withParam:params componentItemClass:[EHChatMessageinfoModel class] withFetchCondition:fetchCondition];
}

-(void)getChatMessageListCacheWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination withFetchCondition:(NSDictionary*)fetchCondition readSuccess:(ReadSuccessCacheBlock)readSuccessBlock{
    [self.cacheService readCacheWithApiName:apiName withParam:params withFetchCondition:fetchCondition componentItemClass:[EHChatMessageinfoModel class] readSuccess:readSuccessBlock];
}

-(void)configPagelistWithCacheComponentItems:(NSMutableArray*)componentItems{
    if (self.requestModel.pagedList == nil) {
        self.requestModel.pagedList = [[EHChatMessagePageList alloc] init];
        self.requestModel.pagedList.itemClass = [EHChatMessageinfoModel class];
        [self.requestModel.pagedList setListPath:@"responseData"];
    }
    [self.requestModel.pagedList removeAllObjects];
    [self.requestModel.pagedList refresh];
    [self.requestModel.pagedList addObjectsFromArray:componentItems];
}

-(void)refreshPagedList{
    [super refreshPagedList];
}

-(void)nextPage{
    if (self.pagedList == nil) {
        return;
    }
    if (self.pagedList.count > 0 && _count >= (NSInteger)self.pagedList.count) {
        WEAKSELF
        [self.requestModel.pagedList nextPage];
        if ([self hasMoreWithPagination:self.pagedList.pagination]) {
            NSDictionary* fechtCondtionDict = [self getFetchDictionaryWithPagination:self.pagedList.pagination];
            [self getChatMessageListCacheWithAPIName:self.apiName params:self.requestModel.params pagination:self.requestModel.pagedList.pagination withFetchCondition:fechtCondtionDict readSuccess:^(NSMutableArray *componentItems) {
                STRONGSELF
                if (componentItems && [componentItems count] > 0) {
                    NSRange range = NSMakeRange(0, [componentItems count]);
                    [strongSelf.requestModel.pagedList insertObjects:componentItems atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
                    [strongSelf modelDidFinishLoad:self.requestModel];
                }else{
                    
                }
            }];
            return;
        }
    }
    [super nextPage];
}

-(BOOL)hasMoreWithPagination:(WeAppPaginationItem*)pagination{
    if (_count <= pagination.pageSize * (pagination.curPage + 1)) {
        NSInteger pageSize = _count - pagination.pageSize * (pagination.curPage);
        if (pageSize <= 0) {
            return NO;
        }
    }
    
    return YES;
}

-(NSDictionary*)getFetchDictionaryWithPagination:(WeAppPaginationItem*)pagination{
    if (_count <= pagination.pageSize * (pagination.curPage + 1)) {
        NSInteger pageSize = _count - pagination.pageSize * (pagination.curPage);
        if (pageSize <= 0) {
            return nil;
        }
        return @{@"orderBy":@"msgid asc",@"count":@(pageSize),@"offset":@(0)};
    }
    return @{@"orderBy":@"msgid asc",@"count":@(pagination.pageSize),@"offset":@(_count - pagination.pageSize * (pagination.curPage + 1))};
}

@end
