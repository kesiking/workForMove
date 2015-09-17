//
//  EHInsertSuggestionService.m
//  eHome
//
//  Created by xtq on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHInsertSuggestionService.h"

@implementation EHInsertSuggestionService

- (void)insertSuggestionWithUserID:(int)userID sugContent:(NSString *)content{
    [self loadItemWithAPIName:kEHInsertSuggestionApiName params:@{@"user_id":@(userID),@"sug_content":content} version:nil];
}

@end
