//
//  EHDeleteBabyUserService.h
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHDeleteBabyUserService : KSAdapterService

// phoneList内存放dic：@{kEHAttentionPhone:188******}

- (void)deleteUsers:(NSArray*)userPhoneList ToAttentionBaby:(NSNumber*)babyId byAdmin:(NSString*)adminPhone;

@end
