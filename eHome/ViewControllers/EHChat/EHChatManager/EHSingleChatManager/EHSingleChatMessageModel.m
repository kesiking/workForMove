//
//  EHSingleChatMessageModel.m
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatMessageModel.h"

@implementation EHSingleChatMessageModel

- (instancetype)initWithMessageModel:(MessageModel*)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

@end
