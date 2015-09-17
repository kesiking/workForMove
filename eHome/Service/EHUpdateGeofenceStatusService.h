//
//  EHUpdateGeofenceStatusService.h
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHUpdateGeofenceStatusService : KSAdapterService

- (void)updateGeofenceStatus:(NSArray *)geofenceStatus;

@end
