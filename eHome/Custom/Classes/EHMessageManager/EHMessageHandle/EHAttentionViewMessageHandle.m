//
//  EHAttentionViewMessageHandle.m
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAttentionViewMessageHandle.h"

#define kAttentionViewTag (10005)

@implementation EHAttentionViewMessageHandle

-(BOOL)messageShouldHandle:(EHMessageModel*)messageModel{
    if (messageModel.sourceTarget == nil) {
        return NO;
    }
    if ([messageModel.sourceTarget isKindOfClass:[UIViewController class]]) {
        self.sourceView = ((UIViewController*)messageModel.sourceTarget).view;
        return YES;
    }
    if ([messageModel.sourceTarget isKindOfClass:[UIView class]]) {
        self.sourceView = ((UIView*)messageModel.sourceTarget);
        return YES;
    }
    self.sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    return [super messageShouldHandle:messageModel];;
}

-(EHMessageAttentionView *)getAttentionView{
    if (self.sourceView == nil) {
        EHLogError(@"-----> error because sourceView is nil");
        return nil;
    }
    EHMessageAttentionView *attentionView = (EHMessageAttentionView*)[self.sourceView viewWithTag:kAttentionViewTag];
    if (!attentionView) {
        CGFloat width = self.sourceView.width > 0 ? self.sourceView.width : SCREEN_WIDTH;
        attentionView = [[EHMessageAttentionView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        attentionView.tag = kAttentionViewTag;
        [self.sourceView addSubview:attentionView];
    }
    return attentionView;
}

-(BOOL)canAttentionViewShowWithMessageAttentionType:(EHMessageAttentionType)messageAttentionType{
    EHMessageAttentionView* attentionView = [self getAttentionView];
    attentionView.messageAttentionType = messageAttentionType;
    return [attentionView canAttentionViewShow];
}

-(EHMessageAttentionType)getAttentionViewType{
    EHMessageAttentionView* attentionView = [self getAttentionView];
    return attentionView.messageAttentionType;
}

-(void)resetAttentionView{
    EHMessageAttentionView* attentionView = [self getAttentionView];
    attentionView.hidden = NO;
    attentionView.alpha = 1;
    attentionView.attentionCloseClickedBlock = nil;
    attentionView.attentionViewClickedBlock = nil;
}

-(void)removeAttentionView{
    EHMessageAttentionView* attentionView = [self getAttentionView];
    attentionView.hidden = YES;
}

@end
