//
//  EHSettingViewController.m
//  eHome
//
//  Created by xtq on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSettingViewController.h"
#import "EHMyInfoViewController.h"
#import "SevenSwitch.h"

#define kEHShakeNoticeKey @"shakeNoticeKey"     //震动
#define kEHVoiceNoticeKey @"voiceNoticeKey"     //声音
#define kEHNoticeKey @"noticeKey"               //通知提醒
#define kCellHeight     50
#define kHeaderViewHeight 30
#define kSwitchTag 100

@interface EHSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EHSettingViewController
{
    UITableView *_tableView;
    NSMutableArray *_titleArray;
    NSMutableArray *_sliderStatueArray;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    _titleArray = [[NSMutableArray alloc]initWithObjects:@"接受信息通知", @"震动", @"声音", nil];
    _sliderStatueArray = [self arrayOfNotice];
    if(![_sliderStatueArray[0] boolValue]) {
        [_titleArray removeLastObject];
        [_titleArray removeLastObject];
    }
    
    [self.view addSubview:[self tableView]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else {
        return _titleArray.count - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    for (int i = 0; i < 3; i++) {
        if ([cell.contentView viewWithTag:kSwitchTag + i]) {
            [[cell.contentView viewWithTag:kSwitchTag + i] removeFromSuperview];
        }
    }
    cell.textLabel.text = _titleArray[indexPath.section + indexPath.row];
    [cell.contentView addSubview:[self switchWithTag:indexPath.section + indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), [self tableView: _tableView heightForFooterInSection:section])];
        NSString *text = @"关闭接受消息通知，您将无法接收“宝贝进出围栏”、“设备低电量报警”等通知信息。";
        
        CGFloat spaceX = tableView.separatorInset.left;
        
        UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, 10, CGRectGetWidth(_tableView.frame) - spaceX * 2, 25)];
        warnLabel.text = text;
        warnLabel.textColor = EH_cor4;
        warnLabel.font = EH_font6;
        warnLabel.textAlignment = NSTextAlignmentLeft;
        warnLabel.lineBreakMode = NSLineBreakByWordWrapping;
        warnLabel.numberOfLines = 0;
        [warnLabel sizeToFit];
        EHLogInfo(@"warnLabel height = %f",warnLabel.frame.size.height);
        [footerView addSubview:warnLabel];
        
        return footerView;
    }
    else return nil;
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Events Response
- (void)switchChanged:(id)sender{
    SevenSwitch *swit = (SevenSwitch *)sender;
    _sliderStatueArray[swit.tag - kSwitchTag] = [NSNumber numberWithBool:swit.on];

    if (swit.on == YES) {
        swit.knobColor = [UIColor colorWithRed:92/255.0 green:176/255.0 blue:65/255.0 alpha:1];
    }
    else {
        swit.knobColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:180/255.0 alpha:1];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (swit.tag == kSwitchTag) {
        //提醒开关
        for (int i = 0; i <= 1; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:1];
            [array addObject:indexpath];
        }
        if (swit.on) {
            
            [_titleArray addObject:@"震动"];
            [_titleArray addObject:@"声音"];
            
            [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        }
        else  {
            [_titleArray removeObject:@"震动"];
            [_titleArray removeObject:@"声音"];
            
            [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        }
        
        //更新震动和声音处理
        [self updateNotice:swit.on];
    }
    else if (swit.tag == kSwitchTag + 1){
        //震动
        [self updateShakeNotice:swit.on];
    }
    else if (swit.tag == kSwitchTag + 2){
        //声音
        [self updateVoiceNotice:swit.on];
    }
}

#pragma mark - Common Methods
- (NSMutableArray *)arrayOfNotice{
    NSNumber *shakeNumber,*voiceNumber,*noticeNumber;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //通知提醒
    if ([userDefaults objectForKey:kEHNoticeKey]) {
        noticeNumber = [userDefaults objectForKey:kEHNoticeKey];
    }
    else{
        noticeNumber = @YES;
        [userDefaults setObject:noticeNumber forKey:kEHNoticeKey];
    }
    EHLogInfo(@"kEHNoticeKey = %@",noticeNumber);
    //震动
    if ([userDefaults objectForKey:kEHShakeNoticeKey]) {
        shakeNumber = [userDefaults objectForKey:kEHShakeNoticeKey];
    }
    else{
        shakeNumber = @YES;
        [userDefaults setObject:shakeNumber forKey:kEHShakeNoticeKey];
    }
    EHLogInfo(@"kEHShakeNoticeKey = %@",shakeNumber);
    //声音
    if ([userDefaults objectForKey:kEHVoiceNoticeKey]) {
        voiceNumber = [userDefaults objectForKey:kEHVoiceNoticeKey];
    }
    else{
        voiceNumber = @YES;
        [userDefaults setObject:voiceNumber forKey:kEHVoiceNoticeKey];
    }
    EHLogInfo(@"kEHVoiceNoticeKey = %@",voiceNumber);

    return [NSMutableArray arrayWithObjects:noticeNumber,shakeNumber,voiceNumber, nil];
}

/**
 *  通知提醒
 */
- (void)updateNotice:(BOOL)open{
    EHLogInfo(@"shake open? %d",open);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:open] forKey:kEHNoticeKey];
    [userDefaults synchronize];
}

/**
 *  震动
 */
- (void)updateShakeNotice:(BOOL)open{
    EHLogInfo(@"shake open? %d",open);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:open] forKey:kEHShakeNoticeKey];
    [userDefaults synchronize];
}

/**
 *  声音
 */
- (void)updateVoiceNotice:(BOOL)open{
    EHLogInfo(@"voice open? %d",open);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:open] forKey:kEHVoiceNoticeKey];
    [userDefaults synchronize];
}

#pragma mark - Getters And Setters
- (UITableView *)tableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.rowHeight = kCellHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    return _tableView;
}

- (SevenSwitch *)switchWithTag:(NSInteger)tag{
    SevenSwitch *swit = [[SevenSwitch alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 20 - 50, 12.5, 50, 25)];
    swit.onColor = [UIColor colorWithRed:168/255.0 green:216/255.0 blue:152/255.0 alpha:1];
    swit.knobColor = [UIColor colorWithRed:92/255.0 green:176/255.0 blue:65/255.0 alpha:1];
    swit.inactiveColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:217/255.0 alpha:1];
    EHLogInfo(@"_sliderStatueArray.tag = %@",_sliderStatueArray[tag]);
    swit.on = [_sliderStatueArray[tag] boolValue];
    swit.tag = kSwitchTag + tag;
    if (swit.on == YES) {
        swit.knobColor = [UIColor colorWithRed:92/255.0 green:176/255.0 blue:65/255.0 alpha:1];
    }
    else {
        swit.knobColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:180/255.0 alpha:1];
    }
    [swit addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    return swit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
