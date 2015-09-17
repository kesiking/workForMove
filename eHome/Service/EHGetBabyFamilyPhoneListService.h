//
//  EHGetBabyFamilyPhoneListService.h
//  eHome
//
//  Created by louzhenhua on 15/7/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHBabyFamilyPhone.h"

@interface EHGetBabyFamilyPhoneListService : KSAdapterService

- (void)getBabyFamilyPhoneListById:(NSNumber*)babyId;

@end
