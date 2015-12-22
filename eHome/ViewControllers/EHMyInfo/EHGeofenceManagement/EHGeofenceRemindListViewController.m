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
#import "EHBabyDetailTableViewCell.h"
#import "EHGeofenceRemindModel.h"
#import "EHRemindViewModel.h"
#import "NSString+StringSize.h"

static NSString * const kEHGeofenceRemindStr = @"开启主动提醒状态，如果在规定时间内，宝贝不在围栏范围内，则会向您发送提醒通知。";

@interface EHGeofenceRemindListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GroupedTableView      *tableView;

@property (nonatomic, strong) UIView                *footerView;

@property (nonatomic, strong) UIView                *noDataView;

@property (nonatomic, strong) NSMutableArray        *geofenceRemindList;

@property (nonatomic, strong) EHGeofenceRemindModel *needUpdateModel;

@property (nonatomic, strong) EHUpdateGeofenceRemindService *updateRemindService;

@end

@implementation EHGeofenceRemindListViewController
{
    EHGetGeofenceRemindService *_getRemindService;

}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主动提醒";
    self.view.backgroundColor = EHBgcor1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.noDataView];
    [self.view addSubview:self.tableView];
    
    [self reloadData];
    
    [self showLoadingView];
    [self configGetRemindService];
    [_getRemindService getGeofenceRemindWithGeofenceID:self.geofence_id];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

#pragma mark - Events Response
- (void)rightItemClick:(id)sender {
    if (![KSAuthenticationCenter isLogin]) {
        void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
            // 如果登陆成功就回到主界面
            TBOpenURLFromTargetWithNativeParams(tabbarURL(kEHOMETabHome), self, @{ACTION_ANIMATION_KEY:@(NO)} ,nil);
        };
        [[KSAuthenticationCenter sharedCenter] authenticateWithAlertViewMessage:LOGIN_ALERTVIEW_MESSAGE LoginActionBlock:loginActionBlock cancelActionBlock:nil source:self];
        return;
    }
    if (self.geofenceRemindList.count == 5) {
        [WeAppToast toast:@"您的围栏提醒数量已经到5个，无法继续新增围栏提醒"];
        return;
    }
    EHGeofenceRemindAddViewController *grdVC = [[EHGeofenceRemindAddViewController alloc]init];
    grdVC.remindModel.geofence_id = self.geofence_id;
    grdVC.babyUser = self.babyUser;
    grdVC.geofenceName = self.geofenceName;
    grdVC.remindStatusType = EHRemindStatusTypeAdd;
    WEAKSELF
    grdVC.remindNeedAdd = ^(EHGeofenceRemindModel *remindModel) {
        STRONGSELF
        strongSelf.needUpdateModel = remindModel;
        [strongSelf updateRemindList:EHRemindListStatusTypeAdd];
        [strongSelf checkGeofenceRemindList];
    };
    [self.navigationController pushViewController:grdVC animated:YES];
}

#pragma mark - Private Methods
- (void)reloadData{
    [self.tableView reloadData];
    [self checkGeofenceRemindList];
}

- (void)checkGeofenceRemindList {
    if (self.geofenceRemindList.count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    }
    else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
}
/**
 *  数据源重排序
 */
//按照开关状态排序（EHOMEIOS-327 Bug修复，去除该方法）
//- (NSMutableArray *)remindListSorted:(NSArray *)remindList {
//    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//    NSMutableArray *onArray = [[NSMutableArray alloc]init];
//    NSMutableArray *offArray = [[NSMutableArray alloc]init];
//    for (EHGeofenceRemindModel *model in remindList) {
//        if ([model.is_active boolValue]) {
//            [onArray addObject:model];
//        }
//        else {
//            [offArray addObject:model];
//        }
//    }
//    if (onArray.count > 1) {
//        onArray = [self remindListSortedByTime:onArray];
//    }
//    if (offArray.count > 1) {
//        offArray = [self remindListSortedByTime:offArray];
//    }
//    
//    if (onArray.count != 0) {
//        for (EHGeofenceRemindModel *model in onArray) {
//            [resultArray addObject:model];
//        }
//    }
//    if (offArray.count != 0) {
//        for (EHGeofenceRemindModel *model in offArray) {
//            [resultArray addObject:model];
//        }
//    }
//    return resultArray;
//}

/**
 *  按时间进行排序
 */
- (NSMutableArray *)remindListSortedByTime:(NSArray *)array {
    if (array == nil) {
        return nil;
    }
    NSMutableArray *mArray = [array mutableCopy];
    for (NSInteger i = 0; i < (mArray.count - 1); i++) {
        for (NSInteger j = 0; j < (mArray.count - 1) - i; j++) {
            EHGeofenceRemindModel *currentModel = mArray[j];
            EHGeofenceRemindModel *nextModel = mArray[j + 1];
            //比较时的大小
            if([[currentModel.time substringToIndex:2] integerValue] > [[nextModel.time substringToIndex:2] integerValue]){
                [mArray exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
            }
            //如果时一样，比较分的大小
            else if ([[currentModel.time substringToIndex:2] integerValue] == [[nextModel.time substringToIndex:2] integerValue]) {
                if ([[currentModel.time substringFromIndex:3] integerValue] > [[nextModel.time substringFromIndex:3] integerValue]) {
                    [mArray exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                }
            }
        }
    }
    return mArray;
}

/**
 *  对编辑过的数据源进行更新，并动画移动重排序后的位置
 */
- (void)updateRemindList:(EHRemindListStatusType)remindListStatusType {
    switch (remindListStatusType) {
            
        case EHRemindListStatusTypeAdd: {
            [self.geofenceRemindList addObject:self.needUpdateModel];
            self.geofenceRemindList = [self remindListSortedByTime:self.geofenceRemindList];
            NSInteger updatedRow = [self.geofenceRemindList indexOfObject:self.needUpdateModel];
            NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedRow inSection:1];
        
            [self.tableView insertRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case EHRemindListStatusTypeUpdate: {
            NSInteger needUpdateRow = [self.geofenceRemindList indexOfObject:self.needUpdateModel];
            NSIndexPath *needUpdateIndexPath = [NSIndexPath indexPathForRow:needUpdateRow inSection:1];
            EHGeofenceRemindModel *model = self.geofenceRemindList[needUpdateRow];
            EHRemindViewModel *viewModel = [[EHRemindViewModel alloc]initWithGeofenceRemindModel:model];
            EHRemindListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:needUpdateIndexPath];
            [cell configWithRemindModel:viewModel RemindType:EHRemindTypeGeofence];
                                     
            self.geofenceRemindList = [self remindListSortedByTime:self.geofenceRemindList];
            NSInteger updatedRow = [self.geofenceRemindList indexOfObject:self.needUpdateModel];
            NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedRow inSection:1];
            
            [self.tableView moveRowAtIndexPath:needUpdateIndexPath toIndexPath:updatedIndexPath];
        }
            break;
            
        case EHRemindListStatusTypeDelete: {
            NSInteger index = [self.geofenceRemindList indexOfObject:self.needUpdateModel];
            [self.geofenceRemindList removeObjectAtIndex:index];
            
            NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:index inSection:1];
            [self.tableView deleteRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;

        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else {
        return self.geofenceRemindList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        EHBabyDetailTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHBabyDetailTableViewCell class]) owner:self options:nil] firstObject];;
        
        UIImage *defaultHeadImage = [UIImage imageNamed:@"headportrait_boy_160"];
        NSURL *imageUrl = [NSURL URLWithString:self.babyUser.babyHeadImage];
        [cell.babyHeadImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUser.babyId newPlaceHolderImagePath:self.babyUser.babyHeadImage defaultHeadImage:defaultHeadImage]];
        
        cell.babyNameLabel.text = self.babyUser.babyNickName;
        cell.babyDetalLabel.text = [NSString stringWithFormat:@"围栏：%@",self.geofenceName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
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
            strongSelf.needUpdateModel = model;
            model.is_active = @(!([model.is_active boolValue]));
            
            //进行状态更新请求再排序显示
            [strongSelf showLoadingView];
            
            [strongSelf configUpdateRemindService];
            [strongSelf.updateRemindService UpdateGeofenceRemind:model];
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    else {
        CGFloat labelHeight = [@"text" sizeWithFontSize:EHSiz5 Width:SCREEN_WIDTH].height;
        return labelHeight * 2 + 24/2.0 + 31/2.0*2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    else return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 0?nil:self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    //提醒编辑
    EHGeofenceRemindEditViewController *greVC =[[EHGeofenceRemindEditViewController alloc] init];
    greVC.remindModel = self.geofenceRemindList[indexPath.row];
    greVC.remindModel.geofence_id = self.geofence_id;
    greVC.babyUser = self.babyUser;
    greVC.geofenceName = self.geofenceName;
    greVC.remindStatusType = EHRemindStatusTypeEdit;
    EHLogInfo(@"1 remindNeedUpdate = %@",self.geofenceRemindList[indexPath.row]);
    EHLogInfo(@"1 self.geofenceRemindList = %@",self.geofenceRemindList);

    WEAKSELF
    greVC.remindNeedUpdate = ^(EHGeofenceRemindModel *remindModel){
        STRONGSELF
        EHLogInfo(@"2 remindNeedUpdate = %@",remindModel);
        EHLogInfo(@"2 self.geofenceRemindList = %@",self.geofenceRemindList);

        strongSelf.needUpdateModel = remindModel;
        [strongSelf updateRemindList:EHRemindListStatusTypeUpdate];
    };
    greVC.remindNeedDelete = ^(EHGeofenceRemindModel *remindModel){
        STRONGSELF
        strongSelf.needUpdateModel = remindModel;
        [strongSelf updateRemindList:EHRemindListStatusTypeDelete];
        [strongSelf checkGeofenceRemindList];
    };
    [self.navigationController pushViewController:greVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters And Setters
- (void)configGetRemindService{
    if (!_getRemindService) {
        _getRemindService = [EHGetGeofenceRemindService new];
        
        WEAKSELF
        _getRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            strongSelf.geofenceRemindList = [strongSelf remindListSortedByTime:service.dataList];
            [strongSelf reloadData];
            [strongSelf hideLoadingView];
        };
        
        _getRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"获取围栏提醒失败"];
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
            //            [strongSelf configGetRemindService];
            //            [_getRemindService getGeofenceRemindWithGeofenceID:self.geofence_id];
            [strongSelf updateRemindList:EHRemindListStatusTypeUpdate];
        };
        _updateRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
            
            strongSelf.needUpdateModel.is_active = @(!([strongSelf.needUpdateModel.is_active boolValue]));
            NSInteger row = [strongSelf.geofenceRemindList indexOfObject:strongSelf.needUpdateModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
            EHRemindListTableViewCell *cell = (EHRemindListTableViewCell *)[strongSelf.tableView cellForRowAtIndexPath:indexPath];
            [cell.isActiveSwitch setOn:!cell.isActiveSwitch.on animated:YES];
        };
    }
}

- (NSMutableArray *)geofenceRemindList {
    if (!_geofenceRemindList) {
        _geofenceRemindList = [[NSMutableArray alloc]init];
    }
    return _geofenceRemindList;
}

- (EHGeofenceRemindModel *)needUpdateModel {
    if (!_needUpdateModel) {
        _needUpdateModel = [[EHGeofenceRemindModel alloc] init];
    }
    return _needUpdateModel;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame) - 16, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        CGFloat height = [kEHGeofenceRemindStr sizeWithFontSize:EH_siz5 Width:CGRectGetWidth(self.tableView.frame)].height;
        
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), height)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        CGRect frame = CGRectMake(kSpaceX, 12, CGRectGetWidth(_footerView.frame) - kSpaceX * 2, height);
        UILabel * remindLabel = [[UILabel alloc]initWithFrame:frame];
        remindLabel.text = kEHGeofenceRemindStr;
        remindLabel.font = EH_font5;
        remindLabel.textColor = EHCor4;
        remindLabel.textAlignment = NSTextAlignmentLeft;
        remindLabel.numberOfLines = 0;
        remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [_footerView addSubview:remindLabel];
    }
    return _footerView;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        CGFloat imageHeight = 90;
        CGFloat labelHeight = [kEHGeofenceRemindStr sizeWithFontSize:EH_siz5 Width:CGRectGetWidth(self.tableView.frame)].height;
        CGFloat viewHeight = 137 / 2.0 + imageHeight + 50 + labelHeight;
        
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.tableView.frame) - 16, viewHeight)];
        _noDataView.backgroundColor = [UIColor clearColor];
        
        UIImageView *clockImv = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_noDataView.frame) - imageHeight) / 2.0, 137 / 2.0, imageHeight, imageHeight)];
        clockImv.image = [UIImage imageNamed:@"icon_remind"];
        
        UILabel * remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, viewHeight - labelHeight, CGRectGetWidth(_noDataView.frame) - kSpaceX * 2, labelHeight)];
        remindLabel.text = kEHGeofenceRemindStr;
        remindLabel.font = EH_font5;
        remindLabel.textColor = EHCor4;
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.numberOfLines = 0;
        remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [_noDataView addSubview:clockImv];
        [_noDataView addSubview:remindLabel];
    }
    return _noDataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
