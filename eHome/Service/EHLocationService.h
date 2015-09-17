//
//  EHLocationService.h
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHUserDevicePosition.h"

@interface EHLocationService : KSAdapterService

-(void)loadCurruntLocationWithBabyId:(NSString*)babyId;

-(void)loadLocationTraceHistoryWithBabyId:(NSString*)babyId;

-(void)loadLocationTraceHistoryWithBabyId:(NSString*)babyId withData:(NSDate*)date;

@end
