//
//  EHHealthyAdapterService.m
//  eHome
//
//  Created by 孟希羲 on 15/7/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyAdapterService.h"
#import "EHHealthyAdapterCacheService.h"
#import "EHHealthyBasicModel.h"

@implementation EHHealthyAdapterService

-(void)setupService{
    [super setupService];
    EHHealthyAdapterCacheService* cacheService = [EHHealthyAdapterCacheService new];
    cacheService.cacheStrategy.strategyType = KSCacheStrategyTypeInsert;
    /*
     * fetchConditionDict apiName作为Key，获取相应的fetchCondition (apiName:fetchCondition)
     * fetchCondition 的结构为 (where  :@"id = 1 and name = @"king" ")
     *                        (orderBy:@"xxx")
     *                        (offset :@1)
     *                        (count  :@1)
     */
    [self setCacheService:cacheService];
}

-(void)modelDidStartLoad:(WeAppBasicRequestModel *)model{
    NSString* date = [model.params objectForKey:@"date"];
    if ([model.apiName isEqualToString:kEHGetHealthyWeekMonthInfoApiName]) {
        NSString* type = [model.params objectForKey:@"type"];
        NSDictionary* fechtCondtionDict = @{@"where":[NSString stringWithFormat:@"date = '%@'",date]};
        if ([type isEqualToString:@"week"]) {
            fechtCondtionDict = @{@"where":[NSString stringWithFormat:@"monday <= '%@' and sunday >= '%@'",date,date]};
        }else if([type isEqualToString:@"month"]){
            NSString* whereStr = [self getDateWithDateString:date];
            fechtCondtionDict = @{@"where":whereStr,@"orderBy":@"rowid asc"};
        }
        [self.cacheService.fetchConditionDict setObject:fechtCondtionDict forKey:model.apiName];
    }else if([model.apiName isEqualToString:kEHQueryBabyHealthyForDayApiName]){
        NSDictionary* fechtCondtionDict = @{@"where":[NSString stringWithFormat:@"date = '%@'",date]};
        [self.cacheService.fetchConditionDict setObject:fechtCondtionDict forKey:model.apiName];
    }
    [super modelDidStartLoad:model];
}

-(NSString*)getDateWithDateString:(NSString*)dateString{
    if (dateString == nil) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [outputFormatter stringFromDate:[NSDate date]];
    }
    static NSDateFormatter *inputFormatter = nil;
    if (inputFormatter == nil) {
        inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate* inputDate = [inputFormatter dateFromString:dateString];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    //NSRange daysRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:inputDate];
    
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents * component = [currentCalendar components:unitFlags fromDate:inputDate];
    
    NSInteger year = [component year];
    NSInteger month = [component month];
    NSString* monthStr = month > 9 ? [NSString stringWithFormat:@"%ld",month] : [NSString stringWithFormat:@"0%ld",month];
    NSString* monthFirstDay = [NSString stringWithFormat:@"%ld-%@",year,monthStr];
    NSString* monthLastDay = [NSString stringWithFormat:@"%ld-%@",year,monthStr];
    return [NSString stringWithFormat:@"beginTime like '%@%%' and endTime like '%@%%'",monthFirstDay,monthLastDay];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    if ([model.item isKindOfClass:[EHHealthyBasicModel class]]) {
        EHHealthyBasicModel* healthyModel = (EHHealthyBasicModel*)model.item;
        healthyModel.date = [self.requestModel.params objectForKey:@"date"];
        healthyModel.babyId = [self.requestModel.params objectForKey:@"baby_id"];
    }else if ([model.dataList count] > 0){
        for (WeAppComponentBaseItem* componentItem in model.dataList) {
            if (![componentItem isKindOfClass:[EHHealthyBasicModel class]]) {
                continue;
            }
            EHHealthyBasicModel* healthyModel = (EHHealthyBasicModel*)componentItem;
            healthyModel.date = [self.requestModel.params objectForKey:@"date"];
            healthyModel.babyId = [self.requestModel.params objectForKey:@"baby_id"];
        }
    }
    [super modelDidFinishLoad:model];
}

@end
