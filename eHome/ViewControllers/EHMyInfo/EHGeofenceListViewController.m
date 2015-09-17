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
#import "UIViewController+BackButtonHandler.h"

#define kCellHeight     70

@interface EHGeofenceListViewController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UIView *noDataView;



@end

@implementation EHGeofenceListViewController
{
    EHGetGeofenceListService *_listService;
    EHUpdateGeofenceStatusService *_statusService;
    UITableView *_tableView;
    NSMutableDictionary *_switchStatusDic;
    NSUInteger _beginListCount;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"安全围栏";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _switchStatusDic = [[NSMutableDictionary alloc]init];
    [self.view addSubview:[self tableView]];
    
    [self configInsertGeofenceService];
    [self initMapView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_listService getGeofenceListWithBabyID:[self.babyUser.babyId intValue] UserID:[[KSLoginComponentItem sharedInstance].userId intValue]];
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
}

#pragma mark - BackButtonHandlerProtocol
-(BOOL) navigationShouldPopOnBackButton
{
    NSLog(@"navigationShouldPopOnBackButton");
    NSMutableArray *statusArray = [[NSMutableArray alloc]init];
    if ([_switchStatusDic allKeys].count != 0) {
        for (int i = 0; i < (int)([_switchStatusDic allKeys].count); i++) {
            NSDictionary *dic = @{@"geofence_id":[[_switchStatusDic allKeys] objectAtIndex:i],
                                  @"status_switch":[[_switchStatusDic allValues] objectAtIndex:i]};
            [statusArray addObject:dic];
        }
        [self configUpdateGeofenceStatusService];
        [_statusService updateGeofenceStatus:statusArray];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
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
    
    NSNumber *geofence_id = [NSNumber numberWithInt:rsp.geofence_id];
    NSNumber *status_switch = [NSNumber numberWithInt:!rsp.status_switch];
    cell.switchStatusChangeBlock = ^(BOOL isOn){
        NSLog(@"isOn = %d",isOn);
        if ([_switchStatusDic.allKeys containsObject:geofence_id]) {
            [_switchStatusDic removeObjectForKey:geofence_id];
        }
        else {
            [_switchStatusDic setObject:status_switch forKey:geofence_id];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *existedNameArray = [[NSMutableArray alloc]init];
    for (EHGetGeofenceListRsp *rsp in self.geofenceList) {
        [existedNameArray addObject:rsp.geofence_name];
    }
    EHGeofenceDetailViewController *gdvc = [[EHGeofenceDetailViewController alloc]init];
    gdvc.geofenceInfo = self.geofenceList[indexPath.row];
    gdvc.existedNameArray = existedNameArray;
    gdvc.geofenceCoordinate = CLLocationCoordinate2DMake(gdvc.geofenceInfo.latitude, gdvc.geofenceInfo.longitude);
    gdvc.radius = gdvc.geofenceInfo.geofence_radius;
    gdvc.mapView = self.mapView;
    [self.navigationController pushViewController:gdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        label.center = self.view.center;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = EH_font1;
        label.text = @"当前暂无围栏";
        _noDataView = label;
    }
    
    return _noDataView;
}

- (void)configInsertGeofenceService{
    if (!_listService) {
        _listService = [EHGetGeofenceListService new];
        typeof(_tableView) __weak weakTableView = _tableView;
        typeof(self) __weak weakSelf = self;
        _listService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            [WeAppToast toast:@"获取围栏列表成功"];
            weakSelf.geofenceList = service.dataList;
            for (EHGetGeofenceListRsp *rsp in service.dataList) {
                EHLogInfo(@"rsp = %@",rsp);
            }
            static dispatch_once_t predicate;
            dispatch_once(&predicate, ^{
                _beginListCount = weakSelf.geofenceList.count;
            });
            [weakSelf checkDataArray];
            [weakTableView reloadData];
        };
        _listService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"获取围栏列表失败"];
        };
    }
}

- (void)configUpdateGeofenceStatusService{
    if (!_statusService) {
        _statusService = [EHUpdateGeofenceStatusService new];
        typeof(self) __weak weakSelf = self;
        _statusService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            [WeAppToast toast:@"更新围栏开关成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _statusService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"更新围栏开关失败"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
}

@end
