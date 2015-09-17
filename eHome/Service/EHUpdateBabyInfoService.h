//
//  EHUpdateBabyInfoService.h
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHUpdateBabyInfoReq.h"

@interface EHUpdateBabyInfoService : KSAdapterService

- (void)updateBabyInfo:(EHUpdateBabyInfoReq*)updateBabyRInfoeq;

@end
