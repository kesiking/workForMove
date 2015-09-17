//
//  EHHealthyBasicModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicModel.h"

@implementation EHHealthyBasicModel

+(NSString*)getPrimaryKey{
    return @"date";
}

+(BOOL)isContainParent
{
    return YES;
}

@end
