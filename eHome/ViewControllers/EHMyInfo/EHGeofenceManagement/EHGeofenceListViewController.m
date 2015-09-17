//
//  EHGeofenceListViewController.m
//  eHome
//
//  Created by xtq on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceListViewController.h"
#import "EHAddGeofenceViewController.h"
#import "EHGetGeofenceListService.h"
#import "EHGeofenceListTableViewCell.h"
#import "EHGeofenceDetailViewController.h"
#import "EHUpdateGeofenceStatusService.h"
#import "EHBabyListDataCenter.h"
#import "NSString+StringSize.h"

#define kCellHeight     70

@interface EHGeofenceListViewController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UIView *noDataView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSIndexPath *switchChangedIndexPath;

@end

@implementation EHGeofenceListViewController
{
    EHGetGeofenceListService *_listService;
    EHUpdateGeofenceStatusService *_statusService;
    UITableView *_tableView;
    NSUInteger _beginListCount;
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"安全围栏";
    self.view.backgroundColor = EH_bgcor1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.tableView];
    self.switchChangedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self configGetGeofenceListService];
    [self configUpdateGeofenceStatusService];
    
    [self initMapView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_listService getGeofenceListWithBabyID:[self.babyUser.babyId intValue] UserID:[[KSLoginComponentItem sharedInstance].userId intValue]];
    [self showLoadingView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_beginListCount != self.geofenceList.count) {
        !self.geofenceListCountDidChanged?:self.geofenceListCountDidChanged(self.geofenceList);
    }
}

#pragma mark - Common Methods
- (void)checkDataArray{
    if (self.geofenceList.count == 0) {
        [self.view addSubview:self.noDataView];
    }
    else {
        [self.noDataView removeFromSuperview];
    }
}

#pragma mark - Events Response
- (void)rightItemClick:(id)sender{
    NSLog(@"rightItemClick");
    if (self.geofenceList.count == 10) {
        [WeAppToast toast:@"您的围栏数量已经到10个，无法继续新增围栏"];
        return;
    }
    if ([KSAuthenticationCenter isLogin]) {
        NSMutableArray *existedNameArray = [[NSMutableArray alloc]init];
        for (EHGetGeofenceListRsp *rsp in self.geofenceList) {
            [existedNameArray addObject:rsp.geofence_name];
        }
        
        EHUserDevicePosition *position = [[EHBabyListDataCenter sharedCenter] currentBabyPosition];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([position.location_latitude floatValue],[position.location_longitude floatValue]);
        EHLogInfo(@"location_latitude = %f,location_longitude = %f",coordinate.latitude,coordinate.longitude);
        
        EHAddGeofenceViewController *agvc = [[EHAddGeofenceViewController alloc]init];
        agvc.babyUser = self.babyUser;
        agvc.existedNameArray = existedNameArray;
        agvc.geofenceCoordinate = coordinate;
        agvc.mapView = self.mapView;
        
        EHLogInfo(@"self.babyUser.babyId = %@",self.babyUser.babyId);
        
        [self.navigationController pushViewController:agvc animated:YES];
        return;
    }
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        // 如果登陆成功就进入创建围栏
        [self.navigationController popViewControllerAnimated:YES];
    };
    [[KSAuthenticationCenter sharedCenter] authenticateWithAlertViewMessage:LOGIN_ALERTVIEW_MESSAGE LoginActionBlock:loginActionBlock cancelActionBlock:nil source:self];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.geofenceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    EHGeofenceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EHGeofenceListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    EHGetGeofenceListRsp *rsp = (EHGetGeofenceListRsp *)self.geofenceList[indexPath.row];
    [cell configWithGeofence:rsp];
    cell.backgroundColor = [UIColor clearColor];
    
    NSNumber *geofence_id = [NSNumber numberWithInt:rsp.geofence_id];
    cell.switchStatusChangeBlock = ^(BOOL isOn){
        NSDictionary *dic = @{@"geofence_id":geofence_id,
                              @"status_switch":[NSNumber numberWithInteger:isOn]};
        NSArray *array = @[dic];
        [_statusService updateGeofenceStatus:array];
        [self.statusHandler showLoadingViewInView:self.view];
        self.switchChangedIndexPath = indexPath;
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([KSAuthenticationCenter isLogin]) {
        NSMutableArray *existedNameArray = [[NSMutableArray alloc]init];
        for (EHGetGeofenceListRsp *rsp in self.geofenceList) {
            [existedNameArray addObject:rsp.geofence_name];
        }
        EHGeofenceDetailViewController *gdvc = [[EHGeofenceDetailViewController alloc]init];
        gdvc.babyUser = self.babyUser;
        gdvc.geofenceInfo = self.geofenceList[indexPath.row];
        gdvc.existedNameArray = existedNameArray;
        gdvc.geofenceCoordinate = CLLocationCoordinate2DMake(gdvc.geofenceInfo.latitude, gdvc.geofenceInfo.longitude);
        gdvc.radius = gdvc.geofenceInfo.geofence_radius;
        gdvc.mapView = self.mapView;
        [self.navigationController pushViewController:gdvc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        // 如果登陆成功就进入创建围栏
        [self.navigationController popViewControllerAnimated:YES];
    };
    [[KSAuthenticationCenter sharedCenter] authenticateWithAlertViewMessage:LOGIN_ALERTVIEW_MESSAGE LoginActionBlock:loginActionBlock cancelActionBlock:nil source:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

#pragma mark - Common Methods
- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = kMAMapAPIKey;   //设置KEY
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = NO;                       //YES 为打开定位，NO为关闭定位
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    //    [_mapView setCenterCoordinate:coordinate];              //地图设置中心点
    //    [_mapView setZoomLevel:10 animated:YES];                //地图设置缩放级别，3~20
    [self.mapView setUserTrackingMode: MAUserTrackingModeNone]; //地图不跟着位置移动
}

#pragma mark - Getters And Setters
- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.view.bounds];
        _noDataView.backgroundColor = [UIColor clearColor];
        
        NSString *strFirst = @"您还没有设置电子围栏，";
        NSString *strSecond = @"点击“      ”轻松创建！";
        CGFloat fontSize = EH_siz3;
        UIColor *textColor = EH_cor5;
        CGFloat width = CGRectGetWidth(self.view.frame);
        
        CGFloat labelFirstWidth = [strFirst sizeWithFontSize:fontSize Width:width].width;
        CGFloat labelFirstHeight = [strFirst sizeWithFontSize:fontSize Width:width].height;
        CGFloat labelSecondWidth = [strSecond sizeWithFontSize:fontSize Width:width].width;
        CGFloat labelSecondHeight = [strSecond sizeWithFontSize:fontSize Width:width].height;
        
        UILabel *labelFirst = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelFirstWidth, labelFirstHeight)];
        labelFirst.center = CGPointMake(CGRectGetMidX(self.view.frame), 170 / 2.0 + labelFirstHeight / 2.0);
        labelFirst.text = strFirst;
        labelFirst.font = [UIFont systemFontOfSize:fontSize];
        labelFirst.textColor = textColor;
        labelFirst.textAlignment = NSTextAlignmentCenter;
        
        UILabel *labelSecond = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelSecondWidth, labelSecondHeight)];
        labelSecond.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(labelFirst.frame) + 34 / 2.0 +labelSecondHeight / 2.0);
        labelSecond.text = strSecond;
        labelSecond.font = [UIFont systemFontOfSize:fontSize];
        labelSecond.textColor = textColor;
        labelSecond.textAlignment = NSTextAlignmentCenter;
        
        NSString *subString = [strSecond substringToIndex:4];
        CGFloat subStringWidth = [subString sizeWithFontSize:fontSize Width:width].width;
        
        UIImageView *addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_add_green"]];
        addImageView.frame = CGRectMake(subStringWidth, 0, labelSecondHeight, labelSecondHeight);
        [labelSecond addSubview:addImageView];
        
        UIImage *arrowImage =[UIImage imageNamed:@"ico_arrows"];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:arrowImage];
        arrowImageView.center = CGPointMake(CGRectGetWidth(_noDataView.frame) - 30 - arrowImage.size.width / 2.0, 10 + arrowImage.size.height / 2.0);
        
        [_noDataView addSubview:labelFirst];
        [_noDataView addSubview:labelSecond];
        [_noDataView addSubview:arrowImageView];
    }
    
    return _noDataView;
}

static bool firstTag = YES;
- (void)configGetGeofenceListService{
    if (!_listService) {
        _listService = [EHGetGeofenceListService new];
        typeof(_tableView) __weak weakTableView = _tableView;
        WEAKSELF
        _listService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            strongSelf.geofenceList = service.dataList;
            for (EHGetGeofenceListRsp *rsp in service.dataList) {
                EHLogInfo(@"rsp = %@",rsp);
            }
            
            if (firstTag) {
                _beginListCount = strongSelf.geofenceList.count;
                firstTag = NO;
            }
            
            [strongSelf checkDataArray];
            [weakTableView reloadData];
        };
        _listService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [weakSelf hideLoadingView];
            [WeAppToast toast:@"获取围栏列表失败"];
        };
    }
}

- (void)configUpdateGeofenceStatusService{
    if (!_statusService) {
        _statusService = [EHUpdateGeofenceStatusService new];
        typeof(self) __weak weakSelf = self;

        _statusService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            [[NSNotificationCenter defaultCenter] postNotificationName:EHGeofenceChangeNotification object:nil];
            [weakSelf.statusHandler hideLoadingView];
        };
        _statusService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            EHGeofenceListTableViewCell *cell = (EHGeofenceListTableViewCell *)[strongSelf.tableView cellForRowAtIndexPath:strongSelf.switchChangedIndexPath];
            cell.swit.on = !cell.swit.on;
            [strongSelf.statusHandler hideLoadingView];
            [WeAppToast toast:@"更新开关失败"];
        };
    }
}

@end
