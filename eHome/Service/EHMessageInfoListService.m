//
//  EHMessageInfoListService.m
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageInfoListService.h"

@implementation EHMessageInfoListService

-(void)loadMessageInfoListWithBabyId:(NSString*)babyId userPhone:(NSString*)userPhone Type:(NSInteger)type{
    if (userPhone == nil) {
        userPhone = [KSAuthenticationCenter userPhone];
    }
    if (userPhone == nil) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (babyId) {
        [params setObject:[NSNumber numberWithInteger:[babyId integerValue]] forKey:@"baby_id"];
    }else{
        [params setObject:@0 forKey:@"baby_id"];
    }
    if (userPhone) {
        [params setObject:userPhone forKey:@"user_phone"];
    }
    if (type) {
        [params setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    }
    [params setObject:@"result" forKey:@"__jsonTopKey__"];
    
    KSPaginationItem* pagnation = [KSPaginationItem new];
    pagnation.pageSize = DEFAULT_PAGE_SIZE;
    
    self.jsonTopKey = nil;
    self.listPath = @"responseData";
    self.itemClass = [EHMessageInfoModel class];
    
    if (self.pagedList) {
        [self.pagedList refresh];
        [self.pagedList removeAllObjects];
    }
    
    [self loadPagedListWithAPIName:kEHGetMessageInfoListApiName params:params pagination:pagnation version:nil];
}

-(void)sendSOSMessageInfoListWithDeviceCode:(NSString*)device_code address:(NSString*)address{
    if (device_code == nil) {
        return;
    }
    if (address == nil) {
        address = @"浙江省杭州市拱墅区560号";
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (device_code) {
        [params setObject:device_code forKey:@"device_code"];
    }
    
    if (address) {
        [params setObject:address forKey:@"address"];
    }
    [params setObject:@"result" forKey:@"__jsonTopKey__"];
    
    [self loadItemWithAPIName:kEHSOSMessageSendApiName params:params version:nil];
}

@end
