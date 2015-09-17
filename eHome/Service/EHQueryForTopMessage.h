//
//  EHQueryForTopMessage.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHDeviceStatusModel.h"

@interface EHQueryForTopMessage : KSAdapterService

-(void)queryForTopMessageWithUserPhone:(NSString *)userPhone babyId:(NSString*)babyId;

@end
