//
//  EHBabyHorizontalBasicListView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSCancelButtonView.h"
#import "EHGetBabyListRsp.h"

#define babyBtnWidth (IPHON5_SCREEN_BASE / 3)

@class EHBabyHorizontalBasicListView;

typedef void (^doBabyListViewClickedBlock)  (EHBabyHorizontalBasicListView* babyListView, NSInteger index, NSInteger preIndex, EHGetBabyListRsp* babyUserInfo);

@interface EHBabyHorizontalBasicListView : KSCancelButtonView{
    NSMutableArray              *_babyViewListArray;
    CSLinearLayoutView          *_linearContainer;

}

@property (nonatomic, strong) NSMutableArray *            babyViewListArray;

@property (nonatomic, assign) CSLinearLayoutItemPadding   padding;

@property (nonatomic, assign) NSInteger                   selectIndex;

// 某个baby被选中时触发，告知宝贝信息
@property (nonatomic, copy)   doBabyListViewClickedBlock  babyListViewClickedBlock;

-(void)setupBabyDataWithDataList:(NSArray*)dataList;

-(void)resetBabyDataList;

-(void)reloadData;

@end
