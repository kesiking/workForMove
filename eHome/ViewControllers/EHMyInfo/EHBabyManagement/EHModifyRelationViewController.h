//
//  EHModifyRelationViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ModifyRelationSuccess)(NSString* selected);

@interface EHModifyRelationViewController : UIViewController

@property(nonatomic, copy)ModifyRelationSuccess modifyRelationSuccess;
@property(nonatomic, strong)NSNumber * babyId;
@property(nonatomic, strong)NSString* currentRelationShip;
@property(nonatomic, strong)NSString* authority;

@end
