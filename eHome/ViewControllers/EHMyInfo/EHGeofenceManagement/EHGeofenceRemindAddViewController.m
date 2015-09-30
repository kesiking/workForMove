//
//  EHGeofenceRemindAddViewController.m
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceRemindAddViewController.h"
#import "EHInsertGeofenceRemindService.h"

@interface EHGeofenceRemindAddViewController ()

@end

@implementation EHGeofenceRemindAddViewController
{
    EHInsertGeofenceRemindService *_insertRemindService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Events Response
- (void)sureItemClick {
    if ([self.remindModel.work_date isEqualToString:@"0000000"]) {
        [WeAppToast toast:@"请选择日期"];
        return;
    }

    //添加围栏请求
    [self configInsertRemindService];
    [_insertRemindService insertGeofenceRemind:self.remindModel];
    [self showLoadingView];
}

- (void)configInsertRemindService {
    if (!_insertRemindService) {
        _insertRemindService = [EHInsertGeofenceRemindService new];
        WEAKSELF
        _insertRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"添加成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
            strongSelf.remindModel.uuid = [service.requestModel.item.componentDict objectForKey:@"responseData"];
            !strongSelf.remindNeedAdd?:strongSelf.remindNeedAdd(strongSelf.remindModel);

        };
        _insertRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
            [WeAppToast toast:@"添加失败"];
        };
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
