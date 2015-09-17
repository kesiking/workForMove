//
//  EHDelBabyFamilyPhoneService.h
//  eHome
//
//  Created by louzhenhua on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHDelBabyFamilyPhoneService : KSAdapterService


// phoneList内存放dic：@{kEHAttentionPhone:188******, kEHPhoneType:@"0"}
- (void)delBabyFamilyPhone:(NSArray*)phoneList andAdminPhone:(NSString*)adminPhone byBabyId:(NSNumber*)babyId;
@end
