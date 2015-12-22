//
//  EHModifyBabyNameViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ModifyBabyNameSuccess)(NSString* modifiedName);

@interface EHModifyBabyNameViewController : KSViewController

@property(nonatomic, copy)ModifyBabyNameSuccess modifyBabyNameSuccess;

@property(nonatomic, strong)NSNumber * babyId;
@property(nonatomic, strong)NSString * babyName;
@property(nonatomic, strong)NSString * authory;

@end
