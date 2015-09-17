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

typedef NS_ENUM(NSInteger, EHGeofenceType){
    EHGeofenceTypeDetail = 0,   //围栏详情
    EHGeofenceTypeModify        //围栏可更新
};

@interface EHGeofenceDetailViewController ()

@property (nonatomic, strong)UIView *topDetailView;     //顶部视图

@property (nonatomic, strong)EHGeofenceRemindView *remindView;  //主动提醒视图

@end

@implementation EHGeofenceDetailViewController
{
    EHUpdateGeofenceService *_updateGeofenceService;    //更新接口
    EHDeleteGeofenceService *_deleteGeofenceService;    //删除接口
    NSString *_currentName;                             //当前围栏名称
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.hidden     = YES;
    self.sliderView.hidden  = YES;
    self.geofenceModifiedTag = NO;
    
    self.radius = self.geofenceInfo.geofence_radius;
    self.topView.geofenceName = self.geofenceInfo.geofence_name;
    self.geofenceCoordinate = CLLocationCoordinate2DMake(self.geofenceInfo.latitude, self.geofenceInfo.longitude);
    //    [self.mapView setCenterCoordinate:self.geofenceCoordinate];
    [self configNavigationBar];
    [self.view addSubview:self.topDetailView];
    [self.view addSubview:self.remindView];
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
        NSLog(@"index = %ld",index);
        if (index == 0) {
            [self changeGeofenceType:EHGeofenceTypeModify];
        }
        else {
            [self showDeleteGeofenceAlert];
        }
    }];
}

- (void)sureBtnClick:(id)sender{
    NSLog(@"sureBtnClick");
    NSString *geofenceName = [self.topView.geofenceName stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    geofenceName = [geofenceName stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.topView.geofenceName = geofenceName;
    
    if ((![_currentName isEqualToString:self.topView.geofenceName]) && [self.existedNameArray containsObject:self.topView.geofenceName]) {
        [WeAppToast toast:@"该围栏名字已经存在"];
        return;
    }
    _currentName = self.topView.geofenceName;
    [self configUpdateGeofenceService];
    [_updateGeofenceService updateGeofence:[self getInsertGeofenceReq]];
}

/**
 *  更改围栏状态（详情|可更改）
 */
- (void)changeGeofenceType:(EHGeofenceType)geofencetype{
    
    switch (geofencetype) {
        case EHGeofenceTypeModify:
        {
            //地图状态标志
            self.geofenceModifiedTag = YES;
            
            //视图显隐
            self.topView.hidden = NO;
            self.sliderView.hidden = NO;
            _currentName = self.topView.geofenceName;
            self.topView.alpha = 0;
            self.sliderView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.topDetailView.alpha = 0;
                self.topView.alpha = 1;
                self.sliderView.alpha = 1;
            } completion:^(BOOL finished) {
                self.topDetailView.hidden = YES;
            }];
            
            //顶部视图内容重定义
            UILabel *label;
            label = (UILabel *)([self.topDetailView viewWithTag:101]);
            self.topView.address = label.text;
            
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
            self.title = self.topView.geofenceName;
            //视图显隐
            self.topDetailView.hidden = NO;
            self.topDetailView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.topDetailView.alpha = 1;
                self.topView.alpha = 0;
                self.sliderView.alpha = 0;
            } completion:^(BOOL finished) {
                self.topView.hidden = YES;
                self.sliderView.hidden = YES;
            }];
            
            //导航栏右按钮
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreItemButtonClick:)];
            self.navigationItem.rightBarButtonItem = rightItem;
            
            //顶部视图内容重定义
            UILabel *label;
            label = (UILabel *)([self.topDetailView viewWithTag:101]);
            label.text = self.topView.address;
            label = (UILabel *)([self.topDetailView viewWithTag:102]);
            label.text = [NSString stringWithFormat:@"%ld米",self.radius];
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
    [_deleteGeofenceService deleteGeofenceByID:[NSNumber numberWithInt:self.geofenceInfo.geofence_id]];
}

#pragma mark - Getter And Setters
- (void)configNavigationBar{
    self.title = self.geofenceInfo.geofence_name;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreItemButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIView *)topDetailView{
    if (!_topDetailView) {
        CGFloat topDetailViewHeight = 85;
        _topDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), topDetailViewHeight)];
        _topDetailView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        CGFloat labelHeight = [@"text" sizeWithFontSize:EH_siz5 Width:MAXFLOAT].height;
        CGFloat upLabelY = ((topDetailViewHeight / 2.0) - labelHeight) / 2.0;
        CGFloat bottomLabelY = ((topDetailViewHeight / 2.0) - labelHeight) / 2.0 + (topDetailViewHeight / 2.0);

        
        UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, upLabelY, 75, labelHeight)];
        centerLabel.font = EH_font5;
        centerLabel.textColor = EH_cor3;
        centerLabel.textAlignment = NSTextAlignmentLeft;
        centerLabel.text = @"中心点：";
        
        //地址视图
        CGFloat addressLabelWidth = CGRectGetWidth(_topDetailView.frame) - 95 - 20;
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, upLabelY, addressLabelWidth, labelHeight)];
        addressLabel.font = EH_font5;
        addressLabel.tag = 101;
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.text = self.geofenceInfo.geofence_address;
        addressLabel.textColor = EH_cor4;
        
        UILabel *geofenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, bottomLabelY, 75, labelHeight)];
        geofenceLabel.font = EH_font5;
        geofenceLabel.textColor = EH_cor3;
        geofenceLabel.textAlignment = NSTextAlignmentLeft;
        geofenceLabel.text = @"围栏半径：";
        
        //半径视图
        UILabel *radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, bottomLabelY, CGRectGetWidth(addressLabel.frame), labelHeight)];
        radiusLabel.font = EH_font5;
        radiusLabel.textColor = EH_cor4;
        radiusLabel.tag = 102;
        radiusLabel.textAlignment = NSTextAlignmentLeft;
        radiusLabel.text = [NSString stringWithFormat:@"%d米",self.geofenceInfo.geofence_radius];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topDetailView.frame) / 2.0 - 0.5, CGRectGetWidth(_topDetailView.frame), 0.5)];
        lineView.backgroundColor = EH_linecor1;
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topDetailView.frame) - 0.5, CGRectGetWidth(_topDetailView.frame), 0.5)];
        lineView2.backgroundColor = EH_linecor1;
        
        [_topDetailView addSubview:centerLabel];
        [_topDetailView addSubview:addressLabel];
        [_topDetailView addSubview:geofenceLabel];
        [_topDetailView addSubview:radiusLabel];
        [_topDetailView addSubview:lineView];
        [_topDetailView addSubview:lineView2];
    }
    return _topDetailView;
}

- (UIButton *)sureBtn{
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.enabled = NO;
    return sureBtn;
}

/**
 *  配置更新接口
 */
- (void)configUpdateGeofenceService{
    typeof(self) __weak weakSelf = self;
    if (!_updateGeofenceService) {
        _updateGeofenceService = [EHUpdateGeofenceService new];
        _updateGeofenceService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            [[NSNotificationCenter defaultCenter] postNotificationName:EHGeofenceChangeNotification object:nil];
            [WeAppToast toast:@"更新成功！"];
            [weakSelf changeGeofenceType:EHGeofenceTypeDetail];
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
        _remindView = [[EHGeofenceRemindView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.topView.frame), CGRectGetWidth(self.topView.frame), CGRectGetHeight(self.topView.frame) / 2.0)];
        WEAKSELF
        _remindView.clickedBlock = ^(){
            STRONGSELF
            EHGeofenceRemindListViewController *grlVC = [[EHGeofenceRemindListViewController alloc]init];
            grlVC.babyUser = strongSelf.babyUser;
            grlVC.geofence_id = @(strongSelf.geofenceInfo.geofence_id);
            grlVC.geofenceName = strongSelf.topView.geofenceName;
            [strongSelf.navigationController pushViewController:grlVC animated:YES];
            EHLogInfo(@"EHGeofenceRemindView - clickedBlock");
        };
    }
    return _remindView;
}

/**
 *  获取围栏更新后信息
 */
- (EHGetGeofenceListRsp *)getInsertGeofenceReq{
    EHGetGeofenceListRsp *req = [[EHGetGeofenceListRsp alloc]init];
    
    req.geofence_name = self.topView.geofenceName;
    req.latitude = self.geofenceCoordinate.latitude;
    req.longitude = self.geofenceCoordinate.longitude;
    req.geofence_radius = (int)self.radius;
    req.geofence_id = self.geofenceInfo.geofence_id;
    req.geofence_address = self.topView.address;
    
    return req;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
