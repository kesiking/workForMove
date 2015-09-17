//
//  EHTransferBabyManagerService.m
//  eHome
//
//  Created by louzhenhua on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHTransferBabyManagerService.h"

@implementation EHTransferBabyManagerService

- (void)transferManagerTo:(NSString*)to byBabyId:(NSNumber*)babyId from:(NSString*)from
{
    if (babyId < 0 || from == nil || to == nil) {
        EHLogError(@"param is error!");
        return;
    }
    
    [self loadItemWithAPIName:kEHTransferBabyManagerApiName params:@{kEHBabyId:babyId, kEHGardianPhone:from, kEHUserPhone:to} version:nil];

}

@end
