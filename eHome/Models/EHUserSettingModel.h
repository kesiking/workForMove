//
//  EHUserSettingModel.h
//  eHome
//
//  Created by louzhenhua on 15/11/10.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHUserSettingModel : WeAppComponentBaseItem


@property(nonatomic, strong)NSNumber* user_id;
@property(nonatomic, strong)NSNumber* isReceiveMesg;
@property(nonatomic, strong)NSNumber* isShakeOn;
@property(nonatomic, strong)NSNumber* isSoundOn;

@end
