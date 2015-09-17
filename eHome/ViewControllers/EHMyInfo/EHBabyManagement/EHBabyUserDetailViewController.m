//
//  EHBabyUserDetailViewController.m
//  eHome
//
//  Created by louzhenhua on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyUserDetailViewController.h"
#import "MWQREncode.h"
#import "EHRightImageTableViewCell.h"
#import "EHModifyRelationViewController.h"
#import "EHModifyBabyNameViewController.h"
#import "EHUserPicFetcherView.h"
#import "EHBigUserPicShowController.h"
#import "EHLoadingHud.h"
#import "EHUploadUserPicService.h"
#import "EHUpdateBabyInfoService.h"
#import "EHBabyUser.h"
#import "EHGetBabyAttentionUsersService.h"
#import "EHGetGeofenceListService.h"
#import "EHGeofenceListViewController.h"
#import "EHGetBabyFamilyPhoneListService.h"
#import "EHBabyIdentityViewController.h"
#import "EHGetBabyAttentionUsersRsp.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "EHUnBindBabyService.h"
#import "EHFamilyNumbersViewController.h"
#import "EHFamilyMemberViewController.h"
#import "EHBabyLocationModeViewController.h"
#import "EHBabyAlarmViewController.h"


@interface EHBabyUserDetailViewController ()<UITabBarControllerDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>
{
    EHLoadingHud *_loadingHud;
    EHUploadUserPicService *_uploadHeadImageService;
    EHUpdateBabyInfoService* _updateBabyInfoService;
    EHGetGeofenceListService *_listService;
    EHGetBabyAttentionUsersService * _getBabyAttentionUsersService;
    EHGetBabyFamilyPhoneListService * _getBabyFamilyPhoneListService;
    EHUnBindBabyService * _unbindBabyService;
    
}

@property (weak, nonatomic) IBOutlet UITableView *babyDetailTableView;
@property (strong, nonatomic) UIView* imagePreview;

@property (nonatomic, strong)NSArray* geofenceList;
@property (nonatomic, strong)NSArray* familyMemberList;
@property (nonatomic, strong)NSArray* familyPhoneList;


@property (nonatomic, strong)UIPickerView* heightPicker;
@property (nonatomic, strong)UIPickerView* weightPicker;
@end

@implementation EHBabyUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if ([EHUtils isAuthority:self.babyUser.authority]) {

        self.title = self.babyUser.babyName;
    }
    else
    {
        self.title = self.babyUser.babyNickName ? self.babyUser.babyNickName : self.babyUser.babyName;
    }
    
//    UIBarButtonItem* moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnTapped:)];
//    self.navigationItem.rightBarButtonItem = moreBtn;
    
    _loadingHud = [[EHLoadingHud alloc] init];
    [self getGeofenceList];
    [self getBabyAttentionUsers];
    //[self getBabyFamilyPhoneList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSIndexPath* familyIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
//    [self.babyDetailTableView reloadRowsAtIndexPaths:@[familyIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self getBabyFamilyPhoneList];
    
}


- (IBAction)moreBtnTapped:(id)sender
{
    
    [EHPopMenuLIstView showMenuViewWithTitleTextArray:@[@"取消关注"] menuSelectedBlock:^(NSUInteger index, EHPopMenuModel *selectItem) {
        NSLog(@"index = %ld",index);
        if (index == 0) {
            [self unBindBaby];
        }
        
    }];
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 4;
            break;
        case 1:
            if ([EHUtils isAuthority:self.babyUser.authority])
            {
                rows = 5;
            }
            else
            {
                rows = 1;
                
            }
            break;
        case 2:
            rows = 4;
            break;
        case 3:
            rows = 1;
            break;
        default:
            break;
    }
    
    return rows;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *kEHBabyDetailCellID = @"kEHBabyDetailCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEHBabyDetailCellID];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kEHBabyDetailCellID];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                EHRightImageTableViewCell* cell;
                
                NSString* defaultHead = @"headportrait_boy_160";
                if ([EHUtils isGirl:self.babyUser.babySex]) {
                    defaultHead = @"headportrait_girl_160";
                }
               
                
                cell = [self createRightImageCellForTableview:tableView withText:@"头像" andImage:self.babyUser.babyHeadImage andDefaultHeadImage:[UIImage imageNamed:defaultHead]  andClickBlock:^(UIImageView* imageView){
                    [self showImagePreview:imageView];
                    
                }];
                cell.rightImageView.layer.masksToBounds = YES;
                cell.rightImageView.layer.cornerRadius =15;
                
                if ([EHUtils isAuthority:self.babyUser.authority]) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                return cell;
            }

            case 1:
                if ([EHUtils isAuthority:self.babyUser.authority]) {
                    cell.textLabel.text = @"名字";
                    
                    cell.detailTextLabel.text = self.babyUser.babyName;
                }
                else
                {
                    cell.textLabel.text = @"昵称";
                    
                    cell.detailTextLabel.text = self.babyUser.babyNickName ? self.babyUser.babyNickName : self.babyUser.babyName;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                break;
            case 2:
                cell.textLabel.text = @"我和宝贝的关系";
                cell.detailTextLabel.text = self.babyUser.relationShip;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                break;
                
            case 3:
            {
                cell.textLabel.text = @"设备";
                cell.detailTextLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"围栏";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld个", self.geofenceList.count];
                break;
            case 1:
                cell.textLabel.text = @"定位模式";
                cell.detailTextLabel.text = [self getBabyLocationMode:self.babyUser.workMode];
                break;
            case 2:
                cell.textLabel.text = @"家庭";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld人", self.familyMemberList.count];
                break;
            case 3:
                cell.textLabel.text = @"电话";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld人", self.familyPhoneList.count];
                break;
            case 4:
                cell.textLabel.text = @"闹钟";
                cell.detailTextLabel.text = @"";
                
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2){
        if ([EHUtils isAuthority:self.babyUser.authority]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [EHUtils isBoy:self.babyUser.babySex] ? @"男" : @"女"];
                break;
            case 1:
                cell.textLabel.text = @"年龄";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld岁", (long)[self.babyUser.babyAge integerValue]];
                break;
            case 2:
                cell.textLabel.text = @"身高";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fcm", [self.babyUser.babyHeight doubleValue]];
                break;
            case 3:
                cell.textLabel.text = @"体重";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fkg", [self.babyUser.babyWeight doubleValue]];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 3)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unbindBabyCellID"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"移除宝贝";
        cell.textLabel.textColor = EH_cor7;
        cell.textLabel.font = EH_font2;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    }
    else if (section == 3)
    {
        return 50;
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, CGRectGetWidth(tableView.frame)-40, 12)];
        headerLabel.textColor = EH_cor4;
        headerLabel.font = EH_font7;
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.text = @"设置宝贝的成长信息有助于更加精确地检测宝贝的运动量";
        
        [customView addSubview:headerLabel];
        return customView;
    }
    else if (section == 3)
    {
        return [[UILabel alloc] init];
    }
    else
    {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                if ([EHUtils isAuthority:self.babyUser.authority]) {
                    EHUserPicFetcherView *userPicFetcherView = [[EHUserPicFetcherView alloc]init];
                    [userPicFetcherView showFromTarget:self];
                    WEAKSELF
                    userPicFetcherView.finishSelectedImageBlock = ^(NSData *selectedImageData){
                        STRONGSELF
                        EHLogInfo(@"finishSelectedImageBlock");
                        //上传、更新、设置头像
                        [strongSelf updateBabyHeadImage:selectedImageData];
                    };
                }
                
            }
                break;
            case 1:
            {
                EHModifyBabyNameViewController* modifyBabyNameVC = [[EHModifyBabyNameViewController alloc] init];
                modifyBabyNameVC.babyId = self.babyUser.babyId;
                modifyBabyNameVC.babyName = [EHUtils isAuthority:self.babyUser.authority] ? self.babyUser.babyName : self.babyUser.babyNickName;
                modifyBabyNameVC.authory = self.babyUser.authority;
                WEAKSELF
                modifyBabyNameVC.modifyBabyNameSuccess = ^(NSString*modifiedName){
                    STRONGSELF
                    if ([EHUtils isAuthority:strongSelf.babyUser.authority]) {
                        self.babyUser.babyName = modifiedName;
                        
                    }
                    else
                    {
                        self.babyUser.babyNickName = modifiedName;
                    }
                    self.title = modifiedName;
                    [self.babyDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                };
                
                [self.navigationController pushViewController:modifyBabyNameVC animated:YES];
                
                
            }
                
                break;
                
            case 2:
            {
                EHModifyRelationViewController* modifyRelationVC = [EHModifyRelationViewController new];
                modifyRelationVC.babyId = self.babyUser.babyId;
                modifyRelationVC.currentRelationShip = self.babyUser.relationShip;
                modifyRelationVC.authority = self.babyUser.authority;
                modifyRelationVC.modifyRelationSuccess = ^(NSString*selected){
                    self.babyUser.relationShip = selected;
                    [self.babyDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                
                [self.navigationController pushViewController:modifyRelationVC animated:YES];
            }

                break;
            case 3:
            {
                EHBabyIdentityViewController* babyIdVC = [[EHBabyIdentityViewController alloc] initWithDeviceCode:self.babyUser.device_code];
                
                [self.navigationController pushViewController:babyIdVC animated:YES];
            }
                
                break;
            default:
                break;
        }
    }
    
    else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                WEAKSELF
                EHGeofenceListViewController *glvc = [[EHGeofenceListViewController alloc]init];
                glvc.babyUser = self.babyUser;
                glvc.geofenceListCountDidChanged = ^(NSArray *geofenceList){
                    STRONGSELF
                    strongSelf.geofenceList = geofenceList;
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                EHLogInfo(@"self.babyUser.babyId = %@",self.babyUser.babyId);
                [self.navigationController pushViewController:glvc animated:YES];
            }
                break;
            case 1:
            {
                WEAKSELF
                EHBabyLocationModeViewController *locationModeVC=[[EHBabyLocationModeViewController alloc] init];
                locationModeVC.babyId=self.babyUser.babyId;
                locationModeVC.locationMode=self.babyUser.workMode;
                locationModeVC.modifyLocationModeSuccess = ^(NSString*locationMode){
                    STRONGSELF
                    self.babyUser.workMode=locationMode;
                    [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                };

                [self.navigationController pushViewController:locationModeVC animated:YES];

            }
                break;
            case 2:
            {
                EHFamilyMemberViewController *familyMemberVC=[[EHFamilyMemberViewController alloc] init];
                familyMemberVC.babyName = [EHUtils isEmptyString:self.babyUser.babyNickName] ? self.babyUser.babyName : self.babyUser.babyNickName;
                familyMemberVC.babyId = self.babyUser.babyId;
                familyMemberVC.authority = self.babyUser.authority;
                familyMemberVC.familyMemberDidChanged = ^(BOOL bChanged){
                    if (bChanged) {
                        [self getBabyAttentionUsers];
                    }
                };
                [self.navigationController pushViewController:familyMemberVC animated:YES];

            }
                break;
            case 3:
            {
                EHFamilyNumbersViewController *familyNumVC=[[EHFamilyNumbersViewController alloc] init];
                familyNumVC.familyNumberList = [NSMutableArray arrayWithArray:self.familyPhoneList];
                familyNumVC.babyId = self.babyUser.babyId;
                [self.navigationController pushViewController:familyNumVC animated:YES];
                NSString* name = [EHUtils isEmptyString:self.babyUser.babyNickName] ? self.babyUser.babyName : self.babyUser.babyNickName;
                NSString *phoneListTitle = [NSString stringWithFormat:@"%@的亲情号码", name];
                
                familyNumVC.title=phoneListTitle;
                
            }
                break;
            case 4:
            {
                EHBabyAlarmViewController *alarmVC = [[EHBabyAlarmViewController alloc]init];
                //familyNumVC.familyNumberList = [NSMutableArray arrayWithArray:self.familyPhoneList];
                alarmVC.babyUser = self.babyUser;
                [self.navigationController pushViewController:alarmVC animated:YES];
                //NSString* name = [EHUtils isEmptyString:self.babyUser.babyNickName] ? self.babyUser.babyName : self.babyUser.babyNickName;
                
            }
                break;
            default:
                break;
        }
    }

    else if (indexPath.section == 2)
    {
        if ([EHUtils isAuthority:self.babyUser.authority] ) {
            switch (indexPath.row) {
                case 0:
                    [self showModBabySexView];
                    break;
                case 1:
                    [self showModBabyBirthdayView];
                    break;
                case 2:
                    [self showModBabyHeightView];
                    break;
                case 3:
                    [self showModBabyWeightView];
                    break;
                default:
                    break;
            }
        }
        
    }
    
    else if (indexPath.section == 3)
    {
        [self showUnBindBabyAlert];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private Functions
static BOOL kEHRightImageTableViewCellRegistered = NO;
-(EHRightImageTableViewCell*)createRightImageCellForTableview:(UITableView*)tableView withText:(NSString*)text andImage:(id)image  andDefaultHeadImage:(UIImage*)defaultHeadImage andClickBlock:(RightImageViewClickBlock)clickBlock
{
    if (!kEHRightImageTableViewCellRegistered) {
        UINib *nib = [UINib nibWithNibName:@"EHRightImageTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"kEHRightImageTableViewCellID"];
        kEHRightImageTableViewCellRegistered = YES;
    }
    
    EHRightImageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kEHRightImageTableViewCellID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EHRightImageTableViewCell class]) owner:self options:nil] lastObject];//[[EHRightImageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kEHRightImageTableViewCellID];
    }
    
    cell.textLabel.text = text;
    if ([image isKindOfClass:[UIImage class]]) {
        cell.rightImageView.image = image;
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:self.babyUser.babyId newPlaceHolderImagePath:image defaultHeadImage:defaultHeadImage]];
    }
    
    
    cell.rightImageViewClickBlock = clickBlock;
    
    return cell;
}

-(void)hideImagePreview:(UITapGestureRecognizer*)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePreview.alpha=0;
    } completion:^(BOOL finished) {
        for(UIView *view in [self.imagePreview subviews])
        {
            [view removeFromSuperview];
        }
        [self.imagePreview removeFromSuperview];
        self.imagePreview = nil;
    }];
}

-(void)showImagePreview:(UIImageView*)imageView
{
    EHBigUserPicShowController *bigUserPicShowController = [[EHBigUserPicShowController alloc]init];
    bigUserPicShowController.fromView = imageView;
    [self presentViewController:bigUserPicShowController animated:NO completion:^{}];
    
}

- (void)updateBabyHeadImage:(NSData*)selectData
{
    [_loadingHud showWithStatus:@"正在上传中..." InView:self.view];
    
    EHLoadingHud *__weak weakHud = _loadingHud;
    _uploadHeadImageService = [EHUploadUserPicService new];
    WEAKSELF
    _uploadHeadImageService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        EHUserPicUrl *item = (EHUserPicUrl *)service.item;
        [strongSelf modifyBabyHeadImageWithPicUrl:item.original andSmallUrl:item.compress];
        
    };
    _uploadHeadImageService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [weakHud showErrorWithStatus:@"上传失败！" Finish:^{}];
        //        NSDictionary* userInfo = error.userInfo;
        //        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    [_uploadHeadImageService uploadImageWithData:selectData UserPhone:[KSLoginComponentItem sharedInstance].user_phone];
}

- (void)modifyBabyHeadImageWithPicUrl:(NSString*)url andSmallUrl:(NSString*)smallUrl
{
    EHLoadingHud *__weak weakHud = _loadingHud;
    
    _updateBabyInfoService= [EHUpdateBabyInfoService new];
    
    WEAKSELF
    _updateBabyInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"设置完成！");
        STRONGSELF
        [weakHud showSuccessWithStatus:@"更新头像成功" Finish:^{
            strongSelf.babyUser.babyHeadImage = url;
            NSIndexPath *headIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[headIndex] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        
    };
    _updateBabyInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [weakHud showErrorWithStatus:@"设置失败！" Finish:^{}];
        
        //        NSDictionary* userInfo = error.userInfo;
        //        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };

    EHUpdateBabyInfoReq* babyIno = [EHUpdateBabyInfoReq new];
    babyIno.baby_id = self.babyUser.babyId;
    babyIno.user_phone = [KSAuthenticationCenter userPhone];
    babyIno.baby_head_imag = url;
    [_updateBabyInfoService updateBabyInfo:babyIno];
    
}

- (void)getGeofenceList{

    if (!_listService) {
        _listService = [EHGetGeofenceListService new];
        WEAKSELF
        _listService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            strongSelf.geofenceList = service.dataList;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        _listService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        };
    }
    [_listService getGeofenceListWithBabyID:[self.babyUser.babyId intValue] UserID:[[KSLoginComponentItem sharedInstance].userId intValue]];

}

- (void)getBabyAttentionUsers
{
    if (![EHUtils isAuthority:self.babyUser.authority]) {
        return;
    }
    _getBabyAttentionUsersService = [EHGetBabyAttentionUsersService new];
    
    WEAKSELF
    _getBabyAttentionUsersService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getBabyAttentionUsers完成！");
        STRONGSELF
        
        if (service.item) {
            EHLogInfo(@"%@",service.item);
            strongSelf.familyMemberList = [(EHGetBabyAttentionUsersRsp*)service.item user] ;
            NSIndexPath* familyIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[familyIndexPath] withRowAnimation:UITableViewRowAnimationNone];

        }
        
        
        
    };
    _getBabyAttentionUsersService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
    };

    [_getBabyAttentionUsersService getThisBabyAllAttentionUsers:self.babyUser.babyId];
}


- (void)getBabyFamilyPhoneList
{
    if (![EHUtils isAuthority:self.babyUser.authority]) {
        return;
    }
    _getBabyFamilyPhoneListService = [EHGetBabyFamilyPhoneListService new];
    
    WEAKSELF
    _getBabyFamilyPhoneListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getBabyFamilyPhoneList完成！");
        STRONGSELF
        
        EHLogInfo(@"%@",service.dataList);
        strongSelf.familyPhoneList = service.dataList;
        NSIndexPath* familyIndexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[familyIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
//        if (service.dataList) {
//            EHLogInfo(@"%@",service.dataList);
//            strongSelf.familyPhoneList = service.dataList;
//            NSIndexPath* familyIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
//            [strongSelf.babyDetailTableView reloadRowsAtIndexPaths:@[familyIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//        }
        
        
        
    };
    _getBabyFamilyPhoneListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
    };
    
    [_getBabyFamilyPhoneListService getBabyFamilyPhoneListById:self.babyUser.babyId];
}


- (void)showModBabyBirthdayView
{

    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite];

    WEAKSELF
    RMAction *selectAction = [RMAction actionWithTitle:@"确定" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);

        [strongSelf updateBabySex:nil andBabyBirthday:[EHUtils stringFromDate:((UIDatePicker *)controller.contentView).date] andHeight:nil andWeight:nil];
    }];
    
    selectAction.titleColor = EH_cor4;

    [dateSelectionController addAction:selectAction];
    
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = YES;
    dateSelectionController.disableMotionEffects = YES;
    dateSelectionController.disableBlurEffects = YES;
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.minimumDate = [EHUtils convertDateFromString:@"1990-1-1 00:00:00" withFormat:nil];
    dateSelectionController.datePicker.maximumDate = [NSDate date];
    dateSelectionController.datePicker.date = [EHUtils isEmptyString:self.babyUser.babyBirthDay] ? [EHUtils convertDateFromString:@"2010-6-15 00:00:00" withFormat:nil] : [EHUtils convertDateFromString:self.babyUser.babyBirthDay withFormat:nil];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)showModBabyHeightView
{
    
    RMPickerViewController* heightPickerVC = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    heightPickerVC.picker.dataSource = self;
    heightPickerVC.picker.delegate = self;
    self.heightPicker = heightPickerVC.picker;
    
    WEAKSELF
    RMAction *selectAction = [RMAction actionWithTitle:@"确定" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSInteger selectHeight = [picker selectedRowInComponent:0]+50;
        if (selectHeight == [self.babyUser.babyHeight integerValue]) {
            // 没有改变不更新
            return;
        }

        [strongSelf updateBabySex:nil andBabyBirthday:nil andHeight:[NSNumber numberWithInteger:selectHeight] andWeight:nil];
    }];
    selectAction.titleColor = EH_cor4;
    
    [heightPickerVC addAction:selectAction];


    
    //You can enable or disable blur, bouncing and motion effects
    heightPickerVC.disableBouncingEffects = YES;
    heightPickerVC.disableMotionEffects = YES;
    heightPickerVC.disableBlurEffects = YES;
    
    //You can access the actual UIDatePicker via the datePicker property
    if (self.babyUser.babyHeight== nil || [self.babyUser.babyHeight integerValue] == 0)
    {
        [heightPickerVC.picker selectRow:50 inComponent:0 animated:YES];
        
    }
    else
    {
        [heightPickerVC.picker selectRow:[self.babyUser.babyHeight integerValue] - 50 inComponent:0 animated:YES];
    }
    

    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:heightPickerVC animated:YES completion:nil];
    
}

- (void)showModBabyWeightView
{
    
    RMPickerViewController* weightPickerVC = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    weightPickerVC.picker.dataSource = self;
    weightPickerVC.picker.delegate = self;
    self.weightPicker = weightPickerVC.picker;
    
    WEAKSELF
    RMAction *selectAction = [RMAction actionWithTitle:@"确定" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSInteger selectWeight = [picker selectedRowInComponent:0] + 10;
        if (selectWeight == [self.babyUser.babyWeight integerValue]) {
            // 没有改变不更新
            return;
        }
        [strongSelf updateBabySex:nil andBabyBirthday:nil andHeight:nil andWeight:[NSNumber numberWithInteger:selectWeight]];
    }];
    selectAction.titleColor = EH_cor4;
    
    [weightPickerVC addAction:selectAction];
    
    
    //You can enable or disable blur, bouncing and motion effects
    weightPickerVC.disableBouncingEffects = YES;
    weightPickerVC.disableMotionEffects = YES;
    weightPickerVC.disableBlurEffects = YES;
    
    //You can access the actual UIDatePicker via the datePicker property
    if (self.babyUser.babyWeight== nil || [self.babyUser.babyWeight integerValue] == 0)
    {
        [weightPickerVC.picker selectRow:30 inComponent:0 animated:YES];
    }
    else
    {
        // 兼容老版本数据,不崩溃
        if ([self.babyUser.babyWeight integerValue ]< 10) {
            [weightPickerVC.picker selectRow:0 inComponent:0 animated:YES];
        }
        else
        {
            [weightPickerVC.picker selectRow:[self.babyUser.babyWeight integerValue] - 10 inComponent:0 animated:YES];
        }
    }
    
    
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:weightPickerVC animated:YES completion:nil];
    
}

- (void)showModBabySexView
{
    
    RMActionController* babySexVC = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    
    WEAKSELF
    RMAction *boyAction = [RMAction actionWithTitle:@"男" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        [strongSelf updateBabySex:[NSNumber numberWithInteger:1] andBabyBirthday:nil andHeight:nil andWeight:nil];
        
    }];
    
    boyAction.titleColor = EH_cor4;
    
    RMAction *girlAction = [RMAction actionWithTitle:@"女" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        [strongSelf updateBabySex:[NSNumber numberWithInteger:2] andBabyBirthday:nil andHeight:nil andWeight:nil];
        
    }];
    
    girlAction.titleColor = EH_cor4;
    
    [babySexVC addAction:girlAction];
    [babySexVC addAction:boyAction];
    
    babySexVC.seperatorViewColor = EH_linecor1;
    babySexVC.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    //You can enable or disable blur, bouncing and motion effects
    babySexVC.disableBouncingEffects = YES;
    babySexVC.disableMotionEffects = YES;
    babySexVC.disableBlurEffects = YES;

    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:babySexVC animated:YES completion:nil];
    
}



- (void)updateBabySex:(NSNumber*)babySex andBabyBirthday:(NSString*)birthday andHeight:(NSNumber*)babyHeight andWeight:(NSNumber*)babyWeight
{
    
    _updateBabyInfoService= [EHUpdateBabyInfoService new];
    
    WEAKSELF
    _updateBabyInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"更新宝贝成长信息成功");
        STRONGSELF
        NSNumber*babyAge = [(EHBabyInfo*)service.item baby_age];
        NSNumber*baby_height = [(EHBabyInfo*)service.item baby_height];
        NSNumber*baby_weight = [(EHBabyInfo*)service.item baby_weight];
        NSNumber*babySex = [(EHBabyInfo*)service.item baby_sex];
        strongSelf.babyUser.babyBirthDay = [(EHBabyInfo*)service.item baby_birthDay];
        
        [WeAppToast toast:@"更新宝贝成长信息成功"];
        strongSelf.babyUser.babyAge = babyAge;
        strongSelf.babyUser.babyHeight = baby_height;
        strongSelf.babyUser.babyWeight = baby_weight;
        strongSelf.babyUser.babySex= babySex;
        [strongSelf.babyDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        
        
    };
    _updateBabyInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){

        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHUpdateBabyInfoReq* babyIno = [EHUpdateBabyInfoReq new];
    babyIno.baby_id = self.babyUser.babyId;
    babyIno.user_phone = [KSAuthenticationCenter userPhone];
    babyIno.baby_birthday = birthday;
    babyIno.baby_height = babyHeight;
    babyIno.baby_weight = babyWeight;
    babyIno.baby_sex = babySex;
    [_updateBabyInfoService updateBabyInfo:babyIno];
    
}


- (void)unBindBaby
{
    
    _unbindBabyService= [EHUnBindBabyService new];
    
    WEAKSELF
    _unbindBabyService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"移除宝贝");
        STRONGSELF
        [WeAppToast toast:@"移除宝贝成功"];
        TBOpenURLFromSourceAndParams(tabbarURL(kEHOMETabHome), strongSelf, nil);
        
        
    };
    _unbindBabyService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        ;
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    
    [_unbindBabyService unBindBabyWithBabyId:self.babyUser.babyId userId:[NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]]];
}

- (void)showUnBindBabyAlert
{
//    UIAlertView* unBindAlert = [[UIAlertView alloc] initWithTitle:nil message:@"是否取消关注该宝贝" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    [unBindAlert show];

    RMActionController* unbindAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    unbindAlert.title = @"移除宝贝后,您将无法实时关注宝贝信息";
    unbindAlert.titleColor = EH_cor5;
    unbindAlert.titleFont = EH_font6;
    
    
    WEAKSELF
    RMAction *unbindAction = [RMAction actionWithTitle:@"移除宝贝" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        [strongSelf unBindBaby];;
        
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



#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    NSLog(@"Successfully selected rows: %@", selectedRows);
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == self.heightPicker) {
        if (component == 0) {
            return 131;
        }
        else
        {
            return 1;
        }
    }
    else if (pickerView == self.weightPicker)
    {
        if (component == 0) {
            return 71;
        }
        else
        {
            return 1;
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (pickerView == self.heightPicker) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%lu", (long)row+50];
        }
        else
        {
            return @"CM";
        }
    }
    else if (pickerView == self.weightPicker)
    {
        if (component == 0) {
            return [NSString stringWithFormat:@"%lu", (long)row+10];
        }
        else
        {
            return @"KG";
        }
    }
    
    return @"";
    
}


-(NSString *)getBabyLocationMode:(NSString *)mode{
    
    if ([mode isEqualToString: @"1"]) {
        return @"追踪模式";
    }else if([mode isEqualToString: @"2"]){
        return @"普通模式";
    }else{
        return @"省电模式";
    }
}


@end
