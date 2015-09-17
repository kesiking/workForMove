//
//  EHMyInfoTabbarViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMyInfoTabViewController.h"
#import "EHSettingViewController.h"
#import "EHMyInfoViewController.h"
#import "EHMyInfoTabTableViewCell.h"
#import "KSLoginComponentItem.h"
#import "UIImageView+WebCache.h"
#import "EHGetBabyListService.h"
#import "EHBabyUser.h"
#import "MWQREncode.h"
#import "EHBabyUserDetailViewController.h"
#import "EHBindDeviceViewController.h"
#import "EHAboutViewController.h"
#import "EHSocialShareHandle.h"
#import "EHSocializedSharedMacro.h"
#import "EHAleatView.h"
#import "EHAppQRImageViewController.h"
#import "NSString+StringSize.h"
#import "EHCollectionCellItem.h"
#import "EHCollectionItemTableViewCell.h"
#import "EHFamilyMemberViewController.h"
#import "EHFamilyNumbersViewController.h"
#import "EHBabyAlarmViewController.h"
#import "EHBabyIdentityViewController.h"
#import "EHBabyLocationModeViewController.h"
#import "EHGeofenceListViewController.h"


#define kTopViewHeight  250
#define kImageHeight    70
#define kNameHeight     20
#define kCellHeight     50
#define kHeaderViewHeight 45


// AdminItem.plist中的tag值一一对应
typedef NS_ENUM(NSInteger, EHCollentionItemType) {
    EHCollentionItemTypeFamilyMember = 1000,
    EHCollentionItemTypeFamilyPhone,
    EHCollentionItemTypeGeofence,
    EHCollentionItemTypeBabyAlarm,
    EHCollentionItemTypeBabyLocation,
    EHCollentionItemTypeBabyIdentity
    
};


@interface EHMyInfoTabViewController()<UITableViewDataSource,UITableViewDelegate,EHSocialShareViewDelegate, EHCollectionItemTableViewCellDelegate>

@end

@implementation EHMyInfoTabViewController
{
    UITableView *_tableView;
//    NSArray *_babyArray;
//    EHGetBabyListService* _getBabyList;
    
    EHGetBabyListRsp*  _currentSelectBaby;
    NSMutableArray* _functionCollectionItemList;
    NSArray *_appSettingConfigList;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.needLogin = YES;
    
    _currentSelectBaby = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    [self initTableView];
    //[self initNavBarViews];
    [self setupFunctionCollectionItemList];
    [self initAppSettingItemList];
}

-(void)measureViewFrame{
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _currentSelectBaby =[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    [self setupFunctionCollectionItemList];
    [_tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)initNavBarViews{
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarRightView];
    self.rightBarButtonItem = rightBarButtonItem;
}

- (void)initTableView{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
        }];
    }
}

-(void)babyHorizontalListViewBabyCliced:(EHGetBabyListRsp*)babyUserInfo
{
    _currentSelectBaby = babyUserInfo;
    [self setupFunctionCollectionItemList];
    [_tableView reloadData];
}

- (void)initAppSettingItemList
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SettingConfig" ofType:@"plist"];
    _appSettingConfigList = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)setupFunctionCollectionItemList
{
    if (!_currentSelectBaby)
    {
        return;
    }
    static NSString * const nameKey = @"name";
    static NSString * const imageNameKey = @"imagename";
    static NSString * const tagKey = @"tag";
    
    NSString *path;
    if ([EHUtils isAuthority:_currentSelectBaby.authority]) {
        path = [[NSBundle mainBundle] pathForResource:@"AdminItem" ofType:@"plist"];
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:@"NonAdminItem" ofType:@"plist"];
    }
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    if (!array)
    {
        DDLogWarn(@"文件加载失败");
    }
    
    _functionCollectionItemList = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        EHCollectionCellItem *cellItem = [[EHCollectionCellItem alloc] init];
        cellItem.itemName = dict[nameKey];
        cellItem.itemImageName = dict[imageNameKey];;
        cellItem.itemTag = [dict[tagKey] integerValue];
        [_functionCollectionItemList addObject:cellItem];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_currentSelectBaby) {
        return 5;
    }
    else
    {
        return 4;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentSelectBaby)
    {
        if (section == 4) {
            return 2;
        }
        else if (section == 1)
        {
            return (_functionCollectionItemList.count - 1)/kCollectionItemCount + 1;;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (section == 3) {
            return 2;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (!_currentSelectBaby)
    {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"添加宝贝";
            cell.imageView.image = [UIImage imageNamed:@"ico_add"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            NSDictionary *dic;
            if (indexPath.section == 1) {
                dic = _appSettingConfigList[0];
            }else if (indexPath.section == 2) {
                dic = _appSettingConfigList[1];
            }
            else {
                dic = _appSettingConfigList[2+indexPath.row];
            }
            cell.textLabel.text = [dic objectForKey:@"name"];
            cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"babyDetailCellId"];
            
            cell.textLabel.text = _currentSelectBaby.babyNickName;
            cell.detailTextLabel.text = @"宝贝详情";
            NSString* defaultImageStr = @"headportrait_list_boy";
            if ([EHUtils isGirl:_currentSelectBaby.babySex]) {
                defaultImageStr = @"headportrait_list_girl";
            }
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_currentSelectBaby.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:_currentSelectBaby.babyId newPlaceHolderImagePath:_currentSelectBaby.babyHeadImage defaultHeadImage:[UIImage imageNamed:defaultImageStr]]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.section == 1)
        {
            EHCollectionItemTableViewCell *cell = [[EHCollectionItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEHCollectionItemTableViewCell"];
            NSInteger index = indexPath.row;
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:kCollectionItemCount];
            for (NSInteger i = 0; i < kCollectionItemCount && index*kCollectionItemCount + i < _functionCollectionItemList.count; i++)
            {
                [list addObject:_functionCollectionItemList[index*kCollectionItemCount + i]];
            }
            
            cell.cellDelegate = self;
            [cell setupCollectionItems:list];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSDictionary *dic;
            if (indexPath.section == 2) {
                dic = _appSettingConfigList[0];
            }else if (indexPath.section == 3) {
                dic = _appSettingConfigList[1];
            }
            else {
                dic = _appSettingConfigList[2+indexPath.row];
            }
            cell.textLabel.text = [dic objectForKey:@"name"];
            cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_currentSelectBaby)
    {
        if (indexPath.section == 0) {
            EHBabyUserDetailViewController* babyUserDetailVC = [[EHBabyUserDetailViewController alloc] initWithNibName:NSStringFromClass([EHBabyUserDetailViewController class]) bundle:[NSBundle mainBundle]];
            babyUserDetailVC.babyUser = _currentSelectBaby;
            babyUserDetailVC.name=babyUserDetailVC.babyUser.babyName;
            [self.navigationController pushViewController:babyUserDetailVC animated:YES];
        }
        else if (indexPath.section == 2)
        {
            EHMyInfoViewController *myInfoVC = [[EHMyInfoViewController alloc]init];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
        else if (indexPath.section == 3)
        {
            EHSettingViewController *settingVC = [[EHSettingViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
        else if (indexPath.section == 4)
        {
            if (indexPath.row == 0) {
                [EHSocialShareHandle presentWithTypeArray:@[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToQQ,EHShareToSina,EHShareToSms,EHShareToQRCode] Title:[NSString stringWithFormat:@"%@ %@",kEH_APP_NAME,kEH_WEBSITE_URL] Image:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME] FromTarget:self];
            }
            else {
                EHAboutViewController *aboutViewController = [[EHAboutViewController alloc]init];
                [self.navigationController pushViewController:aboutViewController animated:YES];
            }
            
        }
    }
    else
    {
        if (indexPath.section == 0) {
            EHBindDeviceViewController * bindVC = [[EHBindDeviceViewController alloc] initWithNibName:NSStringFromClass([EHBindDeviceViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:bindVC animated:YES];
            
        }
        else if (indexPath.section == 1)
        {
            EHMyInfoViewController *myInfoVC = [[EHMyInfoViewController alloc]init];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
        else if (indexPath.section == 2)
        {
            EHSettingViewController *settingVC = [[EHSettingViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
        else
        {
            if (indexPath.row == 0) {
                [EHSocialShareHandle presentWithTypeArray:@[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToQQ,EHShareToSina,EHShareToSms,EHShareToQRCode] Title:[NSString stringWithFormat:@"%@ %@",kEH_APP_NAME,kEH_WEBSITE_URL] Image:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME] FromTarget:self];
            }
            else {
                EHAboutViewController *aboutViewController = [[EHAboutViewController alloc]init];
                [self.navigationController pushViewController:aboutViewController animated:YES];
            }
            
        }
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    
    if (_currentSelectBaby && indexPath.section == 1)
    {
        return kEHCollectionItemTableViewCellHeight;
    }
    else
    {
        return 49;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kHeaderViewHeight)];
//
//        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 / 2, 200, 10)];
//        headerLabel.textColor = EH_cor4;
//        headerLabel.font = EH_font6;
//        headerLabel.textAlignment = NSTextAlignmentLeft;
//        headerLabel.text = @"我关注的宝贝";
//        headerLabel.adjustsFontSizeToFitWidth = YES;
//        
//        [customView addSubview:headerLabel];
//        return customView;
//    }
//    else return nil;
//}


#pragma mark - Getters And Setters

//设置宝贝列表，获取宝贝信息
//- (void)loadBabyUsers{
//    
//    _getBabyList = [EHGetBabyListService new];
//    // service 返回成功 block
//    __weak UITableView* weakTableview = _tableView;
//    _getBabyList.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
//
//        EHLogInfo(@"GetBabyList成功");
//        {
//            _babyArray = service.dataList;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                __strong UITableView* strongTableView = weakTableview;
//                [strongTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            });
//        }
//    };
//
//    // service 返回失败 block
//    _getBabyList.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
//        [WeAppToast toast:@"获取宝贝列表失败"];
//    };
//    [_getBabyList loadData];
//    
//}




#pragma mark - Events Response


#pragma mark - EHSocialShareViewDelegate
- (void)shareWithType:(NSInteger)type Title:(NSString *)title Image:(UIImage *)image{
    //分享消息类型为默认的图文分享带链接
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;

    //分享结果处理代码块
    void (^sharedResponseManageBlock)(UMSocialResponseEntity *response) = ^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            [WeAppToast toast:@"分享成功！"];
        }
        else {
            NSLog(@"分享失败！");
            [WeAppToast toast:@"分享失败！"];
        }
    };
    
    switch (type) {
            
        case EHShareTypeWechatSession:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:title image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                sharedResponseManageBlock(response);
            }];
        }
            break;
            
        case EHShareTypeWechatTimeline:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:title image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                sharedResponseManageBlock(response);
            }];
        }
            break;
            
        case EHShareTypeQQ:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:title image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                sharedResponseManageBlock(response);
            }];
        }
            break;
            
        case EHShareTypeWeibo:
        {
            [[UMSocialControllerService defaultControllerService] setShareText:title shareImage:image socialUIDelegate:(id)self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
            break;
            
        case EHShareTypeSms:
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:title image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                sharedResponseManageBlock(response);
            }];
            
        }
            break;
        case EHShareTypeQRCode:
        {
            NSLog(@"二维码分享按钮");
            EHAppQRImageViewController *appQRImageVC = [[EHAppQRImageViewController alloc]init];
            [self.navigationController pushViewController:appQRImageVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [WeAppToast toast:@"分享成功！"];
    }
    else {
        [WeAppToast toast:@"分享失败！"];
    }
}

#pragma mark- EHCollectionItemTableViewCellDelegate

- (void)collectionItemCell:(EHCollectionItemTableViewCell *)cell actionWithTag:(NSInteger)tag
{
    switch (tag) {
        case EHCollentionItemTypeFamilyMember:
        {
            EHFamilyMemberViewController *familyMemberVC=[[EHFamilyMemberViewController alloc] init];
            familyMemberVC.babyName = [EHUtils isEmptyString:_currentSelectBaby.babyNickName] ? _currentSelectBaby.babyName : _currentSelectBaby.babyNickName;
            familyMemberVC.babyId = _currentSelectBaby.babyId;
            familyMemberVC.authority = _currentSelectBaby.authority;
//                familyMemberVC.familyMemberDidChanged = ^(BOOL bChanged){
//                    if (bChanged) {
//                        [self getBabyAttentionUsers];
//                    }
//                };
            [self.navigationController pushViewController:familyMemberVC animated:YES];
        }
            break;
        case EHCollentionItemTypeFamilyPhone:
        {
            EHFamilyNumbersViewController *familyNumVC=[[EHFamilyNumbersViewController alloc] init];
            //familyNumVC.familyNumberList = [NSMutableArray arrayWithArray:self.familyPhoneList];
            familyNumVC.babyId = _currentSelectBaby.babyId;
            [self.navigationController pushViewController:familyNumVC animated:YES];
            NSString* name = [EHUtils isEmptyString:_currentSelectBaby.babyNickName] ? _currentSelectBaby.babyName : _currentSelectBaby.babyNickName;
            NSString *phoneListTitle = [NSString stringWithFormat:@"%@的亲情号码", name];
            
            familyNumVC.title=phoneListTitle;
        }
            break;
        case EHCollentionItemTypeGeofence:
        {

            EHGeofenceListViewController *glvc = [[EHGeofenceListViewController alloc]init];
            glvc.babyUser = _currentSelectBaby;
            [self.navigationController pushViewController:glvc animated:YES];
        }
            break;
        case EHCollentionItemTypeBabyAlarm:
        {
            EHBabyAlarmViewController *alarmVC = [[EHBabyAlarmViewController alloc]init];
            alarmVC.babyUser = _currentSelectBaby;
            [self.navigationController pushViewController:alarmVC animated:YES];
        }
            break;
        case EHCollentionItemTypeBabyLocation:
        {
            EHBabyLocationModeViewController *locationModeVC=[[EHBabyLocationModeViewController alloc] init];
            locationModeVC.babyId=_currentSelectBaby.babyId;
            locationModeVC.locationMode=_currentSelectBaby.workMode;
            locationModeVC.modifyLocationModeSuccess = ^(NSString*locationMode){
                
                _currentSelectBaby.workMode=locationMode;
                
            };
            
            [self.navigationController pushViewController:locationModeVC animated:YES];
        }
            break;
        case EHCollentionItemTypeBabyIdentity:
        {
            EHBabyIdentityViewController* babyIdVC = [[EHBabyIdentityViewController alloc] initWithDeviceCode:_currentSelectBaby.device_code];
            
            [self.navigationController pushViewController:babyIdVC animated:YES];
        }
            break;
        default:
            break;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- KSTabBarViewControllerProtocol

-(BOOL)shouldSelectViewController:(UIViewController*)viewController{
    return [self checkLogin];
}

-(BOOL)checkLogin{
    if (self.rdv_tabBarController.selectedViewController == self) {
        return [super checkLogin];
    }
    WEAKSELF
    return [self alertViewCheckLoginWithCompleteBlock:^{
        STRONGSELF
        [strongSelf doLogin];
    }];
}

-(BOOL)alertViewCheckLoginWithCompleteBlock:(dispatch_block_t)completeBlock{
    //WEAKSELF
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (!isLogin) {
        EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:LOGIN_ALERTVIEW_MESSAGE/*@"进入我的选项需要登陆账号，是否登陆已有账号？"*/ clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
            //STRONGSELF
            if (index == 1) {
                if(completeBlock){
                    completeBlock();
                }
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [aleatView show];
    }else if(completeBlock){
        completeBlock();
    }
    return isLogin;
}

- (CGRect)selectViewControllerRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 49);
}

@end
