//
//  EHAddUserFeedBackService.m
//  eHome
//
//  Created by xtq on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddUserFeedBackService.h"

@implementation EHAddUserFeedBackService

-(void)addUserFeedBackWithUserPhone:(NSString *)userPhone Contact:(NSString*)feedBackContact FeedBackContent:(NSString *)feedBackContent{
    if (userPhone == nil) {
        userPhone = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (feedBackContact == nil) {
        EHLogError(@"feedBackContact is nil");
        return;
    }
    if (feedBackContent == nil) {
        EHLogError(@"feedBackContent is nil");
        return;
    }
    [self loadItemWithAPIName:kEHAddUserFeedBackApiName params:@{@"user_phone":userPhone,@"feedBack_contact":feedBackContact,@"feedBack_content":feedBackContent} version:nil];
}

@end
