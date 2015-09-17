//
//  EHTransferBabyManagerService.h
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHTransferBabyManagerService : KSAdapterService

- (void)transferManagerTo:(NSString*)to byBabyId:(NSNumber*)babyId from:(NSString*)from;

@end
