//
//  EHCHatMessageLIstService.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessageLIstService.h"
#import "EHChatMessagePaginationItem.h"
#import "EHSingleChatCacheService.h"
#import "EHChatMessageinfoModel.h"
#import "EHUtils.h"

#define list_path_str @"responseData"

#define chatMessageListDefaultPageSize (20)

@interface EHChatMessageLIstService(){
    NSInteger       _count;
}

@property(nonatomic,assign) BOOL            isPageListFromCache;

@end

@implementation EHChatMessageLIstService

-(void)setupService{
    [super setupService];
    [self setPageListClass:[EHChatMessagePageList class]];
    EHSingleChatCacheService* cacheService = [EHSingleChatCacheService new];
    [self setCacheService:cacheService];
}

-(WeAppBasicPagedList *)pagedList{
    return self.requestModel.pagedList;
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
    paginationItem.pageSize = chatMessageListDefaultPageSize;
    NSDictionary* params = @{@"baby_id":babyId,@"userPhone":userPhone};
    
    self.jsonTopKey = nil;
    self.listPath = list_path_str;
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
            strongSelf.isPageListFromCache = YES;
            [strongSelf modelDidFinishLoad:strongSelf.requestModel];
            strongSelf.isPageListFromCache = NO;
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
// 获取数据库最后一条消息
-(void)getLastChatMessageWithBabyId:(NSNumber*)babyId readSuccess:(ReadSuccessCacheBlock)readSuccessBlock{
    if (babyId == nil) {
        return;
    }
    
    NSString* apiName = KEHGetChatMessageListApiName;
    
    EHChatMessagePaginationItem* paginationItem = [EHChatMessagePaginationItem new];
    #define chatMessageSingleMessageSize (1)
    paginationItem.pageSize = chatMessageSingleMessageSize;
    NSDictionary* params = @{@"baby_id":babyId};
    
    NSDictionary* fechtCondtionDict = [self getFetchDictionaryWithPagination:paginationItem];
    [self getChatMessageListCacheWithAPIName:apiName params:params pagination:paginationItem withFetchCondition:fechtCondtionDict readSuccess:^(NSMutableArray *componentItems) {
        readSuccessBlock(componentItems);
    }];
}
-(void)configPagelistWithCacheComponentItems:(NSMutableArray*)componentItems{
    if (self.requestModel.pagedList == nil) {
        self.requestModel.pagedList = [[EHChatMessagePageList alloc] init];
        self.requestModel.pagedList.itemClass = [EHChatMessageinfoModel class];
        [self.requestModel.pagedList setListPath:list_path_str];
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
        EHChatMessagePaginationItem* paginationItem = [EHChatMessagePaginationItem new];
        paginationItem.pageSize = chatMessageListDefaultPageSize;
        [paginationItem setPagination:self.requestModel.pagedList.pagination];
        [paginationItem paginationPlus];
        if ([self hasMoreWithPagination:paginationItem]) {
            [self.requestModel.pagedList nextPage];
            NSDictionary* fechtCondtionDict = [self getFetchDictionaryWithPagination:self.pagedList.pagination];
            [self getChatMessageListCacheWithAPIName:self.apiName params:self.requestModel.params pagination:self.requestModel.pagedList.pagination withFetchCondition:fechtCondtionDict readSuccess:^(NSMutableArray *componentItems) {
                STRONGSELF
                if (componentItems && [componentItems count] > 0) {
                    NSRange range = NSMakeRange(0, [componentItems count]);
                    [strongSelf.requestModel.pagedList insertObjects:componentItems atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
                }
                strongSelf.isPageListFromCache = YES;
                [strongSelf modelDidFinishLoad:self.requestModel];
                strongSelf.isPageListFromCache = NO;
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

-(BOOL)hasMoreData{
    BOOL cacheHasMore = _count > self.pagedList.count;
    BOOL serviceHasMore = [self.pagedList hasMore];
    return cacheHasMore || serviceHasMore;
}

-(NSDictionary*)getFetchDictionaryWithPagination:(WeAppPaginationItem*)pagination{
    if (_count <= pagination.pageSize * (pagination.curPage + 1)) {
        NSInteger pageSize = _count - pagination.pageSize * (pagination.curPage);
        if (pageSize <= 0) {
            return nil;
        }
        return @{@"orderBy":@"msgTimestamp asc",@"count":@(pageSize),@"offset":@(0)};
    }
    return @{@"orderBy":@"msgTimestamp asc",@"count":@(pagination.pageSize),@"offset":@(_count - pagination.pageSize * (pagination.curPage + 1))};
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    if (!self.isPageListFromCache
        && self.pagedList
        && [self.pagedList isKindOfClass:[EHChatMessagePageList class]]
        && ((EHChatMessagePageList*)self.pagedList).insertDataList
        && ((EHChatMessagePageList*)self.pagedList).insertDataList.count > 0) {
        [self.cacheService writeCacheWithApiName:self.requestModel.apiName withParam:self.requestModel.params componentItemArray:((EHChatMessagePageList*)self.pagedList).insertDataList writeSuccess:^(BOOL success) {
            
        }];
    }
    [super modelDidFinishLoad:model];
}

@end
