//
//  EHRemoteMessageModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRemoteMessageModel.h"
#import "EHMessageMaroc.h"

@implementation EHRemoteMessageModel
@synthesize remoteMessageInfo = _remoteMessageInfo;

-(void)configMessage{
    [super configMessage];
    self.type = kEHRemoteMessageType;
}

-(EHMessageInfoModel*)remoteMessageInfo{
    if (_remoteMessageInfo == nil && _remoteMessageDict != nil) {
        _remoteMessageInfo = [EHMessageInfoModel modelWithJSON:_remoteMessageDict];
    }
    return _remoteMessageInfo;
}

@end
