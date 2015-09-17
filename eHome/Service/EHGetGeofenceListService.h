//
//  EHGetGeofenceListService.h
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHGetGeofenceListRsp.h"

@interface EHGetGeofenceListService : KSAdapterService

- (void)getGeofenceListWithBabyID:(int)baby_id UserID:(int)user_id;

@end
