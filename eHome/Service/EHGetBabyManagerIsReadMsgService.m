//
//  EHGetBabyManagerIsReadMsgService.m
//  eHome
//
//  Created by jss on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetBabyManagerIsReadMsgService.h"

@implementation EHGetBabyManagerIsReadMsgService

-(void)getBabyManagerIsReadMsgService: (NSString *) phone{
    if(phone==nil){
        EHLogError(@"phone is nil");
    }
    self.jsonTopKey = @"responseData";
    [self loadNumberValueWithAPIName:kEHGetBabyManagerIsReadMsgApiName params:@{@"gardian_phone":phone} version:nil];
}

@end
