//
//  EHMessageModel.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHMessageModel : WeAppComponentBaseItem{
    NSString            *       _type;
}

// 消息类型
@property (nonatomic, strong) NSString            *         type;
// 消息上下文
@property (nonatomic, strong) NSDictionary        *         messageContext;
// 消息展现的目标source
@property (nonatomic, strong) id                            sourceTarget;

// override for init message model
-(void)configMessage;

@end
