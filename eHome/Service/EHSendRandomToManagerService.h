//
//  EHSendRandomToManagerService.h
//  eHome
//
//  Created by louzhenhua on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHSendRandomToManagerService : KSAdapterService

-(void)sendRandomNumToManager:(NSString*)adminPhone withUserPhone:(NSString*)userPhone andBabyNmae:(NSString*)babyName andBabyId:(NSNumber*)babyId;

@end
