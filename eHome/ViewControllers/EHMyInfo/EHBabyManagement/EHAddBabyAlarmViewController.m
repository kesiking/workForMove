//
//  EHAddBabyAlarmViewController.m
//  eHome
//
//  Created by jinmiao on 15/9/8.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAddBabyAlarmViewController.h"
#import "EHAddBabyAlarmService.h"


@interface EHAddBabyAlarmViewController ()

@end

@implementation EHAddBabyAlarmViewController
{
    EHAddBabyAlarmService *_addBabyAlarmService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Events Response
- (void)doneBtnClicked {
    if ([self.alarmModel.work_date isEqualToString:@"0000000"]) {
        [WeAppToast toast:@"请选择日期"];
        return;
    }
    [self configAddBabyAlarmService];
    //self.alarmModel.clock_index = [NSNumber numberWithInteger:self.babyAlarmList.count+1];
    self.alarmModel.baby_id = self.babyUser.babyId;
    [_addBabyAlarmService addBabyAlarm:self.alarmModel];
    EHLogInfo(@"alarmlist.count = %lu",(unsigned long)self.babyAlarmList.count);
    self.addBlock(self.alarmModel);
}

- (void)configAddBabyAlarmService{
    if (!_addBabyAlarmService) {
        _addBabyAlarmService =[EHAddBabyAlarmService new];
        WEAKSELF
        _addBabyAlarmService.serviceDidFinishLoadBlock =
        ^(WeAppBasicService *service){
            STRONGSELF
            [strongSelf hideLoadingView];
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
