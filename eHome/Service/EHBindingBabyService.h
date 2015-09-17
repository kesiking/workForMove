//
//  EHBindingBabyService.h
//  eHome
//
//  Created by 孟希羲 on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHBindingBabyService : KSAdapterService

-(void)bindingBabyWithDeviceCode:(NSString*)deviceCode userPhone:(NSString*)userPhone;

@end
