//
//  EHAddUserFeedBackService.h
//  eHome
//
//  Created by xtq on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHAddUserFeedBackService : KSAdapterService

-(void)addUserFeedBackWithUserPhone:(NSString *)userPhone Contact:(NSString*)feedBackContact FeedBackContent:(NSString *)feedBackContent;

@end
