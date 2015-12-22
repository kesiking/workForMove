//
//  EHFamNumberEditViewController.h
//  eHome
//
//  Created by jinmiao on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "EHBabyFamilyPhone.h"
@interface EHFamNumberEditViewController : KSViewController

typedef void(^PhoneEditBlock)(EHBabyFamilyPhone *phoneModel);

//@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *babyId;
@property (nonatomic, copy) PhoneEditBlock editBlock;
@property (nonatomic, strong) EHBabyFamilyPhone *phoneModel;
@property (nonatomic, strong) NSString *relationShip;
@end
