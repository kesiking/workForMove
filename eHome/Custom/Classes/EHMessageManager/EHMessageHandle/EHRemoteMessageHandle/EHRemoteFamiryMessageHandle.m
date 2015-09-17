//
//  EHRemoteFamiryMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteFamiryMessageHandle.h"

@implementation EHRemoteFamiryMessageHandle

-(void)remoteMessageHandle:(EHMessageInfoModel *)messageInfoModel{
    [super remoteMessageHandle:messageInfoModel];
    if (self.remoteMessageCategory == EHMessageInfoCatergoryType_Family) {
        // to do
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyInfoChangedNotification object:nil];
    }
}

@end
