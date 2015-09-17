//
//  EHDeleteGeofenceService.h
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHDeleteGeofenceService : KSAdapterService

- (void)deleteGeofenceByID:(NSNumber *)geofenceID;

@end
