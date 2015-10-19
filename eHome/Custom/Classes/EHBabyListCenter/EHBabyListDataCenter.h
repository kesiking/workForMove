//
//  EHBabyListDataCenter.h
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHGetBabyListRsp.h"
#import "EHUserDevicePosition.h"
#import "EHBabyDeviceStatus.h"

@interface EHBabyListDataCenter : NSObject

// 宝贝列表
@property (nonatomic, strong) NSArray             *   babyList;
// 当前选中的宝贝
@property (nonatomic, strong) EHGetBabyListRsp    *   currentBabyUserInfo;
// 当前选中的宝贝位置
@property (nonatomic, strong) EHUserDevicePosition*   currentBabyPosition;
// 当前选中宝贝的设备状态
@property (nonatomic, strong) EHBabyDeviceStatus  *   currentBabyDeviceStatus;
// 当前选中的宝贝id
@property (nonatomic, strong) NSString            *   currentBabyId;
// 当前聊天中的宝贝id，如果没有聊天则为nil
@property (nonatomic, strong) NSString            *   currentChatBabyId;

@property (nonatomic, assign) BOOL                    isServiceFailed;

+ (instancetype)sharedCenter;

- (void)setCurrentSelectBabyId:(NSNumber *)currentSelectBabyId;

- (EHGetBabyListRsp*)getBabyListRspWithBabyId:(NSNumber *)babyId;

@end
