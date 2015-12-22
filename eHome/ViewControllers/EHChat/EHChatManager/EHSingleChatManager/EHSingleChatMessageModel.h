//
//  EHSingleChatMessageModel.h
//  eHome
//
//  Created by 孟希羲 on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EIM_XMPP/XMPPManager.h>

@interface EHSingleChatMessageModel : NSObject

@property (nonatomic, strong) MessageModel              *model;

- (instancetype)initWithMessageModel:(MessageModel*)model;

@end
