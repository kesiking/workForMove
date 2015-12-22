//
//  EHSelectRelationToBabyViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSelectRelationToBabyViewController.h"
#import "KSInsetsTextField.h"

@interface EHSelectRelationToBabyViewController ()

@end

@implementation EHSelectRelationToBabyViewController

//不同的实现
- (void)confirmClicked:(id)sender
{
    [self.customRelationTextFiled resignFirstResponder];
    
    if ([EHUtils isEmptyString:self.finalSelectedRelation])
    {
        //[WeAppToast toast:(@"请选择您与宝贝的关系!")];
        self.selectedRelation = @"家人";
    }
    else
    {
        self.selectedRelation = [EHUtils trimmingHeadAndTailSpaceInstring:self.finalSelectedRelation];
    }
    
    if ([self.selectedRelation length] > EHOtherNameLength) {
        [WeAppToast toast:(@"宝贝关系超过最大长度10!")];
        return;
    }
    
    if (![EHUtils isValidString:self.selectedRelation]) {
        [WeAppToast toast:(@"宝贝关系不支持特殊字符!")];
        return;
    }

    if ([self.selectedRelationdelegate respondsToSelector:@selector(selectedRelation:)])
    {
        [self.selectedRelationdelegate selectedRelation:self.selectedRelation];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}





@end
