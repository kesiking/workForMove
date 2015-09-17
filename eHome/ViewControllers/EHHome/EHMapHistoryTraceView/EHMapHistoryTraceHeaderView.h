//
//  EHMapHistoryTraceHeaderView.h
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

@class EHMapHistoryTraceHeaderView;

typedef void(^EHMapHistoryTraceHeaderBtnClickedBlock) (EHMapHistoryTraceHeaderView* headerView);

@interface EHMapHistoryTraceHeaderView : KSView

@property (nonatomic,strong) UIButton    * historyTraceHeaderBtn;
@property (nonatomic,strong) UIImageView * historyTraceHeaderBGImageView;
@property (nonatomic,strong) UIImageView * historyTraceHeaderImageView;
@property (nonatomic,strong) UILabel     * historyTraceNameLabel;

@property (nonatomic,copy) EHMapHistoryTraceHeaderBtnClickedBlock historyTraceHeaderBtnClickedBlock;


@end
