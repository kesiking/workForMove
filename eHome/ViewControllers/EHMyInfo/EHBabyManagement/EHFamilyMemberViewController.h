//
//  EHFamilyMemberViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FamilyMemberDidChanged)(BOOL bChanged);

@interface EHFamilyMemberViewController : KSViewController
@property(nonatomic, copy)FamilyMemberDidChanged familyMemberDidChanged;
@property(nonatomic, strong)NSNumber* babyId;
@property(nonatomic, strong)NSString* babyName;
@property(nonatomic, strong)NSMutableString* authority;
@property(nonatomic, strong)NSString* device_code;

@end
