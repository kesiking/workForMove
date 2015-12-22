//
//  EHBaseGeofenceRemindViewController.m
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseGeofenceRemindViewController.h"
#import "EHRemindDateTableViewCell.h"
#import "EHBabyDetailTableViewCell.h"
#import "RMActionController.h"
#import "EHPickerView.h"

#define kRowHeight 50

@interface EHBaseGeofenceRemindViewController ()<EHPickerViewDataSource,EHPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)GroupedTableView *tableView;

@property (nonatomic, strong)EHPickerView     *pickerView;

@property (nonatomic, strong)NSMutableArray   *hourArray;

@property (nonatomic, strong)NSMutableArray   *minArray;

@end

@implementation EHBaseGeofenceRemindViewController
{
    
}

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EHBgcor1;
    
    [self.view addSubview:self.tableView];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.remindUpdated = NO;
    [self showWorkDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *dateArray = [self.remindModel.time componentsSeparatedByString:@":"];
    [_pickerView  selectRow:[dateArray[0] integerValue] inComponent:0 animated:YES];
    [_pickerView  selectRow:[dateArray[1] integerValue] inComponent:1 animated:YES];

}

#pragma mark - Events Response
//确定按钮。子类重载。
- (void)sureItemClick {
    if (!self.remindUpdated) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
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
        strongSelf.remindModel.is_repeat = @1;
        strongSelf.remindUpdated = YES;

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        UITableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"重复";
    }];
    
    repeatAction.titleColor = EH_cor4;
    
    RMAction *onceAction = [RMAction actionWithTitle:@"仅一次" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        strongSelf.remindModel.is_repeat = @0;
        strongSelf.remindUpdated = YES;

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        UITableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"仅一次";
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

/**
 *  删除提醒。子类重载。
 */
- (void)showdeleteRemindAlert {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.remindStatusType == EHRemindStatusTypeAdd) {
        return 3;
    }
    else return 4;
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
        
        EHBabyDetailTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHBabyDetailTableViewCell class]) owner:self options:nil] firstObject];;
        
        UIImage *defaultHeadImage = [UIImage imageNamed:@"headportrait_boy_160"];
        NSURL *imageUrl = [NSURL URLWithString:self.babyUser.babyHeadImage];
        [cell.babyHeadImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUser.babyId newPlaceHolderImagePath:self.babyUser.babyHeadImage defaultHeadImage:defaultHeadImage]];
        
        cell.babyNameLabel.text = self.babyUser.babyNickName;
        cell.babyDetalLabel.text = [NSString stringWithFormat:@"围栏：%@",self.geofenceName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:self.pickerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            EHRemindDateTableViewCell *cell = [[EHRemindDateTableViewCell alloc]init];
            [cell selectWorkDate:self.remindModel.work_date];
            cell.dateBtnClickBlock = ^(NSString *dateStr){
                self.remindModel.work_date = dateStr;
                self.remindUpdated = YES;
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = @"频率";
            cell.textLabel.font = EHFont2;
            cell.textLabel.textColor = EHCor5;
            cell.detailTextLabel.text = [self.remindModel.is_repeat boolValue]?@"重复":@"仅一次";
            cell.detailTextLabel.font = EHFont2;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
        UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        deleteLabel.text = @"删除该提醒";
        deleteLabel.font = EHFont2;
        deleteLabel.textColor = EHCor22;
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:deleteLabel];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
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
    if (indexPath.section == 2) {
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
    else return self.minArray.count;
}

#pragma mark - EHPickerViewDelegate
- (void)pickerView:(nonnull EHPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSMutableString *muStr = [self.remindModel.time mutableCopy];
    if (component == 0) {
        NSRange range = NSMakeRange(0, 2);
        [muStr replaceCharactersInRange:range withString:self.hourArray[row]];
    }
    else {
        NSRange range = NSMakeRange(3, 2);
        [muStr replaceCharactersInRange:range withString:self.minArray[row]];
    }
    self.remindModel.time = (NSString *)muStr;
    self.remindUpdated = YES;
}

- (nullable NSString *)pickerView:(nonnull EHPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.hourArray[row];
    }
    else {
        return self.minArray[row];
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
- (EHGeofenceRemindModel *)remindModel {
    if (!_remindModel) {
        _remindModel = [[EHGeofenceRemindModel alloc]init];
        _remindModel.work_date = [self showWorkDate];
        _remindModel.is_active = @1;
        _remindModel.is_repeat = @0;
        _remindModel.time = [self showTime];
    }
    return _remindModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame) - 16, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
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

- (NSMutableArray *)minArray {
    if (!_minArray) {
        _minArray = [[NSMutableArray alloc]init];
        NSString *minStr;
        for (NSInteger i = 0; i < 60; i++) {
            minStr = [NSString stringWithFormat:@"%.2ld",i];
            [_minArray addObject:minStr];
        }
    }
    return _minArray;
}

- (NSString *)showWorkDate {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps;// = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSLog(@"week = %ld",week);
    NSMutableString *workDateStr = [[NSMutableString alloc]initWithString:@"0000000"];
    [workDateStr replaceCharactersInRange:NSMakeRange(week - 1, 1) withString:@"1"];
    NSString *changedWorkDate = [NSString stringWithFormat:@"%@%@",[workDateStr substringFromIndex:1],[workDateStr substringToIndex:1]];
    workDateStr = [changedWorkDate mutableCopy];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
