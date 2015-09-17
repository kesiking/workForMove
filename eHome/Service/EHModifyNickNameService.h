//
//  EHModifyNickNameService.h
//  eHome
//
//  Created by xtq on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHModifyNickNameService : KSAdapterService

-(void)modifyNickNameWithUserPhone:(NSString *)userPhone nickName:(NSString*)nickName;

@end
