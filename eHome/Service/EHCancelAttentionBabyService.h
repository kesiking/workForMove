//
//  EHCancelAttentionBabyService.h
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHCancelAttentionBabyService : KSAdapterService

-(void)cancelAttentionBaby:(NSInteger)babyId byBabyUser:(NSInteger)userId;

@end
