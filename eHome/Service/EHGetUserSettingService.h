//
//  EHGetUserSettingService.h
//  eHome
//
//  Created by louzhenhua on 15/11/10.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHGetUserSettingService : KSAdapterService

- (void)getUserSetting:(NSNumber *)userId;

@end
