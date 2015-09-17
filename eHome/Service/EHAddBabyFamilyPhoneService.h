//
//  EHAddBabyFamilyPhoneService.h
//  eHome
//
//  Created by louzhenhua on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHBabyFamilyPhone.h"

@interface EHAddBabyFamilyPhoneService : KSAdapterService

- (void)addBabyFamilyPhone:(NSString*)phoneNo andPhoneName:(NSString*)phoneName andPhoneType:(NSString*)phoneType byBabyId:(NSNumber*)babyId;

@end
