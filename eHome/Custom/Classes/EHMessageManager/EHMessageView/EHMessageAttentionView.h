//
//  EHMessageAttentionView.h
//  eHome
//
//  Created by 孟希羲 on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

typedef void (^doAttentionViewClickedBlock)        (void);

typedef void (^doAttentionCloseClickedBlock)       (void);

typedef NS_ENUM(NSInteger, EHMessageAttentionType) {
    EHMessageAttentionType_None                 = 0,
    EHMessageAttentionType_DeviceBinding        = 1,
    EHMessageAttentionType_DeviceLowBattery     = 2,
    EHMessageAttentionType_DeviceOutLine        = 3,
    EHMessageAttentionType_DeviceHasNoNetWork   = 4,
};

@interface EHMessageAttentionView : KSView

@property (nonatomic, copy) doAttentionViewClickedBlock  attentionViewClickedBlock;

@property (nonatomic, copy) doAttentionCloseClickedBlock attentionCloseClickedBlock;

@property (nonatomic, assign) EHMessageAttentionType     messageAttentionType;

-(void)setMessageInfo:(NSString*)message;

-(void)setMessageIconShow:(BOOL)show;

-(BOOL)canAttentionViewShow;

@end
