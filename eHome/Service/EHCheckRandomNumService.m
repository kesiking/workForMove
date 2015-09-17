//
//  EHCheckRandomNumService.m
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHCheckRandomNumService.h"

@implementation EHCheckRandomNumService

-(void)checkRandomNum:(NSString*)randomNum withUserPhone:(NSString*)userPhone
{
    if (randomNum == nil || userPhone == nil) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHCheckRandomNumApiName params:@{kEHSecurityCode:randomNum, kEHUserPhone:userPhone} version:nil];
}
@end
