//
//  EHAttentionMessageModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAttentionMessageModel.h"
#import "EHMessageMaroc.h"

@implementation EHAttentionMessageModel

-(void)configMessage{
    [super configMessage];
    self.type = kEHAttentionViewMessageType;
}

@end
