//
//  EHGetBabyBindingStatusListService.h
//  eHome
//
//  Created by jss on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHBabyBindingStatusListRsp.h"

@interface EHGetBabyBindingStatusListService : KSAdapterService

-(void)getBabyBindingStatusList:(NSNumber *)baby_id  Phone:(NSString *)manager_phone;

@end
