//
//  EHGeofenceRemindListViewController.m
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceRemindListViewController.h"
#import "EHGetGeofenceRemindService.h"
#import "EHUpdateGeofenceRemindService.h"
#import "EHRemindListTableViewCell.h"
#import "EHGeofenceRemindModel.h"
#import "EHRemindViewModel.h"
#import "NSString+StringSize.h"

static NSString * const kEHGeofenceRemindStr = @"开启主动提醒状态，如果在规定时间内，包别不在围栏范围内，则会向您发送提醒通知。";

@interface EHGeofenceRemindListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *activeChangedIndexPath;

@property (nonatomic, strong) NSMutableArray      *geofenceRemindList;

@end

@implementation EHGeofenceRemindListViewController
{
    EHGetGeofenceRemindService *_getRemindService;
    EHUpdateGeofenceRemindService *_updateRemindService;
    
    UIImageView *_babyHeadImageView;
    UILabel     *_babyNameLabel;
    UILabel     *_geofenceNameLabel;
    
    UILabel     *_remindLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主动提醒";
    self.view.backgroundColor = EH_bgcor1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.activeChangedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self remindLabel]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
    [self configGetRemindService];
    [_getRemindService getGeofenceRemindWithGeofenceID:self.geofence_id];
    [self showLoadingView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)rightItemClick:(id)sender {
    if (self.geofenceRemindList.count == 5) {
        [WeAppToast toast:@"您的围栏提醒数量已经到5个，无法继续新增围栏提醒"];
        return;
    }
    EHGeofenceRemindAddViewController *grdVC = [[EHGeofenceRemindAddViewController alloc]init];
    grdVC.remindModel.geofence_id = self.geofence_id;
    [self.navigationController pushViewController:grdVC animated:YES];
}

- (void)reloadData{
    [self.tableView reloadData];
    if (self.geofenceRemindList.count == 0) {
        self.tableView.hidden = YES;
        CGRect frame = _remindLabel.frame;
        frame.origin.y = 20;
        _remindLabel.frame = frame;
    }
    else {
        self.tableView.hidden = NO;
        CGRect frame = _remindLabel.frame;
        frame.origin.y = CGRectGetHeight(self.tableView.frame) + 20;
        _remindLabel.frame = frame;
    }
}

- (NSMutableArray *)remindListSorted:(NSArray *)remindList {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *onArray = [[NSMutableArray alloc]init];
    NSMutableArray *offArray = [[NSMutableArray alloc]init];
    for (EHGeofenceRemindModel *model in remindList) {
        if ([model.is_active boolValue]) {
            [onArray addObject:model];
        }
        else {
            [offArray addObject:model];
        }
    }
    if (onArray.count > 1) {
        onArray = [self remindListSortedByTime:onArray];
    }
    if (offArray.count > 1) {
        offArray = [self remindListSortedByTime:offArray];
    }
    
    if (onArray.count != 0) {
        for (EHGeofenceRemindModel *model in onArray) {
            [resultArray addObject:model];
        }
    }
    if (offArray.count != 0) {
        for (EHGeofenceRemindModel *model in offArray) {
            [resultArray addObject:model];
        }
    }
    return resultArray;
}

- (NSMutableArray *)remindListSortedByTime:(NSMutableArray *)array {
    for (NSInteger i = 0; i < (array.count - 1); i++) {
        for (NSInteger j = 0; j < (array.count - 1) - i; j++) {
            EHGeofenceRemindModel *currentModel = array[j];
            EHGeofenceRemindModel *nextModel = array[j + 1];
            //比较时的大小
            if([[currentModel.time substringToIndex:2] integerValue] > [[nextModel.time substringToIndex:2] integerValue]){
                [array exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
            }
            //如果时一样，比较分的大小
            else if ([[currentModel.time substringToIndex:2] integerValue] == [[nextModel.time substringToIndex:2] integerValue]) {
                if ([[currentModel.time substringFromIndex:3] integerValue] > [[nextModel.time substringFromIndex:3] integerValue]) {
                    [array exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
    }
    return array;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.geofenceRemindList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    EHRemindListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EHRemindListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    EHGeofenceRemindModel *model = self.geofenceRemindList[indexPath.row];
    EHRemindViewModel *viewModel = [[EHRemindViewModel alloc]initWithGeofenceRemindModel:model];
    [cell configWithRemindModel:viewModel RemindType:EHRemindTypeGeofence];

    WEAKSELF
    cell.activeStatusChangeBlock = ^(BOOL isOn){
        STRONGSELF
        model.is_active = @((NSInteger)isOn);

        //进行状态更新请求再排序显示
        strongSelf.activeChangedIndexPath = indexPath;
        [strongSelf showLoadingView];
        
        [self configUpdateRemindService];
        [_updateRemindService UpdateGeofenceRemind:model];
        EHLogInfo(@"isOn = %d",isOn);
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerViewForTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //提醒编辑
    EHGeofenceRemindEditViewController *greVC =[[EHGeofenceRemindEditViewController alloc] init];
    greVC.remindModel = self.geofenceRemindList[indexPath.row];
    greVC.remindModel.geofence_id = self.geofence_id;
    [self.navigationController pushViewController:greVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Getters And Setters
- (NSMutableArray *)geofenceRemindList {
    if (!_geofenceRemindList) {
        _geofenceRemindList = [[NSMutableArray alloc]init];
    }
    return _geofenceRemindList;
}

- (void)configGetRemindService{
    if (!_getRemindService) {
        _getRemindService = [EHGetGeofenceRemindService new];
        
        WEAKSELF
        _getRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            //请求完后
            EHLogInfo(@"success - count = %ld",service.dataList.count);
            strongSelf.geofenceRemindList = [strongSelf remindListSorted:service.dataList];
            [strongSelf reloadData];
            [strongSelf hideLoadingView];
        };
        
        _getRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            
            EHLogInfo(@"error = %@",error);
            [weakSelf hideLoadingView];
        };
    }
}

- (void)configUpdateRemindService {
    if (!_updateRemindService) {
        _updateRemindService = [EHUpdateGeofenceRemindService new];
        WEAKSELF
        _updateRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            
            strongSelf.geofenceRemindList = [strongSelf remindListSorted:strongSelf.geofenceRemindList];
            [strongSelf reloadData];
        };
        _updateRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            EHRemindListTableViewCell *cell = (EHRemindListTableViewCell *)[strongSelf.tableView cellForRowAtIndexPath:strongSelf.activeChangedIndexPath];
            cell.isActiveButton.selected = !cell.isActiveButton.selected;
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
        };
    }
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        CGRect frame = CGRectMake(kSpaceX, 20, CGRectGetWidth(self.view.frame) - kSpaceX * 2,60);
        _remindLabel = [[UILabel alloc]initWithFrame:frame];
        _remindLabel.text = kEHGeofenceRemindStr;
        _remindLabel.font = EH_font3;
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.numberOfLines = 0;
        _remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGSize size = [kEHGeofenceRemindStr sizeWithFontSize:EH_siz3 Width:CGRectGetWidth(_remindLabel.frame)];
        frame.size.height = size.height;
        _remindLabel.frame = frame;
    }
    return _remindLabel;
}

- (UIView *)headerViewForTableView {
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:0];
    CGFloat imageWidth = 40;
    CGFloat nameHeight = [@"name" sizeWithFontSize:EH_siz3 Width:160].height;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), height)];
    
    _babyHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSpaceX, (height - imageWidth) / 2.0, imageWidth, imageWidth)];
    _babyHeadImageView.layer.masksToBounds = YES;
    _babyHeadImageView.layer.cornerRadius = imageWidth / 2.0;
    UIImage *defaultHeadImage = [UIImage imageNamed:@"headportrait_boy_160"];
    NSURL *imageUrl = [NSURL URLWithString:self.babyUser.babyHeadImage];
    [_babyHeadImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUser.babyId newPlaceHolderImagePath:self.babyUser.babyHeadImage defaultHeadImage:defaultHeadImage]];
    
    
    _babyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_babyHeadImageView.frame) + 5, (height - nameHeight) / 2.0, 160, nameHeight)];
    _babyNameLabel.font = EH_font3;
    _babyNameLabel.textAlignment = NSTextAlignmentLeft;
    NSString *nameStr;
    if ([EHUtils isAuthority:self.babyUser.authority]) {
        nameStr = self.babyUser.babyName;
    }
    else
    {
        nameStr = self.babyUser.babyNickName ? self.babyUser.babyNickName : self.babyUser.babyName;
    }
    _babyNameLabel.text = nameStr;
    
    
    UIImageView *geofenceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_babyNameLabel.frame) + kSpaceX, (height - imageWidth) / 2.0, imageWidth, imageWidth)];
    geofenceImageView.image = [UIImage imageNamed:@"ico_crawl_normal"];
    
    _geofenceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(geofenceImageView.frame) + 5, (height - nameHeight) / 2.0, 100, nameHeight)];
    _geofenceNameLabel.font = EH_font3;
    _geofenceNameLabel.textAlignment = NSTextAlignmentLeft;
    _geofenceNameLabel.text = self.geofenceName;
    
    [headView addSubview:_babyHeadImageView];
    [headView addSubview:_babyNameLabel];
    [headView addSubview:geofenceImageView];
    [headView addSubview:_geofenceNameLabel];
    
    return headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
