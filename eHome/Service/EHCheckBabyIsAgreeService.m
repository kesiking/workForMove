//
//  EHCheckBabyIsAgreeService.m
//  eHome
//
//  Created by jss on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHCheckBabyIsAgreeService.h"

@implementation EHCheckBabyIsAgreeService

-(void)checkBabyIsAgreeService :(NSString *)userphone babyId:(NSNumber *)babyId baby_nickname:(NSString *)baby_nickname relationship:(NSString*)relationship{
    
    [self loadItemWithAPIName:KEHCheckBabyIsAgreeApiName params:@{@"user_phone":userphone,@"baby_id":babyId,@"baby_nickname":baby_nickname,@"relationship":relationship} version:nil];
    
}


@end
