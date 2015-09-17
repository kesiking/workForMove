//
//  EHHomeBabyHorizontalListView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHomeBabyHorizontalListView.h"
#import "CSLinearLayoutView.h"
#import "EHBabyButton.h"
#import "EHGetBabyListService.h"
#import "EHUserDefaultData.h"

@interface EHHomeBabyHorizontalListView()

@property (nonatomic, strong) EHGetBabyListService *babyListService;

@end

@implementation EHHomeBabyHorizontalListView

-(void)setupView{
    [super setupView];
}

-(void)refreshDataRequest{
    [super refreshDataRequest];
    [self.babyListService loadData];
}

-(void)reloadData{
    [super reloadData];
}

-(void)resetBabyHorizontailListView{
    [self resetBabyDataList];
    [self setupAddBabyBtn];
    [self reloadData];
}

#pragma mark - babyListService  宝贝列表数据获取

-(EHGetBabyListService *)babyListService{
    if (!_babyListService) {
        _babyListService = [EHGetBabyListService new];
        // service 返回成功 block
        WEAKSELF
        _babyListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            strongSelf.isServiceFailed = NO;
            strongSelf.babyListArray = service.dataList;
            [strongSelf setupBabyDataWithDataList:service.dataList];
            [strongSelf hideLoadingView];
        };
        // service 缓存返回成功 block
        _babyListService.serviceCacheDidLoadBlock = ^(WeAppBasicService* service,NSArray* componentItems){
            STRONGSELF
            [strongSelf hideLoadingView];
            if (componentItems) {
                EHLogInfo(@"数据库缓存%@",componentItems);
            }
        };
        // service 返回失败 block
        _babyListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            strongSelf.isServiceFailed = YES;
            [strongSelf setupBabyDataWithDataList:nil];
            [strongSelf hideLoadingView];
//            [WeAppToast toast:service_error_message];
        };
    }
    return _babyListService;
}

-(void)setupBabyDataWithDataList:(NSArray*)dataList{
    [self resetBabyDataList];
    // 没有数据逻辑处理
    if (dataList == nil) {
        if (self.hasBabyDataBlock) {
            self.hasBabyDataBlock(self,NO);
        }
        [self setupAddBabyBtn];
        [self reloadData];
        return;
    }
    // 有数据逻辑处理
    if ([dataList count] == 0) {
        if (self.hasBabyDataBlock) {
            self.hasBabyDataBlock(self,NO);
        }
    }else{
        if (self.hasBabyDataBlock) {
            self.hasBabyDataBlock(self,YES);
        }
    }
    [super setupBabyDataWithDataList:dataList];
    [self setupAddBabyBtn];
    [self reloadData];
    
    if ([self.babyViewListArray count] > 0
        && self.selectIndex >= 0
        && self.selectIndex < [self.babyViewListArray count]) {
        // 回调接口
        EHBabyButton* babyBtn = [self.babyViewListArray objectAtIndex:self.selectIndex];
        if (self.babyListViewClickedBlock) {
            self.babyListViewClickedBlock(self,self.selectIndex, EHBabyNonFoundNum ,(EHGetBabyListRsp*)babyBtn.babyItem);
        }
    }
}

-(void)setupAddBabyBtn{
    EHBabyButton *addBabyBtn = [[EHBabyButton alloc] initWithFrame:CGRectMake(0, 0, babyBtnWidth, _linearContainer.height)];
    [addBabyBtn setBtnImage:[UIImage imageNamed:@"ico_add"]];
    [addBabyBtn setBtnSelectImage:[UIImage imageNamed:@"ico_add"]];
    [addBabyBtn setBtnTitle:@"添加"];
    WEAKSELF
    addBabyBtn.babyButtonClicedBlock = ^(EHBabyButton* addBabyBtn){
        STRONGSELF
        if (strongSelf.addBabyClickedBlock) {
            strongSelf.addBabyClickedBlock(strongSelf);
        }
    };
    [self.babyViewListArray addObject:addBabyBtn];
}

-(void)switchToBabyWithBabyId:(NSNumber*)babyId{
    if (babyId == nil) {
        return;
    }
    NSInteger selectBabyId = self.selectIndex;
    // 寻找需要切换的宝贝
    for (EHBabyButton* babyBtn in self.babyViewListArray) {
        EHGetBabyListRsp* babyItem = (EHGetBabyListRsp*)babyBtn.babyItem;
        if (babyItem == nil || ![babyItem isKindOfClass:[EHGetBabyListRsp class]]) {
            continue;
        }
        if (babyItem.babyId == nil) {
            continue;
        }
        if ([babyItem.babyId integerValue] == [babyId integerValue]) {
            selectBabyId = [self.babyViewListArray indexOfObject:babyBtn];
            break;
        }
    }
    // 如果selectBabyId在self.babyViewListArray范围内，且不是当前选中的宝贝则切换宝贝
    if (selectBabyId != NSNotFound
        && selectBabyId != self.selectIndex
        && selectBabyId >= 0
        && selectBabyId < [self.babyViewListArray count]) {
        EHBabyButton* babyBtn = [self.babyViewListArray objectAtIndex:selectBabyId];
        [babyBtn setBtnClicked];
    }
}

@end
