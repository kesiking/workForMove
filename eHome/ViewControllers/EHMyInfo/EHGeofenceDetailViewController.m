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

typedef NS_ENUM(NSInteger, EHGeofenceType){
    EHGeofenceTypeDetail = 0,   //围栏详情
    EHGeofenceTypeModify        //围栏可更新
};

@interface EHGeofenceDetailViewController ()

@property (nonatomic, strong)UIView *topDetailView;     //顶部视图

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
    
    [self setGeofenceRadius:self.geofenceInfo.geofence_radius];
    self.geofenceNameField.text = self.geofenceInfo.geofence_name;
    self.geofenceCoordinate = CLLocationCoordinate2DMake(self.geofenceInfo.latitude, self.geofenceInfo.longitude);
//    [self.mapView setCenterCoordinate:self.geofenceCoordinate];
    [self configNavigationBar];
    [self.view addSubview:self.topDetailView];
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
            [self configDeleteGeofenceService];
            [_deleteGeofenceService deleteGeofenceByID:[NSNumber numberWithInt:self.geofenceInfo.geofence_id]];
        }
    }];
}

- (void)sureBtnClick:(id)sender{
    NSLog(@"sureBtnClick");

    if ((![_currentName isEqualToString:self.geofenceNameField.text]) && [self.existedNameArray containsObject:self.geofenceNameField.text]) {
        [WeAppToast toast:@"该围栏名字已经存在"];
        return;
    }
    _currentName = self.geofenceNameField.text;
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
            _currentName = self.geofenceNameField.text;
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
            self.addressLabel.text = label.text;
            
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
            self.title = self.geofenceNameField.text;
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
            label.text = self.addressLabel.text;
            label = (UILabel *)([self.topDetailView viewWithTag:102]);
            label.text = [NSString stringWithFormat:@"%ld米",self.radius];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Getter And Setters
- (void)configNavigationBar{
    self.title = self.geofenceInfo.geofence_name;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreItemButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIView *)topDetailView{
    if (!_topDetailView) {
        _topDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 85)];
        _topDetailView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 75, 9)];
        centerLabel.font = EH_font5;
        centerLabel.textColor = EH_cor3;
        centerLabel.textAlignment = NSTextAlignmentLeft;
        centerLabel.text = @"中心点：";
        
        //地址视图
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 15, CGRectGetWidth(_topDetailView.frame) - 95 - 20, 9)];
        addressLabel.font = EH_font5;
        addressLabel.tag = 101;
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.text = self.geofenceInfo.geofence_address;
        addressLabel.textColor = EH_cor4;

        UILabel *geofenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 59, 75, 9)];
        geofenceLabel.font = EH_font5;
        geofenceLabel.textColor = EH_cor3;
        geofenceLabel.textAlignment = NSTextAlignmentLeft;
        geofenceLabel.text = @"围栏半径：";
        
        //半径视图
        UILabel *radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 59, CGRectGetWidth(addressLabel.frame), 9)];
        radiusLabel.font = EH_font5;
        radiusLabel.textColor = EH_cor4;
        radiusLabel.textAlignment = NSTextAlignmentLeft;
        radiusLabel.text = [NSString stringWithFormat:@"%d米",self.geofenceInfo.geofence_radius];
        
        [_topDetailView addSubview:centerLabel];
        [_topDetailView addSubview:addressLabel];
        [_topDetailView addSubview:geofenceLabel];
        [_topDetailView addSubview:radiusLabel];
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
            [WeAppToast toast:@"删除成功！"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _deleteGeofenceService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"删除失败！"];
        };
    }
}

/**
 *  获取围栏更新后信息
 */
- (EHGetGeofenceListRsp *)getInsertGeofenceReq{
    EHGetGeofenceListRsp *req = [[EHGetGeofenceListRsp alloc]init];
    
    req.geofence_name = self.geofenceNameField.text;
    req.latitude = self.geofenceCoordinate.latitude;
    req.longitude = self.geofenceCoordinate.longitude;
    req.geofence_radius = (int)self.radius;
    req.geofence_id = self.geofenceInfo.geofence_id;
    req.geofence_address = self.addressLabel.text;
    
    return req;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
