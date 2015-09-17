//
//  EHGetBabyAttentionUsersService.h
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHGetBabyAttentionUsersService : KSAdapterService

-(void)getThisBabyAllAttentionUsers:(NSNumber*)babyId;

@end
