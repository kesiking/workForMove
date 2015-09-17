//
//  EHLocationService.m
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHLocationService.h"

@implementation EHLocationService

static NSDateFormatter *outputFormatter = nil;

-(void)loadCurruntLocationWithBabyId:(NSString*)babyId{
    if (babyId == nil) {
        EHLogError(@"babyId is nil!");
        return;
    }
    self.itemClass = [EHUserDevicePosition class];
    self.jsonTopKey = @"responseData";
}

-(void)loadLocationTraceHistoryWithBabyId:(NSString*)babyId{
    [self loadLocationTraceHistoryWithBabyId:babyId withData:nil];
}

-(void)loadLocationTraceHistoryWithBabyId:(NSString*)babyId withData:(NSDate*)date{
    if (babyId == nil) {
        EHLogError(@"babyId is nil!");
        return;
    }
    self.itemClass = [EHUserDevicePosition class];
    self.jsonTopKey = @"responseData";
    
    if (outputFormatter == nil) {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSString* require_date = nil;
    
    if (date == nil) {
        require_date = [outputFormatter stringFromDate:[NSDate date]];
    }else{
        require_date = [outputFormatter stringFromDate:date];
    }
    
    [self loadDataListWithAPIName:kEHLocationTraceHistoryApiName params:@{@"baby_id":babyId,@"require_date":require_date?:@""} version:nil];
}

@end
