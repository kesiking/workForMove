//
//  EHUpdateBabyUserService.h
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHBabyUser.h"

@interface EHUpdateBabyUserService : KSAdapterService

- (void)updateBabyUser:(EHBabyUser*)babyUser;

@end
