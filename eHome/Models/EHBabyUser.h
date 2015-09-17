//
//  EHBabyUser.h
//  eHome
//
//  Created by louzhenhua on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHBabyUser : WeAppComponentBaseItem

@property(nonatomic, strong)NSNumber * baby_id;
@property(nonatomic, strong)NSNumber * user_id;
@property(nonatomic, strong)NSString* baby_nickname;
@property(nonatomic, strong)NSString* relationship;
@property(nonatomic, strong)NSString* authority;

@end
