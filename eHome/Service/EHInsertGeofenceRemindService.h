//
//  EHInsertGeofenceRemindService.h
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHGeofenceRemindModel.h"

@interface EHInsertGeofenceRemindService : KSAdapterService

- (void)insertGeofenceRemind:(EHGeofenceRemindModel *)remindReq;

@end
