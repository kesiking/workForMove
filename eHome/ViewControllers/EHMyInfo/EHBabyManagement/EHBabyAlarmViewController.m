//
//  EHBabyAlarmViewController.m
//  eHome
//
//  Created by jinmiao on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyAlarmViewController.h"
#import "EHGetBabyAlarmService.h"
#import "EHBabyAlarmModel.h"
#import "EHRemindListTableViewCell.h"
#import "EHEditBabyAlarmService.h"
#import "NSString+StringSize.h"
#import "Masonry.h"
#import "EHAlarmHeaderTableViewCell.h"
#import "GroupedTableView.h"

static NSString * const kEHBabyAlarmStr = @"开启主动提醒状态，如果在规定时间内，宝贝不在该范围内，亦会向您发送提醒通知。";

@interface EHBabyAlarmViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    EHGetBabyAlarmService *_getBabyAlarmService;
    EHEditBabyAlarmService *_editBabyAlarmService;
    
}

@property (strong,nonatomic) GroupedTableView *tableView;
@property (strong,nonatomic) UIImageView *alarmImageView;
@property (strong,nonatomic) UILabel *remindLabel;
@property (strong,nonatomic) NSIndexPath *activeChangedIndexPath;
@property (strong,nonatomic) EHBabyAlarmModel *needUpdateModel;

@end

@implementation EHBabyAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"宝贝闹钟";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBabyAlarmBtn)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    self.view.backgroundColor=EHBgcor1;
//    self.activeChangedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self updateAlarmList];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.alarmImageView];
    [self.view addSubview:self.remindLabel];
    [self getBabyAlarmList];


    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //修复iOS7直接崩溃bug
    [self.view layoutIfNeeded];
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self updateAlarmList];
    [self addConstraints];

    

}

-(void)updateAlarmList{
    [self.tableView reloadData];
    if (self.babyAlarmList.count == 0) {
        self.tableView.hidden = YES;
        self.remindLabel.hidden = NO;
        self.alarmImageView.hidden = NO;
    }
    else{
        self.tableView.hidden = NO;
        self.remindLabel.hidden = YES;
        self.alarmImageView.hidden = YES;
    }
}

-(void)addBabyAlarmBtn{
    if (self.babyAlarmList.count == 8) {
        [WeAppToast toast:@"宝贝的提醒数量已经到达8个，无法继续增加"];
        return;
    }

    EHBabyAlarmAddViewController *addBabyAlarmVC = [[EHBabyAlarmAddViewController alloc]init];
    addBabyAlarmVC.babyUser = self.babyUser;
    addBabyAlarmVC.babyAlarmList = self.babyAlarmList;
    WEAKSELF
    addBabyAlarmVC.addBlock = ^(EHBabyAlarmModel *alarmModel){
        STRONGSELF
        EHLogInfo(@"addBlock - self.babyAlarmList = \n%@",strongSelf.babyAlarmList);
        strongSelf.needUpdateModel = alarmModel;
        [strongSelf updateBabyAlarmList:EHAlarmListStatusTypeAdd];
        [strongSelf updateAlarmList];

//        [strongSelf.babyAlarmList addObject:alarmModel];
//        strongSelf.babyAlarmList = [strongSelf remindsArraySorted:strongSelf.babyAlarmList];
//        [strongSelf updateAlarmList];
    };

    [self.navigationController pushViewController:addBabyAlarmVC animated:YES ];
}

- (NSMutableArray *)remindsArraySorted:(NSArray *)alarmArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *onArray = [[NSMutableArray alloc]init];
    NSMutableArray *offArray = [[NSMutableArray alloc]init];
    for (EHBabyAlarmModel *model in alarmArray) {
        if ([model.is_active boolValue]) {
            [onArray addObject:model];
        }
        else {
            [offArray addObject:model];
        }
    }
    if (onArray.count > 1) {
        onArray = [self remindsArraySortedByTime:onArray];
    }
    if (offArray.count > 1) {
        offArray = [self remindsArraySortedByTime:offArray];
    }
    
    if (onArray.count != 0) {
        for (EHBabyAlarmModel *model in onArray) {
            [resultArray addObject:model];
        }
    }
    if (offArray.count != 0) {
        for (EHBabyAlarmModel *model in offArray) {
            [resultArray addObject:model];
        }
    }
    return resultArray;
}

- (NSMutableArray *)remindsArraySortedByTime:(NSMutableArray *)array {
    for (NSInteger i = 0; i < (array.count - 1); i++) {
        for (NSInteger j = 0; j < (array.count - 1) - i; j++) {
            EHBabyAlarmModel *currentModel = array[j];
            EHBabyAlarmModel *nextModel = array[j + 1];
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

///**
// *  对开关状态更改过的数据源进行更新，并动画移动重排序后的位置
// */
//- (void)updateBabyAlarmList {
//    
//    NSInteger needUpdateRow = [self.babyAlarmList indexOfObject:self.needUpdateModel];
//    NSIndexPath *needUpdateIndexPath = [NSIndexPath indexPathForRow:needUpdateRow inSection:1];
//    
//    self.babyAlarmList = [self remindsArraySorted:self.babyAlarmList];
//    NSInteger updatedRow = [self.babyAlarmList indexOfObject:self.needUpdateModel];
//    NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedRow inSection:1];
//    
//    [self.tableView moveRowAtIndexPath:needUpdateIndexPath toIndexPath:updatedIndexPath];
//}

/**
 *  对编辑过的数据源进行更新，并动画移动重排序后的位置
 */
- (void)updateBabyAlarmList:(EHAlarmListStatusType)alarmListStatusType {
    switch (alarmListStatusType) {
            
        case EHAlarmListStatusTypeAdd: {
            [self.babyAlarmList addObject:self.needUpdateModel];
            self.babyAlarmList = [self remindsArraySorted:self.babyAlarmList];
            NSInteger updatedRow = [self.babyAlarmList indexOfObject:self.needUpdateModel];
            NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedRow inSection:1];
            
            [self.tableView insertRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case EHAlarmListStatusTypeUpdate: {
            NSInteger needUpdateRow = [self.babyAlarmList indexOfObject:self.needUpdateModel];
            NSIndexPath *needUpdateIndexPath = [NSIndexPath indexPathForRow:needUpdateRow inSection:1];
            EHBabyAlarmModel *model = self.babyAlarmList[needUpdateRow];
            EHRemindViewModel *viewModel = [[EHRemindViewModel alloc]initWithBabyAlarmModel:model];
            EHRemindListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:needUpdateIndexPath];
            [cell configWithRemindModel:viewModel RemindType:EHRemindTypeBaby];
            
            self.babyAlarmList = [self remindsArraySorted:self.babyAlarmList];
            NSInteger updatedRow = [self.babyAlarmList indexOfObject:self.needUpdateModel];
            NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedRow inSection:1];
            
            [self.tableView moveRowAtIndexPath:needUpdateIndexPath toIndexPath:updatedIndexPath];
        }
            break;
            
        case EHAlarmListStatusTypeDelete: {
            NSInteger index = [self.babyAlarmList indexOfObject:self.needUpdateModel];
            [self.babyAlarmList removeObjectAtIndex:index];
            
            NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:index inSection:1];
            [self.tableView deleteRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        default:
            break;
    }
    
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = self.babyAlarmList.count;;
            break;
        default:
            break;
    }
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        EHAlarmHeaderTableViewCell *cell = [[EHAlarmHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell configWithBabyInfo:self.babyUser];
        return cell;
    }
    else{
        static NSString *cellID = @"cellID";
        EHRemindListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[EHRemindListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        EHBabyAlarmModel *model = self.babyAlarmList[indexPath.row];
        EHRemindViewModel *viewModel = [[EHRemindViewModel alloc]initWithBabyAlarmModel:model];
        [cell configWithRemindModel:viewModel RemindType:EHRemindTypeBaby
         ];
        WEAKSELF
        cell.activeStatusChangeBlock = ^(BOOL isOn){
            STRONGSELF
            model.is_active = @((NSInteger)isOn);
            
            strongSelf.needUpdateModel = model;
//            strongSelf.needUpdateModel.is_active = @(!([strongSelf.needUpdateModel.is_active boolValue]));
            [strongSelf configUpdateAlarmService];
            [_editBabyAlarmService editBabyAlarm:model];
            EHLogInfo(@"isOn = %d",isOn);
        };
        return cell;

    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (indexPath.section ==0) {
        cellHeight = 81.f;
    }
    else{
        CGFloat fontHeight = [@"text" sizeWithFontSize:EH_siz5 Width:MAXFLOAT].height;
        cellHeight = fontHeight * 2 + 24/2.0 + 31/2.0*2;

    }
    return cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return;
    }
    else{
        EHBabyAlarmEditViewController *editAlarmVC = [[EHBabyAlarmEditViewController alloc]init];
        editAlarmVC.alarmModel = self.babyAlarmList[indexPath.row];
        editAlarmVC.babyUser = self.babyUser;

        WEAKSELF
        editAlarmVC.editBlock = ^(EHBabyAlarmModel *alarmModel){
            STRONGSELF
            strongSelf.needUpdateModel = alarmModel;
            [strongSelf updateBabyAlarmList:EHAlarmListStatusTypeUpdate];
    
        };
        
        editAlarmVC.deleteBlock = ^(EHBabyAlarmModel *alarmModel){
            STRONGSELF
//            [strongSelf.babyAlarmList removeObjectAtIndex:indexPath.row];
//            EHLogInfo(@"deleteBlock - self.babyalarmlist = \n%@",strongSelf.babyAlarmList);
            strongSelf.needUpdateModel = alarmModel;
            [strongSelf updateBabyAlarmList:EHAlarmListStatusTypeDelete];
            [self updateAlarmList];
            
        };
        
        [self.navigationController pushViewController:editAlarmVC animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}




- (void)getBabyAlarmList
{
    if (![EHUtils isAuthority:self.babyUser.authority]) {
        return;
    }
    _getBabyAlarmService = [EHGetBabyAlarmService new];
    
    WEAKSELF
    _getBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getBabyAlarmList完成！");
        STRONGSELF
        
        EHLogInfo(@"%@",service.dataList);
        strongSelf.babyAlarmList = [strongSelf remindsArraySorted:service.dataList];
        [strongSelf updateAlarmList];
        //[strongSelf hideLoadingView];
        
        
    };
    _getBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"更新失败"];
    };
    
    [_getBabyAlarmService getBabyAlarmListById:self.babyUser.babyId];
    EHLogInfo(@"babyalarmlist.count = %lu",(unsigned long)self.babyAlarmList.count);
}

- (void)configUpdateAlarmService{
    if (!_editBabyAlarmService) {
        _editBabyAlarmService = [EHEditBabyAlarmService new];
        WEAKSELF
        _editBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService *service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新成功"];
//            strongSelf.babyAlarmList = [strongSelf remindsArraySorted:strongSelf.babyAlarmList];
            [strongSelf updateBabyAlarmList:EHAlarmListStatusTypeUpdate];
        };
        _editBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService *service, NSError *error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
            
            strongSelf.needUpdateModel.is_active = @(!([strongSelf.needUpdateModel.is_active boolValue]));
            NSInteger row = [strongSelf.babyAlarmList
                             indexOfObject:strongSelf.needUpdateModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
            EHRemindListTableViewCell *cell = (EHRemindListTableViewCell *)[strongSelf.tableView cellForRowAtIndexPath:indexPath];
            [cell.isActiveSwitch setOn:!cell.isActiveSwitch.on animated:YES];
            
        };
    }
}


-(void)addConstraints{
    [_alarmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(69);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alarmImageView.mas_bottom).with.offset(25);
        CGSize size = [kEHBabyAlarmStr sizeWithFontSize:EHSiz4 Width:self.view.width-70];
        make.size.mas_equalTo(CGSizeMake(self.view.width-70, size.height));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}



#pragma mark - getter and setter

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame)-16, CGRectGetHeight(self.view.frame)-12) style:UITableViewStyleGrouped];
        _tableView.backgroundColor =EHBgcor1;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIImageView *)alarmImageView{
    if (!_alarmImageView) {
        _alarmImageView = [[UIImageView alloc]init];
        [_alarmImageView setImage:[UIImage imageNamed:@"icon_clock"]];
    }
    return _alarmImageView;
}

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc]init];
        _remindLabel.text = kEHBabyAlarmStr;
        _remindLabel.font = EHFont5;
        _remindLabel.textColor = EHCor4;
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.numberOfLines = 0;
        _remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _remindLabel;
}

- (EHBabyAlarmModel *)needUpdateModel {
    if (!_needUpdateModel) {
        _needUpdateModel = [[EHBabyAlarmModel alloc] init];
    }
    return _needUpdateModel;
}


- (NSMutableArray *)babyAlarmList{
    if (!_babyAlarmList) {
        _babyAlarmList = [[NSMutableArray alloc]init];
    }
    return _babyAlarmList;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
