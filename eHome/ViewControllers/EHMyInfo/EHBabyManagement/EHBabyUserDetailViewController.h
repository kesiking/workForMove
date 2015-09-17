//
//  EHBabyUserDetailViewController.h
//  eHome
//
//  Created by louzhenhua on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHGetBabyListRsp.h"

@interface EHBabyUserDetailViewController : KSViewController
@property (nonatomic, strong)EHGetBabyListRsp* babyUser;
@property (nonatomic, copy)  NSString *name;
@end
