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

@implementation EHChatMessageLIstService

-(void)setupService{
    [super setupService];
    [self setPageListClass:[EHChatMessagePageList class]];
    EHSingleChatCacheService* cacheService = [EHSingleChatCacheService new];
    [self setCacheService:cacheService];
}

-(void)loadChatMessageListWithBabyId:(NSNumber*)babyId userPhone:(NSString*)userPhone context:(NSString*)context contextType:(NSString*)contextType{
    
    if ([EHUtils isEmptyString:userPhone] || [EHUtils isEmptyString:context]) {
        return;
    }
    if (babyId == nil) {
        return;
    }
    if ([EHUtils isEmptyString:contextType]) {
        contextType = @"0";
    }
    
    NSString* apiName = nil;

    EHChatMessagePaginationItem* paginationItem = [EHChatMessagePaginationItem new];
    NSDictionary* params = @{@"babyId":babyId,@"userPhone":userPhone,@"context":context,@"contextType":contextType};
    
    self.jsonTopKey = nil;
    self.listPath = @"responseData";
    self.itemClass = [EHChatMessageinfoModel class];
    
    if (self.pagedList) {
        [self.pagedList refresh];
        [self.pagedList removeAllObjects];
    }
    
    WEAKSELF
    [self getChatMessageListCacheWithAPIName:apiName params:params pagination:paginationItem readSuccess:^(NSMutableArray *componentItems) {
        STRONGSELF
        if (componentItems && [componentItems count] > 0) {
            [strongSelf configPagelistWithCacheComponentItems:componentItems];
            [strongSelf refreshPagedList];
        }else{
            [strongSelf loadPagedListWithAPIName:apiName params:params pagination:paginationItem version:nil];
        }
    }];
    
}

-(void)getChatMessageListCacheWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination readSuccess:(ReadSuccessCacheBlock)readSuccessBlock{
    NSDictionary* fechtCondtionDict = @{@"where":[NSString stringWithFormat:@"date = '%@'",@""]};
    [self.cacheService readCacheWithApiName:apiName withParam:params withFetchCondition:fechtCondtionDict componentItemClass:[XHBabyChatMessage class] readSuccess:readSuccessBlock];
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
    [super nextPage];
}

@end
