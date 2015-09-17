//
//  EHServiceDemo.m
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHServiceDemo.h"

@implementation EHServiceDemo

-(void)loadData{
    self.itemClass = [EHModelDemo class];
    [self loadItemWithAPIName:@"terUserAction/loginCheck.do" params:@{@"user_phone":@"18019437985",@"user_password":@"123456"} version:nil];
}



@end
