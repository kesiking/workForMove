//
//  EHGetQueryForFeedbackService.m
//  eHome
//
//  Created by xtq on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetQueryForFeedbackService.h"
#import "EHFeedbackModel.h"
@implementation EHGetQueryForFeedbackService

//-(void)setupService{
//    [super setupService];
//    self.cacheService.cacheStrategy.strategyType = KSCacheStrategyTypeInsert;
//}

- (void)getQueryForFeedbackWithUserID:(int)user_id Page:(int)page Rows:(int)rows{
    self.jsonTopKey = @"responseData";
    self.itemClass = [EHFeedbackModel class];
    [self loadDataListWithAPIName:kEHQueryForFeedbackApiName params:@{@"user_id":@(user_id),@"page":@(page),@"rows":@(rows)} version:nil];
}

-(void)modelDidStartLoad:(WeAppBasicRequestModel *)model{
    NSDictionary* fechtCondtionDict = @{@"orderBy":@"time asc"};
    [self.cacheService.fetchConditionDict setObject:fechtCondtionDict forKey:self.apiName];
    [super modelDidStartLoad:model];
}

@end
