//
//  EHMessageBabyHorizontalListView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageBabyHorizontalListView.h"
#import "EHBabyButton.h"

@implementation EHMessageBabyHorizontalListView

-(void)setupView{
    [super setupView];
    [self refreshDataRequest];
}

-(void)refreshDataRequest{
    [super refreshDataRequest];
}

-(void)reloadData{
    [super reloadData];
}

-(void)setupBabyDataWithDataList:(NSArray*)dataList{
    [self resetBabyDataList];
    [self setupAllMessageBtn];
    // 没有数据逻辑处理
    if (dataList == nil) {
        [self reloadData];
        return;
    }
    [super setupBabyDataWithDataList:dataList];
    [self reloadData];
}

-(void)setupAllMessageBtn{
    EHBabyButton *allMessageBtn = [[EHBabyButton alloc] initWithFrame:CGRectMake(0, 0, 50, self.height)];
    [allMessageBtn setBtnImage:[UIImage imageNamed:@"public_ico_map_dorpdown_messages"]];
    WEAKSELF
    allMessageBtn.babyButtonClicedBlock = ^(EHBabyButton* allMessageBtn){
        STRONGSELF
        if (strongSelf.selectAllMessageClickedBlock) {
            strongSelf.selectAllMessageClickedBlock(strongSelf);
        }
    };
    [self.babyViewListArray addObject:allMessageBtn];
}

@end
