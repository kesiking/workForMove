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

static NSString * const kEHBabyAlarmStr = @"点击“+”可以为宝贝添加提醒";

@interface EHBabyAlarmViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    EHGetBabyAlarmService *_getBabyAlarmService;
    EHEditBabyAlarmService *_editBabyAlarmService;
    
}

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UILabel *babyNameLabel;
@property (strong,nonatomic) UIImageView *babyHeadImageView;
@property (strong,nonatomic) UILabel *remindLabel;
@property (nonatomic, strong) NSIndexPath *activeChangedIndexPath;

@end

@implementation EHBabyAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"宝贝提醒";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBabyAlarmBtn)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.activeChangedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.remindLabel];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self updateAlarmList];
    [self getBabyAlarmList];

    

}

-(void)updateAlarmList{
    [self.tableView reloadData];
    if (self.babyAlarmList.count == 0) {
        self.tableView.hidden = YES;
        self.remindLabel.hidden = NO;
        CGRect frame = _remindLabel.frame;
        frame.origin.y = 20;
        _remindLabel.frame = frame;
    }
    else{
        self.tableView.hidden = NO;
        self.remindLabel.hidden = YES;
        CGRect frame = _remindLabel.frame;
        frame.origin.y = CGRectGetHeight(self.tableView.frame) + 20;
        _remindLabel.frame = frame;

    }
}

-(void)addBabyAlarmBtn{
    if (self.babyAlarmList.count == 8) {
        [WeAppToast toast:@"宝贝的提醒数量已经到达8个，无法继续增加"];
        return;
    }

    EHAddBabyAlarmViewController *addBabyAlarmVC = [[EHAddBabyAlarmViewController alloc]init];
    addBabyAlarmVC.babyUser = self.babyUser;
    addBabyAlarmVC.babyAlarmList = self.babyAlarmList;
    WEAKSELF
    addBabyAlarmVC.addBlock = ^(EHBabyAlarmModel *alarmModel){
        STRONGSELF
        EHLogInfo(@"addBlock - self.babyAlarmList = \n%@",strongSelf.babyAlarmList);
        [strongSelf.babyAlarmList addObject:alarmModel];
        strongSelf.babyAlarmList = [strongSelf remindsArraySorted:strongSelf.babyAlarmList];
        [strongSelf updateAlarmList];
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



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.babyAlarmList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        strongSelf.activeChangedIndexPath = indexPath;

        strongSelf.babyAlarmList = [strongSelf remindsArraySorted:strongSelf.babyAlarmList];
        //[strongSelf updateAlarmList];
        [strongSelf configUpdateAlarmService];
        [_editBabyAlarmService editBabyAlarm:model];

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
    EHEditBabyAlarmViewController *editAlarmVC = [[EHEditBabyAlarmViewController alloc]init];
    editAlarmVC.alarmModel = self.babyAlarmList[indexPath.row];
    editAlarmVC.babyUser = self.babyUser;
    WEAKSELF
    editAlarmVC.editBlock = ^(EHBabyAlarmModel *alarmModel){
        STRONGSELF
        strongSelf.babyAlarmList[indexPath.row] = alarmModel;
        strongSelf.babyAlarmList = [strongSelf remindsArraySorted:strongSelf.babyAlarmList];
        [strongSelf updateAlarmList];
        EHLogInfo(@"editBlock - self.babyalarmlist = \n%@",strongSelf.babyAlarmList);
    };

    editAlarmVC.deleteBlock = ^(EHBabyAlarmModel *alarmModel){
        STRONGSELF
        [strongSelf.babyAlarmList removeObjectAtIndex:indexPath.row];
        EHLogInfo(@"deleteBlock - self.babyalarmlist = \n%@",strongSelf.babyAlarmList);
    };
    
    [self.navigationController pushViewController:editAlarmVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

#pragma mark - getter and setter

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
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
        _remindLabel.text = kEHBabyAlarmStr;
        _remindLabel.font = EH_font3;
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.numberOfLines = 0;
        _remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGSize size = [kEHBabyAlarmStr sizeWithFontSize:EH_siz3 Width:CGRectGetWidth(_remindLabel.frame)];
        frame.size.height = size.height;
        _remindLabel.frame = frame;
    }
    return _remindLabel;
}

- (void)configUpdateAlarmService{
    if (!_editBabyAlarmService) {
        _editBabyAlarmService = [EHEditBabyAlarmService new];
        WEAKSELF
        _editBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService *service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新成功"];
            strongSelf.babyAlarmList = [strongSelf remindsArraySorted:strongSelf.babyAlarmList];
            [strongSelf updateAlarmList];
        };
        _editBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService *service, NSError *error){
            STRONGSELF
            EHRemindListTableViewCell *cell = (EHRemindListTableViewCell *)[strongSelf.tableView cellForRowAtIndexPath:strongSelf.activeChangedIndexPath];
            cell.isActiveButton.selected = !cell.isActiveButton.selected;
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
        };
    }
}

-(UIView *)headerViewForTableView{
    CGFloat height = [self tableView:_tableView heightForHeaderInSection:0];
    CGFloat imageWidth = 40;
    CGFloat nameHeight = [@"name" sizeWithFontSize:EH_siz3 Width:160].height;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), height)];
    
    self.babyHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSpaceX, (height - imageWidth) / 2.0, imageWidth, imageWidth)];
    self.babyHeadImageView.layer.masksToBounds = YES;
    self.babyHeadImageView.layer.cornerRadius = imageWidth / 2.0;
    UIImage *defaultHeadImage = [UIImage imageNamed:@"headportrait_boy_160"];
    NSURL *imageUrl = [NSURL URLWithString:self.babyUser.babyHeadImage];
    [self.babyHeadImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUser.babyId newPlaceHolderImagePath:self.babyUser.babyHeadImage defaultHeadImage:defaultHeadImage]];
    
    
    self.babyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.babyHeadImageView.frame) + 5, (height - nameHeight) / 2.0, 160, nameHeight)];
    self.babyNameLabel.font = EH_font3;
    self.babyNameLabel.textAlignment = NSTextAlignmentLeft;
    NSString *nameStr;
    if ([EHUtils isAuthority:self.babyUser.authority]) {
        nameStr = self.babyUser.babyName;
    }
    else
    {
        nameStr = self.babyUser.babyNickName ? self.babyUser.babyNickName : self.babyUser.babyName;
    }
    _babyNameLabel.text = nameStr;
    
    [headView addSubview:self.babyHeadImageView];
    [headView addSubview:self.babyNameLabel];
    
    return headView;
    
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
