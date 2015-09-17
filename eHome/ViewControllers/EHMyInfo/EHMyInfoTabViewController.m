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


#define kTopViewHeight  250
#define kImageHeight    70
#define kNameHeight     20
#define kCellHeight     50
#define kHeaderViewHeight 45

@interface EHMyInfoTabViewController()<UITableViewDataSource,UITableViewDelegate,EHSocialShareViewDelegate>

@end

@implementation EHMyInfoTabViewController
{
    //UIView *_topView;
    UITableView *_tableView;
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    NSArray *_babyArray;
    
    EHGetBabyListService* _getBabyList;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.needLogin = YES;

    [self initTableView];
    [self initNavBarViews];
}

-(void)measureViewFrame{
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.hidden = YES;
    
    [self loadBabyUsers];
//    [self setHeadImageAndName];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view setFrame:[self selectViewControllerRectForBounds:self.view.bounds]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.translucent = NO;
}

-(void)initNavBarViews{
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarRightView];
    self.rightBarButtonItem = rightBarButtonItem;
}

- (void)initTableView{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = kCellHeight;
        _tableView.sectionFooterHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _babyArray.count + 1;

    }
    else if (section == 1 || section == 2){
        return 1;
    }
    else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    EHMyInfoTabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil){
        cell = [[EHMyInfoTabTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    //设置cell的四个属性
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *imageStr;         //图片路径
    NSString *nameStr;          //名字路径
    UIImage *QRcodeImage;       //二维码图片
    NSString *adminImageStr;    //管理员图片路径
    NSString* defaultImageStr;
    BOOL isHeadImage = YES;
    
    if (indexPath.section == 0) {
        
        //我关注的宝贝列表
        if (indexPath.row != _babyArray.count) {
            //获取模型
            EHGetBabyListRsp *model = _babyArray[indexPath.row];
            
            defaultImageStr = @"headportrait_list_boy";
            if ([EHUtils isGirl:model.babySex]) {
                defaultImageStr = @"headportrait_list_girl";
            }
            
            imageStr = model.babyHeadImage ? model.babyHeadImage : defaultImageStr;
            if ([EHUtils isAuthority:model.authority]) {
                nameStr = model.babyName;
            }
            else
            {
                nameStr = model.babyNickName ? model.babyNickName : model.babyName;
            }
            
            QRcodeImage = [MWQREncode qrImageForString:model.device_code imageSize:300];
            [params setObject:QRcodeImage forKey:@"QRcodeImage"];
            cell.qrImageViewClickBlock = ^(){
                EHLogInfo(@"qrImageViewClickBlock");
            };

            if ([EHUtils isAuthority:model.authority]){
                adminImageStr = @"ico_administrator";;
                [params setObject:adminImageStr forKey:@"adminImageStr"];
            }
            [params setObject:model.babyId forKey:@"currentBabyId"];
        }
        
        //添加宝贝
        else{
            defaultImageStr = @"ico_add";
            imageStr = @"ico_add";
            nameStr = kCellNameStr;
            cell.addBtnClickBlock = ^(){
                EHLogInfo(@"addBtnClickBlock");
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    //分享、关于、设置
    else {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SettingConfig" ofType:@"plist"];
        NSArray *settingConfigArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        NSDictionary *dic;
        if (indexPath.section == 1) {
            dic = settingConfigArray[0];
        }else if (indexPath.section == 2) {
            dic = settingConfigArray[1];
        }
        else {
            dic = settingConfigArray[2+indexPath.row];
        }
        imageStr        = [dic objectForKey:@"image"];
        defaultImageStr = [dic objectForKey:@"image"];
        nameStr         = [dic objectForKey:@"name"];
        isHeadImage = NO;
    }
    
    [params setObject:imageStr forKey:@"imageStr"];
    [params setObject:defaultImageStr forKey:@"defaultImageStr"];
    [params setObject:nameStr forKey:@"nameStr"];
    [params setObject:[NSNumber numberWithBool:isHeadImage ] forKey:@"isHeadImage"];

    [cell configWithParams:params];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row < _babyArray.count)
        {
            EHBabyUserDetailViewController* babyUserDetailVC = [[EHBabyUserDetailViewController alloc] initWithNibName:NSStringFromClass([EHBabyUserDetailViewController class]) bundle:[NSBundle mainBundle]];
            babyUserDetailVC.babyUser = _babyArray[indexPath.row];
            babyUserDetailVC.name=babyUserDetailVC.babyUser.babyName;
            [self.navigationController pushViewController:babyUserDetailVC animated:YES];
            //[babyUserDetailVC.]
        }
        else
        {
            EHBindDeviceViewController * bindVC = [[EHBindDeviceViewController alloc] initWithNibName:NSStringFromClass([EHBindDeviceViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:bindVC animated:YES];
        }
        
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kHeaderViewHeight;
    }
    else return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kHeaderViewHeight)];

        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 / 2, 200, 10)];
        headerLabel.textColor = EH_cor4;
        headerLabel.font = EH_font6;
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.text = @"我关注的宝贝";
        headerLabel.adjustsFontSizeToFitWidth = YES;
        
        [customView addSubview:headerLabel];
        return customView;
    }
    else return nil;
}


#pragma mark - Getters And Setters
//设置头像和名字
//- (void)setHeadImageAndName{
//    NSURL *imageUrl = [NSURL URLWithString:[KSLoginComponentItem sharedInstance].user_head_img];
//    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[EHUtils getUserHeadPlaceHolderImage:[NSNumber numberWithInteger:[[KSLoginComponentItem sharedInstance].userId integerValue]] newPlaceHolderImagePath:[KSLoginComponentItem sharedInstance].user_head_img defaultHeadImage:[UIImage imageNamed:@"headportrait_home_150"]] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//    }];
//    
//    NSString *nickName = [KSLoginComponentItem sharedInstance].nick_name;
//    EHLogInfo(@"nickName = %@",nickName);
//    if (!nickName) {
//        nickName = [KSLoginComponentItem sharedInstance].user_phone;
//    }
//    _nameLabel.text = nickName;
//}

//设置宝贝列表，获取宝贝信息
- (void)loadBabyUsers{
    
    _getBabyList = [EHGetBabyListService new];
    // service 返回成功 block
    __weak UITableView* weakTableview = _tableView;
    _getBabyList.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){

        EHLogInfo(@"GetBabyList成功");
        {
            _babyArray = service.dataList;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong UITableView* strongTableView = weakTableview;
                [strongTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    };

    // service 返回失败 block
    _getBabyList.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"获取宝贝列表失败"];
    };
    [_getBabyList loadData];
    
}


#pragma mark - 消息响应 messageBtnClicked
-(void)messageBtnClicked:(id)sender{
    // goto 消息列表页面
    if ([self checkLogin]) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if (_babyArray) {
            [params setObject:_babyArray forKey:@"babyListArray"];
        }
        TBOpenURLFromSourceAndParams(internalURL(@"EHMessageInfoViewController"), self, params);
    }
}

//头像和名字的TOP视图
//- (UIView *)topView{
//    
//    if (!_topView) {
//        _topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_home"]];
//        _topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) * CGRectGetHeight(_topView.frame) / CGRectGetWidth(_topView.frame));
//        _topView.userInteractionEnabled = YES;
//        
//        CGFloat headimageViewMinY = 20 + 70 / 2.0;
//        CGFloat labelHeight = [@"text" sizeWithFontSize:EH_siz1 Width:CGRectGetWidth(_topView.frame)].height;
//        CGFloat labelMaxY = headimageViewMinY + kImageHeight + 15 + labelHeight;
//        //使名字与底部至少间距15
//        if (CGRectGetHeight(_topView.frame) - labelMaxY < 15) {
//            headimageViewMinY += CGRectGetHeight(_topView.frame) - labelMaxY - 15;
//        }
//
//        _headImageView = [[UIImageView alloc] init];
//        _headImageView.frame = CGRectMake(0, 0, kImageHeight, kImageHeight);
//        _headImageView.center = CGPointMake(CGRectGetMidX(_topView.frame), headimageViewMinY + kImageHeight / 2.0);
//        _headImageView.layer.cornerRadius = kImageHeight/2.0;
//        _headImageView.layer.masksToBounds = YES;
//        _headImageView.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageViewClick:)];
//        [_headImageView addGestureRecognizer:tap];
//
//        UIImageView *circleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cirle_headportrait_home"]];
//        circleView.frame = CGRectMake(0, 0, kImageHeight + 5, kImageHeight + 5);
//        circleView.center = _headImageView.center;
//        
//        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, 0, CGRectGetWidth(_topView.frame) - kSpaceX * 2, labelHeight)];
//        _nameLabel.center = CGPointMake(CGRectGetMidX(_topView.frame), CGRectGetMaxY(circleView.frame) + 15 + labelHeight / 2.0);
//        _nameLabel.textAlignment = NSTextAlignmentCenter;
//        _nameLabel.font = EH_font1;
//        _nameLabel.textColor = EH_cor1;
//        
//        [_topView addSubview:_headImageView];
//        [_topView addSubview:circleView];
//        [_topView addSubview:_nameLabel];
//    }
//
//    return _topView;
//}

#pragma mark - Events Response
//- (void)headImageViewClick:(UITapGestureRecognizer *)tap{
//    EHMyInfoViewController *myInfoVC = [[EHMyInfoViewController alloc]init];
//    [self.navigationController pushViewController:myInfoVC animated:YES];
//}

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
