//
//  EHUnBindBabyService.h
//  eHome
//
//  Created by louzhenhua on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHUnBindBabyService : KSAdapterService

-(void)unBindBabyWithBabyId:(NSNumber*)babyId userId:(NSNumber*)userId;

@end
