//
//  EHRemoteMessageHandleFactory.m
//  eHome
//
//  Created by 孟希羲 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteMessageHandleFactory.h"
#import "EHRemoteBatteryMessageHandle.h"
#import "EHRemoteFamiryMessageHandle.h"
#import "EHRemoteLocationMessageHandle.h"
#import "EHRemoteSOSMessageHandle.h"
#import "EHRemoteOutOrInLineMessageHandle.h"
#import "EHRemoteFamilyChangeBabyPhoneHandle.h"

@implementation EHRemoteMessageHandleFactory

+ (EHRemoteBasicMessageHandle*)getMessageHandleByCategory:(NSUInteger)category{
    switch (category) {
        case EHMessageInfoCatergoryType_Battery:{
            return [EHRemoteBatteryMessageHandle new];
        }
            break;
        case EHMessageInfoCatergoryType_Family:{
            return [EHRemoteFamiryMessageHandle new];
        }
            break;
        case EHMessageInfoCatergoryType_Family_ChangeBabyPhone:{
            return [EHRemoteFamilyChangeBabyPhoneHandle new];
        }
            break;
        case EHMessageInfoCatergoryType_Location:{
            return [EHRemoteLocationMessageHandle new];

        }
            break;
        case EHMessageInfoCatergoryType_SOS:{
            return [EHRemoteSOSMessageHandle new];

        }
            break;
        case EHMessageInfoCatergoryType_OutOrInLine:{
            return [EHRemoteOutOrInLineMessageHandle new];
        }
            break;
        
        default:
            return [EHRemoteBasicMessageHandle new];
            break;
    }
    return [EHRemoteBasicMessageHandle new];
}

@end
