//
//  EHAddBabyInfoService.h
//  eHome
//
//  Created by louzhenhua on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHAddBabyInfoReq.h"

@interface EHAddBabyInfoService : KSAdapterService

- (void)addBabyInfo:(EHAddBabyInfoReq*)babyInfo;

@end
