//
//  EHBabyAlarmAddViewController.m
//  eHome
//
//  Created by jinmiao on 15/9/29.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyAlarmAddViewController.h"
#import "EHAddBabyAlarmService.h"
#import "EHRemindDateTableViewCell.h"
#import "EHAlarmCommentTableViewCell.h"
#import "RMActionController.h"
#import "UIViewController+BackButtonHandler.h"
#import "NSString+StringSize.h"
#import "EHPickerView.h"
#import "EHAlarmHeaderTableViewCell.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"

#define kRowHeight 50

@interface EHBabyAlarmAddViewController ()<EHPickerViewDataSource,EHPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) EHPickerView *pickerView;
@property (strong,nonatomic) GroupedTableView *tableView;
@property (strong,nonatomic) NSMutableArray *hourArray;
@property (strong,nonatomic) NSMutableArray *minuteArray;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end

@implementation EHBabyAlarmAddViewController
{
    EHAddBabyAlarmService *_addBabyAlarmService;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加宝贝提醒";
    self.view.backgroundColor=EHBgcor1;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.view addSubview:self.tableView];
//    [self hourArray];
//    [self minuteArray];
    
    self.alarmUpdated = NO;
    [self showWorkDate];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
    NSArray *dateArray = [self.alarmModel.time componentsSeparatedByString:@":"];
    [_pickerView  selectRow:[dateArray[0] integerValue] inComponent:0 animated:YES];
    [_pickerView  selectRow:[dateArray[1] integerValue] inComponent:1 animated:YES];}

#pragma mark - Events Response
- (void)doneBtnClicked {
    if ([self.alarmModel.work_date isEqualToString:@"0000000"]) {
        [WeAppToast toast:@"请选择日期"];
        return;
    }
    [self configAddBabyAlarmService];
    self.alarmModel.baby_id = self.babyUser.babyId;
    [_addBabyAlarmService addBabyAlarm:self.alarmModel];
    EHLogInfo(@"alarmlist.count = %lu",(unsigned long)self.babyAlarmList.count);
}

/**
 *  频率：重复/仅一次
 */
- (void)showFrequencyAlert
{
    
    RMActionController* frequencyVC = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    
    WEAKSELF
    RMAction *repeatAction = [RMAction actionWithTitle:@"重复" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        strongSelf.alarmModel.is_repeat = @1;
        strongSelf.alarmUpdated = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"重复";
        cell.detailTextLabel.font = EHFont2;
    }];
    
    repeatAction.titleColor = EH_cor4;
    
    RMAction *onceAction = [RMAction actionWithTitle:@"仅一次" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        strongSelf.alarmModel.is_repeat = @0;
        strongSelf.alarmUpdated = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"仅一次";
        cell.detailTextLabel.font = EHFont2;
    }];
    
    onceAction.titleColor = EH_cor4;
    
    [frequencyVC addAction:onceAction];
    [frequencyVC addAction:repeatAction];
    
    frequencyVC.seperatorViewColor = EH_linecor1;
    frequencyVC.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    frequencyVC.disableBouncingEffects = YES;
    frequencyVC.disableMotionEffects = YES;
    frequencyVC.disableBlurEffects = YES;
    
    [self presentViewController:frequencyVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
    


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    else if(section == 1) return 1;
    else if(section == 2) return 2;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    if (indexPath.section == 0) {
        EHAlarmHeaderTableViewCell *cell = [[EHAlarmHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell configWithBabyInfo:self.babyUser];
        return cell;
    }
    else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:self.pickerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section ==2){
        if (indexPath.row == 0) {
            EHRemindDateTableViewCell *cell = [[EHRemindDateTableViewCell alloc]init];
            [cell selectWorkDate:self.alarmModel.work_date];
            cell.dateBtnClickBlock = ^(NSString *dateStr){
                self.alarmModel.work_date = dateStr;
                self.alarmUpdated = YES;
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = @"频率";
            cell.textLabel.font = EHFont2;
            cell.textLabel.textColor= EHCor5;
            cell.detailTextLabel.text = [self.alarmModel.is_repeat boolValue]?@"重复":@"仅一次";
            cell.detailTextLabel.font = EHFont2;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    else {
        EHAlarmCommentTableViewCell *cell = [[EHAlarmCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.comment = self.alarmModel.context;
        
        cell.commentAddBlock = ^(NSString *comment){
           // self.alarmModel.context = comment;
            self.alarmModel.context = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.alarmUpdated = YES;
        };
        return cell;
        
    }
}

//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
//        
//        UILabel *deleteLabel = [[UILabel alloc]initWithFrame:cell.bounds];
//        deleteLabel.text = @"删除该提醒";
//        deleteLabel.font = EH_font2;
//        deleteLabel.textColor = RGB(0xff, 0x3e, 0x3e);
//        deleteLabel.textAlignment = NSTextAlignmentCenter;
//        
//        [cell.contentView addSubview:deleteLabel];
//        return cell;

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 81;
    }
    else if (indexPath.section == 1) {
        return self.pickerView.height;
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CGFloat btnWidth = (CGRectGetWidth(tableView.frame) - 11 * 6 - 12 * 2) / 7;
            return (15 + [@"text" sizeWithFontSize:EH_siz2 Width:MAXFLOAT].height + 21 + btnWidth + 21);
        }
        else {
            return 44;
        }
    }
    else {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
//    if (section <= 2) {
//        return 12;
//    }
//    else return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            [self showFrequencyAlert];
        }
    }
//    else if (indexPath.section == 3){
//        [self showdeleteRemindAlert];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EHPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(nonnull EHPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull EHPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.hourArray.count;
    }
    else return self.minuteArray.count;
}

#pragma mark - EHPickerViewDelegate
- (void)pickerView:(nonnull EHPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSMutableString *muStr = [self.alarmModel.time mutableCopy];
    if (component == 0) {
        NSRange range = NSMakeRange(0, 2);
        [muStr replaceCharactersInRange:range withString:self.hourArray[row]];
    }
    else {
        NSRange range = NSMakeRange(3, 2);
        [muStr replaceCharactersInRange:range withString:self.minuteArray[row]];
    }
    self.alarmModel.time = (NSString *)muStr;
    self.alarmUpdated = YES;
}

- (nullable NSString *)pickerView:(nonnull EHPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.hourArray[row];
    }
    else {
        return self.minuteArray[row];
    }
}

- (nullable NSString *)pickerView:(nonnull EHPickerView *)pickerView unitTitleForComponent:(NSInteger)component {
    if (component == 0) {
        return @"时";
    }
    else {
        return @"分";
    }
}

#pragma mark - Getters And Setters
- (EHBabyAlarmModel *)alarmModel {
    if (!_alarmModel) {
        _alarmModel = [[EHBabyAlarmModel alloc]init];
        _alarmModel.work_date = [self showWorkDate];
        _alarmModel.is_active = @1;
        _alarmModel.is_repeat = @0;
        _alarmModel.time = [self showTime];
        _alarmModel.context =@"";
        EHLogInfo(@"self.alarmModel.date = %@",self.alarmModel.work_date);
    }
    return _alarmModel;
}


- (EHPickerView *)pickerView {
    if (!_pickerView) {
        
        _pickerView = [[EHPickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0)];
        _pickerView.rowHeight = [@"title" sizeWithFontSize:_pickerView.titleSize Width:MAXFLOAT].height + 27;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_pickerView reloadData];
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame) - 16, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = EHBgcor1;
    }
    return _tableView;
}

- (NSMutableArray *)hourArray {
    if (!_hourArray) {
        _hourArray = [[NSMutableArray alloc]init];
        NSString *hourStr;
        for (NSInteger i = 0; i < 24; i++) {
            hourStr = [NSString stringWithFormat:@"%.2ld",i];
            [_hourArray addObject:hourStr];
        }
    }
    return _hourArray;
}
- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        _minuteArray = [[NSMutableArray alloc]init];
        NSString *minStr;
        for (NSInteger i = 0; i < 60; i++) {
            minStr = [NSString stringWithFormat:@"%.2ld",i];
            [_minuteArray addObject:minStr];
        }
    }
    return _minuteArray;
}

- (NSString *)showWorkDate {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSLog(@"week = %ld",week);
    NSMutableString *workDateStr = [[NSMutableString alloc]initWithString:@"0000000"];
    [workDateStr replaceCharactersInRange:NSMakeRange(week - 1, 1) withString:@"1"];
    return workDateStr;
}

- (NSString *)showTime {
    
    NSString *showTime = [EHUtils stringFromDate:[NSDate date] withFormat:@"HH:mm"];
    NSArray *dateArray = [showTime componentsSeparatedByString:@":"];
    NSInteger hour = [dateArray[0] integerValue];
    NSInteger min = [dateArray[1] integerValue];
    
    showTime = [NSString stringWithFormat:@"%.2ld:%.2ld",hour,min];
    
    return showTime;
}


- (void)configAddBabyAlarmService{
    if (!_addBabyAlarmService) {
        _addBabyAlarmService =[EHAddBabyAlarmService new];
        WEAKSELF
        _addBabyAlarmService.serviceDidFinishLoadBlock =
        ^(WeAppBasicService *service){
            STRONGSELF
            [strongSelf hideLoadingView];
            strongSelf.addBlock(strongSelf.alarmModel);
            [WeAppToast toast:@"添加成功"];
            EHBabyAlarmModel *item = (EHBabyAlarmModel *)service.item;
            strongSelf.alarmModel.uuid = item.uuid;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _addBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"添加失败"];
        };
    }
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
