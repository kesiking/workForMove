//
//  EHBaseBabyAlarmViewController.m
//  eHome
//
//  Created by jinmiao on 15/9/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseBabyAlarmViewController.h"
#import "EHRemindDateTableViewCell.h"
#import "EHAlarmCommentTableViewCell.h"
#import "RMActionController.h"
#import "UIViewController+BackButtonHandler.h"
#import "NSString+StringSize.h"
#import "EHPickerView.h"
#import "EHAlarmHeaderView.h"

#define kRowHeight 50


@interface EHBaseBabyAlarmViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) BOOL alarmUpdated;
@property (strong,nonatomic) UIPickerView *pickerView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *hourArray;
@property (strong,nonatomic) NSMutableArray *minuteArray;

@end

@implementation EHBaseBabyAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加宝贝提醒";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.tableView];
    [self hourArray];
    [self minuteArray];

    self.alarmUpdated = NO;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *dateArray = [self.alarmModel.time componentsSeparatedByString:@":"];
    [_pickerView  selectRow:[dateArray[0] integerValue] inComponent:0 animated:YES];
    [_pickerView  selectRow:([dateArray[1] integerValue] / 10) inComponent:2 animated:YES];
}

# pragma mark - Events Response
- (void)doneBtnClicked {
    EHLogInfo(@"base - sureItemClick");
}

- (void)showFrequencyAlert
{
    
    RMActionController* frequencyVC = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    
    WEAKSELF
    RMAction *repeatAction = [RMAction actionWithTitle:@"重复" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        strongSelf.alarmModel.is_repeat = @1;
        strongSelf.alarmUpdated = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"重复";
    }];
    
    repeatAction.titleColor = EH_cor4;
    
    RMAction *onceAction = [RMAction actionWithTitle:@"仅一次" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        strongSelf.alarmModel.is_repeat = @0;
        strongSelf.alarmUpdated = YES;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
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


//- (void)showReturnAlert
//{
//    RMActionController* returnAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
//    returnAlert.title = @"主动提醒状态尚未保存，是否确定返回？";
//    returnAlert.titleColor = EH_cor5;
//    returnAlert.titleFont = EH_font6;
//    
//    WEAKSELF
//    RMAction *returnAction = [RMAction actionWithTitle:@"不保存并返回" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
//        STRONGSELF
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [strongSelf.navigationController popViewControllerAnimated:YES];
//        });
//    }];
//    
//    returnAction.titleColor = EH_cor7;
//    returnAction.titleFont = EH_font2;
//    
//    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
//        
//    }];
//    
//    cancelAction.titleColor = EH_cor4;
//    cancelAction.titleFont = EH_font2;
//    
//    [returnAlert addAction:returnAction];
//    [returnAlert addAction:cancelAction];
//    
//    returnAlert.seperatorViewColor = EH_linecor1;
//    
//    returnAlert.contentView=[[UIView alloc]init];
//    returnAlert.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:returnAlert.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
//    [returnAlert.contentView addConstraint:heightConstraint];
//    
//    //You can enable or disable blur, bouncing and motion effects
//    returnAlert.disableBouncingEffects = YES;
//    returnAlert.disableMotionEffects = YES;
//    returnAlert.disableBlurEffects = YES;
//    
//    //Now just present the date selection controller using the standard iOS presentation method
//    [self presentViewController:returnAlert animated:YES completion:nil];
//}

//#pragma mark - BackButtonHandlerProtocol
//-(BOOL) navigationShouldPopOnBackButton
//{
//    if (self.alarmUpdated) {
//        [self showReturnAlert];
//    }
//    else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    return NO;
//}

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


#pragma mark - UIPickerViewDelegate

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

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.alarmStatusType == EHBabyAlarmStatusTypeAdd) {
        return 3;
    }
    else return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    else if(section == 1) return 2;
    else if(section == 2) return 1;
    else return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    if (indexPath.section ==0) {
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
            cell.detailTextLabel.text = [self.alarmModel.is_repeat boolValue]?@"重复":@"仅一次";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    else if (indexPath.section==2){
        EHAlarmCommentTableViewCell *cell = [[EHAlarmCommentTableViewCell alloc]init];
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
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EHAlarmHeaderView *alarmHeaderView = [[EHAlarmHeaderView alloc]initWithFrame:CGRectMake(8, 12, self.view.width-16, 81)];
    return alarmHeaderView;
    
}


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
        return 220;
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






//显示当前时间
- (NSString *)showTime {
    
    NSString *showTime = [EHUtils stringFromDate:[NSDate date] withFormat:@"HH:mm"];
    NSArray *dateArray = [showTime componentsSeparatedByString:@":"];
    NSInteger hour = [dateArray[0] integerValue];
    NSInteger min = [dateArray[1] integerValue];
    
    if ((min % 10) != 0) {
        min = ((min / 10) + 1) * 10;
    }
    if (min == 60) {
        min = 0;
        hour = (hour + 1) % 24;
    }
    
    showTime = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)hour,(long)min];
    
    return showTime;
}


#pragma mark - setter and getter

- (EHBabyAlarmModel *)alarmModel {
    if (!_alarmModel) {
        _alarmModel = [[EHBabyAlarmModel alloc]init];
        _alarmModel.work_date = @"0000000";
        _alarmModel.is_active = @1;
        _alarmModel.is_repeat = @1;
        _alarmModel.time = [self showTime];
        EHLogInfo(@"self.alarmModel.date = %@",self.alarmModel.work_date);
    }
    return _alarmModel;
}


- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        UIBezierPath *bp = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(_pickerView.frame), 0.1)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetHeight(_pickerView.frame) - 0.1, CGRectGetWidth(_pickerView.frame), 0.1);
        layer.path = bp.CGPath;
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        [_pickerView.layer addSublayer:layer];
    }
    return _pickerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pickerView.frame), CGRectGetWidth(self.view.frame), kRowHeight * 4) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)hourArray {
    if (!_hourArray) {
        _hourArray = [[NSMutableArray alloc]init];
        NSString *hourStr;
        for (NSInteger i = 0; i < 24; i++) {
            hourStr = [NSString stringWithFormat:@"%.2ld",(long)i];
            [_hourArray addObject:hourStr];
        }
    }
    return _hourArray;
}

- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        _minuteArray = [[NSMutableArray alloc]init];
        NSString *minStr;
        for (NSInteger i = 0; i < 6; i++) {
            if (i == 0) {
                minStr = [NSString stringWithFormat:@"0%ld",(long)i];
            }
            else {
                minStr = [@(i * 10) stringValue];
            }
            [_minuteArray addObject:minStr];
        }
    }
    return _minuteArray;
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
