//
//  EHRemoteMessageTimeOverdueObject.h
//  eHome
//
//  Created by 孟希羲 on 15/8/28.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHMessageInfoModel.h"

@interface EHRemoteMessageTimeOverdueObject : NSObject

+ (BOOL)isRemoteMessageTimeOverdue:(EHMessageInfoModel*)messageInfoModel;

@end
