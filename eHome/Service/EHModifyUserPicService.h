//
//  EHModifyUserPicService.h
//  eHome
//
//  Created by xtq on 15/6/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHModifyUserPicService : KSAdapterService

-(void)modifyUserPicWithUserPhone:(NSString *)userPhone PicUrl:(NSString*)url SmallPicUrl:(NSString*)smallUrl;

@end
