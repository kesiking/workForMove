//
//  EHBabyAlarmEditViewController.m
//  eHome
//
//  Created by jinmiao on 15/9/29.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyAlarmEditViewController.h"
#import "EHEditBabyAlarmService.h"
#import "EHDelBabyAlarmService.h"
#import "RMActionController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "EHPickerView.h"
#import "EHRemindDateTableViewCell.h"
#import "EHAlarmCommentTableViewCell.h"



@interface EHBabyAlarmEditViewController ()

@property (strong,nonatomic) EHPickerView *pickerView;
@property (strong,nonatomic) GroupedTableView *tableView;
@property (strong,nonatomic) NSMutableArray *hourArray;
@property (strong,nonatomic) NSMutableArray *minuteArray;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;


@end

@implementation EHBabyAlarmEditViewController

{
    EHEditBabyAlarmService *_editBabyAlarmService;
    EHDelBabyAlarmService *_delBabyAlarmService;
    EHBabyAlarmModel *_copyModel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view addSubview:[self deleteRemindButton]];
    self.title = @"编辑宝贝闹钟";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.view addSubview:self.tableView];
    //    [self hourArray];
    //    [self minuteArray];
    _copyModel = [self.alarmModel copy];
    self.alarmUpdated = NO;
    [self showWorkDate];
    self.view.backgroundColor=EHBgcor1;
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
    [_pickerView  selectRow:[dateArray[1] integerValue] inComponent:1 animated:YES];
}

-(BOOL)navigationShouldPopOnBackButton {
    [self resetAlarmModel];
    return YES;
}




#pragma mark - Events Response
- (void)doneBtnClicked {
//    if ([self.alarmModel.work_date isEqualToString:@"0000000"]) {
//        [WeAppToast toast:@"请选择日期"];
//        return;
//        
//    }
//    self.editBlock(self.alarmModel);
//    [self configUpdateAlarmService];
//    [_editBabyAlarmService editBabyAlarm:self.alarmModel];
//    [self showLoadingView];
    
    if (!self.alarmUpdated) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.alarmModel.work_date isEqualToString:@"0000000"]) {
        [WeAppToast toast:@"请选择日期"];
        return;
    }
    self.alarmModel.is_active = @1;
    [self configUpdateAlarmService];
    [_editBabyAlarmService editBabyAlarm:self.alarmModel];
    [self showLoadingView];
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
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"重复";
        cell.detailTextLabel.textColor = EHCor3;
        cell.detailTextLabel.font = EHFont2;
    }];
    
    repeatAction.titleColor = EH_cor4;
    
    RMAction *onceAction = [RMAction actionWithTitle:@"仅一次" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        strongSelf.alarmModel.is_repeat = @0;
        strongSelf.alarmUpdated = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"仅一次";
        cell.detailTextLabel.textColor = EHCor3;
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


- (void)showdeleteRemindAlert
{
    RMActionController* deleteRemindAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    deleteRemindAlert.title = @"删除宝贝闹钟提醒";
    deleteRemindAlert.titleColor = EH_cor5;
    deleteRemindAlert.titleFont = EH_font6;
    
    NSString *phone = [[KSLoginComponentItem sharedInstance] user_phone];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *alarmListDict = @{kEHBabyAlarmId:self.alarmModel.uuid};
    [arr addObject:alarmListDict];
    
    WEAKSELF
    RMAction *deleteRemindAction = [RMAction actionWithTitle:@"删除该提醒" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        //删除提醒
        STRONGSELF
        [strongSelf configDeleteAlarmService];
        [_delBabyAlarmService delBabyAlarm:arr byBabyId:strongSelf.babyUser.babyId andAdminPhone:phone];
        [strongSelf showLoadingView];
    }];
    
    deleteRemindAction.titleColor = EH_cor7;
    deleteRemindAction.titleFont = EH_font2;
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    [deleteRemindAlert addAction:deleteRemindAction];
    [deleteRemindAlert addAction:cancelAction];
    
    deleteRemindAlert.seperatorViewColor = EH_linecor1;
    
    deleteRemindAlert.contentView=[[UIView alloc]init];
    deleteRemindAlert.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:deleteRemindAlert.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [deleteRemindAlert.contentView addConstraint:heightConstraint];
    
    //You can enable or disable blur, bouncing and motion effects
    deleteRemindAlert.disableBouncingEffects = YES;
    deleteRemindAlert.disableMotionEffects = YES;
    deleteRemindAlert.disableBlurEffects = YES;
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:deleteRemindAlert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    else if(section == 1) return 2;
    else if(section == 2) return 1;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
//    if (indexPath.section == 0) {
//        EHAlarmHeaderTableViewCell *cell = [[EHAlarmHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        [cell configWithBabyInfo:self.babyUser];
//        return cell;
//    }
    if (indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:self.pickerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section ==1){
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
            cell.detailTextLabel.textColor = EHCor3;
            cell.detailTextLabel.font = EHFont2;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    else if(indexPath.section ==2)
    {
        EHAlarmCommentTableViewCell *cell = [[EHAlarmCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.commentTextView.text = self.alarmModel.context;
////        if (cell.commentTextView.text.length ==0) {
////            cell.commentTextView.text = @"输入备注内容";
////        }
//        cell.characterCountLable.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)cell.commentTextView.text.length];
        //cell.isTextViewEmpty = NO;
        cell.comment = self.alarmModel.context;
        cell.commentAddBlock = ^(NSString *comment){
          //  self.alarmModel.context = comment;
            self.alarmModel.context = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.alarmUpdated = YES;
        };
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        UILabel *deleteLabel = [[UILabel alloc]initWithFrame:cell.bounds];
        deleteLabel.text = @"删除该提醒";
        deleteLabel.font = EH_font2;
        deleteLabel.textColor = RGB(0xff, 0x3e, 0x3e);
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:deleteLabel];
        [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];

        return cell;

    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.pickerView.height;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CGFloat btnWidth = (CGRectGetWidth(tableView.frame) - 11 * 6 - 12 * 2) / 7;
            return (15 + [@"text" sizeWithFontSize:EH_siz2 Width:MAXFLOAT].height + 21 + btnWidth + 21);
        }
        else {
            return 44;
        }
    }
    else if (indexPath.section == 2) {
        return 108;
    }
    else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if (section <= 2) {
            return 12;
        }
        else return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self showFrequencyAlert];
        }
    }
        else if (indexPath.section == 3){
            [self showdeleteRemindAlert];
        }
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
//        _alarmModel.context =@"";
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


- (NSString *)showTime {
    
    NSString *showTime = [EHUtils stringFromDate:[NSDate date] withFormat:@"HH:mm"];
    NSArray *dateArray = [showTime componentsSeparatedByString:@":"];
    NSInteger hour = [dateArray[0] integerValue];
    NSInteger min = [dateArray[1] integerValue];
    
    showTime = [NSString stringWithFormat:@"%.2ld:%.2ld",hour,min];
    
    return showTime;
}

- (void)configDeleteAlarmService {
    if (!_delBabyAlarmService) {
        _delBabyAlarmService = [EHDelBabyAlarmService new];
        WEAKSELF
        _delBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                !strongSelf.deleteBlock?:strongSelf.deleteBlock(strongSelf.alarmModel);
            });

        };
        _delBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"删除失败"];
        };
    }
}

- (void)configUpdateAlarmService {
    if (!_editBabyAlarmService) {
        _editBabyAlarmService = [EHEditBabyAlarmService new];
        WEAKSELF
        _editBabyAlarmService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新成功"];
            strongSelf.editBlock(strongSelf.alarmModel);
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        _editBabyAlarmService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"更新失败"];
        };
    }
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

- (void)resetAlarmModel {
    //self.alarmModel.geofence_id = _copyModel.geofence_id;
    //self.remindModel.geofence_baby_id = _copyModel.geofence_baby_id;
    self.alarmModel.context = _copyModel.context;
    self.alarmModel.time = _copyModel.time;
    self.alarmModel.work_date = _copyModel.work_date;
    self.alarmModel.is_active = _copyModel.is_active;
    self.alarmModel.is_repeat = _copyModel.is_repeat;
    self.alarmModel.uuid = _copyModel.uuid;
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
