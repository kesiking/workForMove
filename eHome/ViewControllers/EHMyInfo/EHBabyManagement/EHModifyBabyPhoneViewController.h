//
//  EHModifyBabyPhoneViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ModifyBabyPhoneSuccess)(NSString* modifiedPhone);

@interface EHModifyBabyPhoneViewController : KSViewController

@property(nonatomic, copy)ModifyBabyPhoneSuccess modifyBabyPhoneSuccess;

@property(nonatomic, strong)NSNumber * babyId;
@property(nonatomic, strong)NSString * babyPhone;

@end
