//
//  EHGeofenceDetailViewController.m
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceDetailViewController.h"
#import "EHPopMenuLIstView.h"
#import "EHUpdateGeofenceService.h"
#import "EHDeleteGeofenceService.h"
#import "RMActionController.h"
#import "EHGeofenceRemindView.h"
#import "EHGeofenceRemindListViewController.h"
#import "NSString+StringSize.h"
#import "EHGeofenceAddressAndRadiusView.h"

typedef NS_ENUM(NSInteger, EHGeofenceType){
    EHGeofenceTypeDetail = 0,   //围栏详情
    EHGeofenceTypeModify        //围栏可更新
};

@interface EHGeofenceDetailViewController ()

@property (nonatomic, strong)EHGeofenceRemindView *remindView;  //主动提醒视图

@property (nonatomic, strong)EHGeofenceAddressAndRadiusView *addressAndRadiusView;  //底动中心点及半径视图

@end

@implementation EHGeofenceDetailViewController
{
    EHUpdateGeofenceService *_updateGeofenceService;    //更新接口
    EHDeleteGeofenceService *_deleteGeofenceService;    //删除接口
    NSString *_currentName;                             //当前围栏名称
    NSString *_previousName;                            //更新之前的围栏名称
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.geofenceNameView.hidden = YES;
    self.geofenceAddressView.hidden = YES;
    self.sliderView.hidden  = YES;
    self.geofenceModifiedTag = NO;
    
    [self configNavigationBar];
    [self.view addSubview:self.remindView];
    [self.view addSubview:self.addressAndRadiusView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.remindView showCountWithGeofenceID:@(self.geofenceInfo.geofence_id)];
}

#pragma mark - Events Response
/**
 *  下拉框（编辑围栏、取消围栏）
 */
- (void)moreItemButtonClick:(id)sender{
    [EHPopMenuLIstView showMenuViewWithTitleTextArray:@[@"编辑围栏",@"取消围栏"] menuSelectedBlock:^(NSUInteger index, EHPopMenuModel *selectItem) {
        if (index == 0) {
            [self changeGeofenceType:EHGeofenceTypeModify];
        }
        else {
            [self showDeleteGeofenceAlert];
        }
    }];
}

- (void)sureBtnClick:(id)sender{
    NSString *geofenceName = [self.geofenceNameView.geofenceName stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    geofenceName = [geofenceName stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.geofenceNameView.geofenceName = geofenceName;
    
    //保存围栏之前的值，之后在existedNameArray移除_previousName
    _previousName = _currentName;
    
    if ((![_currentName isEqualToString:self.geofenceNameView.geofenceName]) && [self.existedNameArray containsObject:self.geofenceNameView.geofenceName]) {
        [WeAppToast toast:@"该围栏名字已经存在"];
        return;
    }
    _currentName = self.geofenceNameView.geofenceName;
    [self configUpdateGeofenceService];
    [_updateGeofenceService updateGeofence:[self getInsertGeofenceReq]];
}

/**
 *  更改围栏状态及视图UI显示情况（详情|可更改）
 */
- (void)changeGeofenceType:(EHGeofenceType)geofencetype{
    
    switch (geofencetype) {
        case EHGeofenceTypeModify:
        {
            //地图状态标志
            self.geofenceModifiedTag = YES;
            
            //视图显隐
            self.geofenceNameView.hidden = NO;
            self.geofenceAddressView.hidden = NO;
            self.sliderView.hidden = NO;
            self.geofenceNameView.alpha = 0;
            self.geofenceAddressView.alpha = 0;
            self.sliderView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.geofenceNameView.alpha = 1;
                self.geofenceAddressView.alpha = 1;
                self.sliderView.alpha = 1;
                self.remindView.alpha = 0;
                self.addressAndRadiusView.alpha = 0;

            } completion:^(BOOL finished) {
                self.remindView.hidden = YES;
                self.addressAndRadiusView.hidden = YES;
            }];
            
            _currentName = self.geofenceNameView.geofenceName;

            //视图内容重定义
            self.geofenceAddressView.address = self.geofenceInfo.geofence_address;
            self.geofenceNameView.geofenceName = self.geofenceInfo.geofence_name;
            self.title = @"编辑围栏";
            
            //导航栏右按钮
            self.rightItemButton = [self sureBtn];
            UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightItemButton];
            self.navigationItem.rightBarButtonItem = rigthItem;
            self.rightItemButton.enabled = NO;
        }
            break;
            
        case EHGeofenceTypeDetail:
        {
            //地图状态标志
            self.geofenceModifiedTag = NO;
            
            //视图显隐
            self.remindView.hidden = NO;
            self.remindView.alpha = 0;
            self.addressAndRadiusView.hidden = NO;
            self.addressAndRadiusView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.remindView.alpha = 1;
                self.addressAndRadiusView.alpha = 1;
                self.geofenceNameView.alpha = 0;
                self.geofenceAddressView.alpha = 0;
                self.sliderView.alpha = 0;
            } completion:^(BOOL finished) {
                self.geofenceNameView.hidden = YES;
                self.geofenceAddressView.hidden = YES;
                self.sliderView.hidden = YES;
            }];
            
            //视图内容重定义
            self.addressAndRadiusView.address = self.geofenceInfo.geofence_address;
            self.addressAndRadiusView.radius = self.geofenceInfo.geofence_radius;
            self.title = self.geofenceInfo.geofence_name;

            //导航栏右按钮
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreItemButtonClick:)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
        default:
            break;
    }
}

- (void)showDeleteGeofenceAlert
{
    RMActionController* unbindAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    unbindAlert.title = @"删除安全围栏后，宝贝进出该区域将不再提醒";
    unbindAlert.titleColor = EH_cor5;
    unbindAlert.titleFont = EH_font6;
    
    WEAKSELF
    RMAction *unbindAction = [RMAction actionWithTitle:@"删除安全围栏" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        STRONGSELF
        [strongSelf deleteGeofence];
    }];
    
    unbindAction.titleColor = EH_cor7;
    unbindAction.titleFont = EH_font2;
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    [unbindAlert addAction:unbindAction];
    [unbindAlert addAction:cancelAction];
    
    unbindAlert.seperatorViewColor = EH_linecor1;
    
    unbindAlert.contentView=[[UIView alloc]init];
    unbindAlert.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:unbindAlert.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [unbindAlert.contentView addConstraint:heightConstraint];
    
    //You can enable or disable blur, bouncing and motion effects
    unbindAlert.disableBouncingEffects = YES;
    unbindAlert.disableMotionEffects = YES;
    unbindAlert.disableBlurEffects = YES;
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:unbindAlert animated:YES completion:nil];
}

- (void)deleteGeofence{
    [self configDeleteGeofenceService];
    [_deleteGeofenceService deleteGeofenceByID:[NSNumber numberWithInteger:self.geofenceInfo.geofence_id]];
}

#pragma mark - Getter And Setters
- (void)configNavigationBar{
    self.title = self.geofenceInfo.geofence_name;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreItemButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIButton *)sureBtn{
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:EHCor6 forState:UIControlStateNormal];
    [sureBtn setTitleColor:EHCor2 forState:UIControlStateDisabled];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.enabled = NO;
    return sureBtn;
}

/**
 *  配置更新接口
 */
- (void)configUpdateGeofenceService{
    if (!_updateGeofenceService) {
        _updateGeofenceService = [EHUpdateGeofenceService new];
        WEAKSELF
        _updateGeofenceService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [[NSNotificationCenter defaultCenter] postNotificationName:EHGeofenceChangeNotification object:nil];
            //更新existedNameArray
            [strongSelf.existedNameArray removeObject: strongSelf->_previousName];
            [strongSelf.existedNameArray addObject:strongSelf->_currentName];
            [WeAppToast toast:@"更新成功！"];
            strongSelf.geofenceInfo = [strongSelf getInsertGeofenceReq];
            [strongSelf changeGeofenceType:EHGeofenceTypeDetail];
        };
        _updateGeofenceService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"更新失败！"];
        };
    }
}

/**
 *  配置删除接口
 */
- (void)configDeleteGeofenceService{
    typeof(self) __weak weakSelf = self;
    if (!_deleteGeofenceService) {
        _deleteGeofenceService = [EHDeleteGeofenceService new];
        _deleteGeofenceService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            [[NSNotificationCenter defaultCenter] postNotificationName:EHGeofenceChangeNotification object:nil];
            [WeAppToast toast:@"删除成功！"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _deleteGeofenceService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"删除失败！"];
        };
    }
}


- (EHGeofenceRemindView *)remindView{
    if (!_remindView) {
        _remindView = [[EHGeofenceRemindView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 43)];
        WEAKSELF
        _remindView.clickedBlock = ^(){
            STRONGSELF
            EHGeofenceRemindListViewController *grlVC = [[EHGeofenceRemindListViewController alloc]init];
            grlVC.babyUser = strongSelf.babyUser;
            grlVC.geofence_id = @(strongSelf.geofenceInfo.geofence_id);
            grlVC.geofenceName = strongSelf.geofenceInfo.geofence_name;
            [strongSelf.navigationController pushViewController:grlVC animated:YES];
        };
    }
    return _remindView;
}

- (EHGeofenceAddressAndRadiusView *)addressAndRadiusView{
    if (!_addressAndRadiusView) {
        _addressAndRadiusView = [[EHGeofenceAddressAndRadiusView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame), 60)];
        _addressAndRadiusView.address = self.geofenceInfo.geofence_address;
        _addressAndRadiusView.radius = self.geofenceInfo.geofence_radius;
    }
    return _addressAndRadiusView;
}

/**
 *  获取围栏更新后信息
 */
- (EHGetGeofenceListRsp *)getInsertGeofenceReq{
    EHGetGeofenceListRsp *req = [[EHGetGeofenceListRsp alloc]init];
    
    req.geofence_name    = self.geofenceNameView.geofenceName;
    req.geofence_radius  = self.sliderView.radius;
    req.geofence_address = self.geofenceAddressView.address;
    req.geofence_id      = self.geofenceInfo.geofence_id;
    req.latitude         = self.geofenceCoordinate.latitude;
    req.longitude        = self.geofenceCoordinate.longitude;
    
    return req;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
