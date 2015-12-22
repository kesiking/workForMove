//
//  EHGetBabyBindingStatusListService.m
//  eHome
//
//  Created by jss on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyBindingStatusListService.h"

@implementation EHGetBabyBindingStatusListService

-(void)getBabyBindingStatusList:(NSNumber*)baby_id  Phone:(NSString *)manager_phone{
    
    self.itemClass=[EHBabyBindingStatusListRsp class];
    self.jsonTopKey = @"responseData";

    if (!baby_id) {
        EHLogError(@"baby_id is nil");
        return;
    }
    
    if(!manager_phone){
        EHLogError(@"phone is nil");
        return;
    }
    
    [self loadDataListWithAPIName:kEHGetBabyBindingStatusListApiName params:@{@"baby_id":baby_id,@"gardian_phone":manager_phone} version:nil];
}


@end
