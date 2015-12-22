//
//  EHHomeOperationLayerView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHGetBabyListRsp.h"

typedef void(^EHHistoryTraceListBtnClickedBlock) (UIButton* historyListBtn);

@interface EHHomeOperationLayerView : KSView

@property (nonatomic, strong) UIButton              *historyListBtn;

@property (nonatomic, strong) UIButton              *fencingBtn;

//@property (nonatomic, strong) UIButton              *phoneBtn;
//
//@property (nonatomic, strong) UIButton              *chatBtn;

@property (nonatomic, strong) EHGetBabyListRsp      *babyUserInfo;

@property (nonatomic, copy)   EHHistoryTraceListBtnClickedBlock      historyTraceListBtnClickedBlock;

@end
