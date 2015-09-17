//
//  EHRemoteMessageModel.h
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageModel.h"
#import "EHMessageInfoModel.h"

@interface EHRemoteMessageModel : EHMessageModel

// 远程推送消息dict
@property (nonatomic, strong) NSDictionary        * remoteMessageDict;
// 远程推送消息
@property (nonatomic, strong) EHMessageInfoModel  * remoteMessageInfo;

@end
