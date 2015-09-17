//
//  EHAttentionViewMessageHandle.h
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageBasicHandle.h"
#import "EHMessageAttentionView.h"

@interface EHAttentionViewMessageHandle : EHMessageBasicHandle

// 消息展现的目标source
@property (nonatomic, strong) UIView*                           sourceView;

-(EHMessageAttentionView *)getAttentionView;

-(BOOL)canAttentionViewShowWithMessageAttentionType:(EHMessageAttentionType)messageAttentionType;

-(EHMessageAttentionType)getAttentionViewType;

-(void)removeAttentionView;

-(void)resetAttentionView;

@end
