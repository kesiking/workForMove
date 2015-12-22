//
//  EHUpdateBabyDeviceSmsCardService.h
//  eHome
//
//  Created by louzhenhua on 15/11/17.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHUpdateBabyDeviceSmsCardService : KSAdapterService

- (void)updateBabyDeviceSmsCard:(NSString*)phoneNo byBabyId:(NSNumber *)babyid;

@end
