//
//  EHMessageBabyHorizontalListView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyHorizontalBasicListView.h"

@class EHMessageBabyHorizontalListView;

typedef void (^doSelectAllMessageClickedBlock)       (EHMessageBabyHorizontalListView* babyListView);

@interface EHMessageBabyHorizontalListView : EHBabyHorizontalBasicListView

// 添加baby操作
@property (nonatomic, copy)   doSelectAllMessageClickedBlock     selectAllMessageClickedBlock;

@end
