//
//  EHNewApplyFamileMemberViewController.h
//  eHome
//
//  Created by jss on 15/8/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHBabyBindingStatusListRsp.h"

typedef void (^RedPointISShow)(BOOL isShow);
typedef void (^BindingBabySuccess)();


@interface EHNewApplyFamilyMemberViewController : KSViewController

@property (nonatomic,strong) NSArray * newfamilyMemberList;
@property (nonatomic,strong) NSNumber* baby_Id;

@property (nonatomic,copy)RedPointISShow redPointIsShow;
@property (nonatomic,copy)BindingBabySuccess bindingBabySuccess;

@end
