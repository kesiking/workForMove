//
//  EHCheckBabyIsAgreeService.h
//  eHome
//
//  Created by jss on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHCheckBabyIsAgreeService : KSAdapterService
-(void)checkBabyIsAgreeService :(NSString *)userphone babyId:(NSNumber *)babyId baby_nickname:(NSString *)baby_nickname relationship:(NSString*)relationship;

@end
