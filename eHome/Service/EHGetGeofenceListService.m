//
//  EHGetGeofenceListService.m
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGetGeofenceListService.h"

@implementation EHGetGeofenceListService

- (void)getGeofenceListWithBabyID:(int)baby_id UserID:(int)user_id{
    self.jsonTopKey = @"responseData";
    self.itemClass = [EHGetGeofenceListRsp class];
    
    [self loadDataListWithAPIName:kEHQueryGeofenceForListApiName params:@{@"baby_id":@(baby_id),@"user_id":@(user_id),@"__jsonTopKey__":@"result"} version:nil];
}

@end
