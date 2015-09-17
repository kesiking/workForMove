//
//  EHMapHistoryTraceListView.m
//  eHome
//
//  Created by 孟希羲 on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTraceListView.h"
#import "EHMapHistoryTraceCellModelInfoItem.h"
#import "EHMapHistoryTracedataSource.h"
#import "EHMapHistoryTraceViewCell.h"
#import "EHLocationService.h"
#import "EHGetBabyListRsp.h"

@interface EHMapHistoryTraceListView()

@property (nonatomic, strong) EHLocationService *            listService;

@property (nonatomic, strong) EHGetBabyListRsp *             currentBabyUserInfo;

@property (nonatomic, strong) UIView           *             tableHeaderView;
@property (nonatomic, strong) UIView           *             tableFooterView;

@property (nonatomic, strong) EHMapHistoryTracedataSource*   dataSourceRead;

@property (nonatomic, strong) EHMapHistoryTracedataSource*   dataSourceWrite;

@end

@implementation EHMapHistoryTraceListView

-(void)setupView{
    [super setupView];
    self.currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    [self addSubview:self.tableViewCtl.scrollView];
    self.tableViewShouldClicked = YES;
    
}

-(void)setupPositionArray:(NSArray*)positionArray{
    self.positionArray = positionArray;
    if (self.positionArray == nil) {
        [self refreshDataRequest];
    }else{
        [self.dataSourceRead setDataWithPageList:self.positionArray extraDataSource:nil];
    }
    [self setupTableViewHeaderView];
    [self setupTableViewFooterView];
}

-(void)refreshDataRequest{
    [self refreshDataRequestWithData:self.selectDate];
}

-(void)refreshDataRequestWithData:(NSDate*)date{
    [self refreshDataRequestWithBabyId:[[EHBabyListDataCenter sharedCenter] currentBabyId] withData:date];
}

-(void)refreshDataRequestWithBabyId:(NSString*)babyId withData:(NSDate*)date{
    if (date == nil) {
        self.selectDate = [NSDate date];
    }else if (self.selectDate != date){
        self.selectDate = date;
    }
    /*
    NSInteger daysAgo = self.selectDate.daysAgo;
    // 同一天或是更晚
    if (daysAgo == 0) {
        self.tableViewShouldClicked = YES;
    }else{
        self.tableViewShouldClicked = NO;
    }
     */
    [self.listService loadLocationTraceHistoryWithBabyId:babyId withData:date];
    [self.tableViewCtl.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)dealloc{
    _tableViewCtl = nil;
    _dataSourceRead = nil;
    _dataSourceWrite = nil;
}

-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        configObject.needNextPage = NO;
        configObject.needFootView = NO;
        configObject.needQueueLoadData = NO;
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        // error text
        NSString* errorText = [NSString stringWithFormat:@"%@当天无数据",[self.currentBabyUserInfo babyNickName]];
        [_tableViewCtl setErrorViewTitle:errorText];
        // init tableView
        [_tableViewCtl registerClass:[EHMapHistoryTraceViewCell class]];
        [_tableViewCtl setService:self.listService];
        [_tableViewCtl setDataSourceRead:self.dataSourceRead];
        [_tableViewCtl setDataSourceWrite:self.dataSourceWrite];
        WEAKSELF
        _tableViewCtl.onRefreshEvent = ^(KSScrollViewServiceController* scrollViewController){
            STRONGSELF
            [strongSelf refreshDataRequest];
        };
        
        /*
         * 历史轨迹不能点击
        _tableViewCtl.viewCellConfigBlock = ^(KSViewCell* viewCell, WeAppComponentBaseItem *componentItem, KSCellModelInfoItem* modelInfoItem, NSIndexPath* indexPath,KSDataSource* dataSource){
            STRONGSELF
            if (![viewCell isKindOfClass:[EHMapHistoryTraceViewCell class]]
                || ![componentItem isKindOfClass:[EHUserDevicePosition class]]) {
                return;
            }
            EHMapHistoryTraceViewCell* historyTraceViewCell = (EHMapHistoryTraceViewCell*)viewCell;
            historyTraceViewCell.positionArrorImageViewShouldShow = strongSelf.tableViewShouldClicked;
            historyTraceViewCell.positionArrowImageView.hidden = !historyTraceViewCell.positionArrorImageViewShouldShow;
        };
         */
        
        _tableViewCtl.tableViewDidSelectedBlock = ^(UITableView* tableView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject* configObject){
            STRONGSELF
            if (!strongSelf.tableViewShouldClicked) {
                return;
            }
            NSArray* dataList = [dataSource getDataList];
            if (dataList && [dataList count] > 0) {
                dataList = [[dataList reverseObjectEnumerator] allObjects];
            }
            NSUInteger totleCount = [dataList count];
            NSUInteger index = totleCount - [indexPath row] - 1;
            if (strongSelf.historyTraceListDidSelectedBlock) {
                strongSelf.historyTraceListDidSelectedBlock(dataList, index);
            }
        };
    }
    return _tableViewCtl;
}

-(UIView *)tableHeaderView{
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewCtl.frame.size.width, 40)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel* tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 / 2, _tableHeaderView.width - 20 * 2, 40 - 20)];
        [tableHeaderLabel setTextColor:EH_cor5];
        [tableHeaderLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [tableHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [tableHeaderLabel setNumberOfLines:2];
        [tableHeaderLabel setTextAlignment:NSTextAlignmentCenter];
        [tableHeaderLabel setText:[NSString stringWithFormat:@"%@的当天足迹",[self.currentBabyUserInfo babyNickName]]];
        [tableHeaderLabel sizeToFit];
        [tableHeaderLabel setFrame:CGRectMake(0, (_tableHeaderView.height - tableHeaderLabel.height)/2, _tableHeaderView.width, tableHeaderLabel.height)];
        [_tableHeaderView addSubview:tableHeaderLabel];
    }
    return _tableHeaderView;
}

-(UIView *)tableFooterView{
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewCtl.frame.size.width, 76)];
        _tableFooterView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:_tableFooterView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UINAVIGATIONBAR_COMMON_COLOR;
        label.tag = 1101;
        label.backgroundColor = [UIColor clearColor];
        [label setText:@"已无轨迹信息可同步"];
        [_tableFooterView addSubview:label];
    }
    return _tableFooterView;
}

-(void)setupTableViewHeaderView{
    if (self.positionArray && [self.positionArray count] > 0) {
        [self.tableViewCtl setTableHeaderView:self.tableHeaderView];
    }else{
        [self.tableViewCtl setTableHeaderView:nil];
    }
}

-(void)setupTableViewFooterView{
    if (self.positionArray && [self.positionArray count] > 0) {
        [self.tableViewCtl setTableFooterView:self.tableFooterView];
    }else{
        [self.tableViewCtl setTableFooterView:nil];
    }
}

-(EHLocationService *)listService{
    if (_listService == nil) {
        _listService = [EHLocationService new];
        WEAKSELF
        _listService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _listService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            strongSelf.positionArray = service.dataList;
            [strongSelf setupTableViewHeaderView];
            [strongSelf setupTableViewFooterView];
        };
        _listService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [strongSelf setupTableViewHeaderView];
            [strongSelf setupTableViewFooterView];
        };
    }
    return _listService;
}

-(EHMapHistoryTracedataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[EHMapHistoryTracedataSource alloc] init];
        _dataSourceRead.modelInfoItemClass = [EHMapHistoryTraceCellModelInfoItem class];
    }
    return _dataSourceRead;
}

-(EHMapHistoryTracedataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[EHMapHistoryTracedataSource alloc] init];
        _dataSourceWrite.modelInfoItemClass = [EHMapHistoryTraceCellModelInfoItem class];
    }
    return _dataSourceWrite;
}

@end
