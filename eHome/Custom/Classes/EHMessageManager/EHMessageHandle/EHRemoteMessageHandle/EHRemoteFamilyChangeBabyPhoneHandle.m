//
//  EHRemoteFamilyChangeBabyPhoneHandle.m
//  eHome
//
//  Created by louzhenhua on 15/11/25.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteFamilyChangeBabyPhoneHandle.h"

@implementation EHRemoteFamilyChangeBabyPhoneHandle

-(void)remoteMessageHandle:(EHMessageInfoModel *)messageInfoModel{
    [super remoteMessageHandle:messageInfoModel];
    if (self.remoteMessageCategory == EHMessageInfoCatergoryType_Family_ChangeBabyPhone) {
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@YES forKey:EHFORCE_REFRESH_DATA];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EHBabyListNeedChangeNotification object:nil userInfo:userInfo];
    }
}

@end
