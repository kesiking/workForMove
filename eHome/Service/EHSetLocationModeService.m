//
//  EHSetLocationModeService.m
//  eHome
//
//  Created by jss on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSetLocationModeService.h"

@implementation EHSetLocationModeService

-(void)setLocationMode:(NSString*)babyId babyLocationMode:(NSString*)locationMode;{
    if(babyId==nil){
        EHLogError(@"babyId is nil!");
        return;
    }
    if (locationMode==nil) {
        EHLogError(@"baby safe mode is nil");
        return;
    }
    
    [self loadDataListWithAPIName:KEHSetLocationModeApiName params:@{@"baby_id":babyId,@"workMode":locationMode} version:nil];
    
}


//-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
//    NSNumber* babyId = [model.params objectForKey:@"baby_id"];
//    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
//    if ([babyId integerValue] == [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]) {
//        [userInfo setObject:@YES forKey:EHFORCE_REFRESH_DATA];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyInfoChangedNotification object:nil userInfo:userInfo];
//    [super modelDidFinishLoad:model];
//}

@end
