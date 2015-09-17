//
//  EHInviteBabyUserService.h
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHInviteBabyUserService : KSAdapterService

- (void)inviteUser:(NSString*)userPhone ToAttentionBaby:(NSInteger)babyId byAdmin:(NSString*)adminPhone;

@end
