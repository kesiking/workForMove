//
//  EHMessageInfoListService.h
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHMessageInfoModel.h"

@interface EHMessageInfoListService : KSAdapterService

-(void)loadMessageInfoListWithBabyId:(NSString*)babyId userPhone:(NSString*)userPhone Type:(NSInteger)type;

-(void)sendSOSMessageInfoListWithDeviceCode:(NSString*)device_code address:(NSString*)address;

@end
