//
//  EHAddBabyUserService.h
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHBabyUser.h"

@interface EHAddBabyUserService : KSAdapterService

- (void)addBabyUser:(EHBabyUser*)babyUser;

@end
