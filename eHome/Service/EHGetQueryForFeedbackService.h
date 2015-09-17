//
//  EHGetQueryForFeedbackService.h
//  eHome
//
//  Created by xtq on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHGetQueryForFeedbackService : KSAdapterService

- (void)getQueryForFeedbackWithUserID:(int)user_id Page:(int)page Rows:(int)rows;

@end
