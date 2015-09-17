//
//  EHFamilyNumbersViewController.h
//  eHome
//
//  Created by jinmiao on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHBabyFamilyPhone.h"

//typedef void(^PhoneListBlock)(NSDictionary *phoneList);//声明代码块类型

@interface EHFamilyNumbersViewController : KSViewController

@property (nonatomic, strong) NSNumber *babyId;
//@property (copy, nonatomic) PhoneListBlock phoneListBlock;
@property (nonatomic, strong) NSMutableArray* familyNumberList;

@property (nonatomic, strong) NSMutableArray * familyNumberListWithType;

@end
