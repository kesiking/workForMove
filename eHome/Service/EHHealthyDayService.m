//
//  EHQueryBabyHealthyForDay.m
//  eHome
//
//  Created by jweigang on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyDayService.h"

@implementation EHHealthyDayService
- (instancetype)init
{
    if (self = [super init]){
        self.itemClass = [EHHealthyDayModel class];
        
        // service 是否需要cache
//        self.needCache = YES;
//        self.onlyUserCache = NO;
//        self.jsonTopKey = @"result";
        return self;
    }
    return nil;
}
- (void)queryBabyHealthyDataWithBabyId:(NSInteger)babyId AndDate:(NSString *)date
{
    if(babyId<0||date==nil)
    {
        EHLogError(@"param is error!");
        return;
    }
    [self loadItemWithAPIName:kEHQueryBabyHealthyForDayApiName params:@{kEHBabyId:[NSNumber numberWithInteger:babyId],kEHHealthyDate:date,@"__jsonTopKey__":@"result"} version:nil];
}
@end
