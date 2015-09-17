//
//  EHNetworkMessageModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/28.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHNetworkMessageModel.h"
#import "EHMessageMaroc.h"

@implementation EHNetworkMessageModel

-(void)configMessage{
    [super configMessage];
    self.type = kEHNetworkMessageType;
}

@end
