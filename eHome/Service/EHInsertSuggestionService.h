//
//  EHInsertSuggestionService.h
//  eHome
//
//  Created by xtq on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHInsertSuggestionService : KSAdapterService

- (void)insertSuggestionWithUserID:(int)userID sugContent:(NSString *)content;

@end
