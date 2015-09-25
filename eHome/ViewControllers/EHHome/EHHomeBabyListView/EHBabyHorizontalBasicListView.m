//
//  EHBabyHorizontalBasicListView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyHorizontalBasicListView.h"
#import "CSLinearLayoutView.h"
#import "EHBabyButton.h"
#import "EHGetBabyListService.h"
#import "EHUserDefaultData.h"

#define babyHorizontalListViewHeight (120)

@interface EHBabyHorizontalBasicListView()

@property (nonatomic, strong) CSLinearLayoutView   *linearContainer;
@property (nonatomic, strong) EHGetBabyListService *babyListService;
@property (nonatomic, strong) UIImageView          *bgImageView;

@end

@implementation EHBabyHorizontalBasicListView

-(void)setupView{
    [super setupView];
    _babyViewListArray = [NSMutableArray array];
    self.padding = CSLinearLayoutMakePadding(0.0, 0.0, 0, 0);
    self.selectIndex = 0;
    [self addSubview:self.bgImageView];
    [self addSubview:self.linearContainer];
    self.backgroundColor = [UIColor clearColor];
}

-(void)reloadData{
    [self.linearContainer removeAllItems];
    for (UIView* subView in self.babyViewListArray) {
        if (![subView isKindOfClass:[UIView class]]) {
            continue;
        }
        CSLinearLayoutItem *subViewLayoutItem = [[CSLinearLayoutItem alloc]
                                                 initWithView:subView];
        subViewLayoutItem.padding             = self.padding;
        [self.linearContainer addItem:subViewLayoutItem];
    }
}

#pragma mark - container

- (CSLinearLayoutView *)linearContainer {
    if (!_linearContainer) {
        float containerHeight = babyHorizontalListViewHeight;
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, containerHeight);
        _linearContainer = [[CSLinearLayoutView alloc] initWithFrame:frame];
        _linearContainer.orientation = CSLinearLayoutViewOrientationHorizontal;
        _linearContainer.backgroundColor  =  [UIColor clearColor];
    }
    return _linearContainer;
}

-(UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.linearContainer.bounds];
        [_bgImageView setImage:[UIImage imageNamed:@"bg_add"]];
    }
    return _bgImageView;
}

-(void)resetBabyDataList{
    [self.babyViewListArray removeAllObjects];
}

-(void)setupBabyDataWithDataList:(NSArray*)dataList{
    
    NSInteger preSelectBabyId = [EHUserDefaultData getCurrentSelectBabyId];
    
    BOOL didBabyListHasPreSelectBabyId = NO;
    for (EHGetBabyListRsp *babyUser in dataList) {
        if (![babyUser isKindOfClass:[EHGetBabyListRsp class]]) {
            continue;
        }
        // 设置存储的选中的宝贝，如果没有则选为默认
        if ([babyUser.babyId integerValue] == preSelectBabyId) {
            didBabyListHasPreSelectBabyId = YES;
            self.selectIndex = [dataList indexOfObject:babyUser];
        }
        
        EHBabyButton *babyBtn = [[EHBabyButton alloc] initWithFrame:CGRectMake(0, 0, babyBtnWidth, self.linearContainer.height)];
        babyBtn.babyItem = babyUser;
        [babyBtn setBtnImageUrl:babyUser.babyHeadImage withSex:[babyUser.babySex integerValue]];
        [babyBtn setBtnTitle:babyUser.babyNickName];
        WEAKSELF
        babyBtn.babyButtonClicedBlock = ^(EHBabyButton* babyBtn){
            STRONGSELF
            NSUInteger index = [strongSelf.babyViewListArray indexOfObject:babyBtn];
            if (index == NSNotFound) {
                return;
            }
            NSUInteger preIndex = strongSelf.selectIndex;
            strongSelf.selectIndex = index;
            // 存储当前选中宝贝
            [EHUserDefaultData setCurrentSelectBabyId:[((EHGetBabyListRsp*)babyBtn.babyItem).babyId integerValue]];
            // 回调
            if (strongSelf.babyListViewClickedBlock) {
                strongSelf.babyListViewClickedBlock(strongSelf,strongSelf.selectIndex, preIndex, (EHGetBabyListRsp*)babyBtn.babyItem);
            }
        };
        [self.babyViewListArray addObject:babyBtn];
    }
    if (!didBabyListHasPreSelectBabyId) {
        if (self.selectIndex >= [dataList count]) {
            self.selectIndex -= 1;
        }
        if (self.selectIndex < 0 || self.selectIndex >= [dataList count]) {
            self.selectIndex = 0;
        }
        EHBabyButton* babyBtn = [self.babyViewListArray objectAtIndex:self.selectIndex];
        [EHUserDefaultData setCurrentSelectBabyId:[((EHGetBabyListRsp*)babyBtn.babyItem).babyId integerValue]];
    }
}

@end
