//
//  EHFamilyNumberSelectRelectionViewController.m
//  eHome
//
//  Created by jss on 15/11/20.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyNumberSelectRelectionViewController.h"

@interface EHFamilyNumberSelectRelectionViewController ()

@end

@implementation EHFamilyNumberSelectRelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)confirmClicked:(id)sender
{
    [self.customRelationTextFiled resignFirstResponder];
    NSString*customRelation;
    if ([EHUtils isEmptyString:self.finalSelectedRelation])
    {
        customRelation = @"家人";
    }
    else
    {
        customRelation = [EHUtils trimmingHeadAndTailSpaceInstring:self.finalSelectedRelation];
    }
    
    if ([customRelation length] > EHOtherNameLength) {
        [WeAppToast toast:(@"宝贝关系超过最大长度10!")];
        return;
    }
    
    if (![EHUtils isValidString:customRelation]) {
        [WeAppToast toast:(@"宝贝关系不支持特殊字符!")];
        return;
    }
    
    if (![EHUtils isEmptyString:customRelation]) {
        self.selectedRelation = customRelation;
    }

    self.selectRelationBlock(self.selectedRelation);
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
