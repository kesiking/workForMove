//
//  EHFamilyNumbersViewController.m
//  eHome
//
//  Created by jinmiao on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamilyNumbersViewController.h"
#import "EHFamilyNumbersTableViewCell.h"
#import "EHFamNumberEditViewController.h"
#import "EHPopMenuLIstView.h"
#import "EHAddBabyFamilyPhoneService.h"
#import "EHDelBabyFamilyPhoneService.h"
#import "EHGetBabyFamilyPhoneListService.h"
#import "GroupedTableView.h"
#import "RMActionController.h"
#import "EHSelectFamilyMembersViewController.h"
#define kLines 8


typedef enum : NSUInteger {
    EHRightItemNone = 0,
    EHRightItemMore = 1,
    EHRightItemDone = 2,
} EHRightItemStyle;

@interface EHFamilyNumbersViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    EHDelBabyFamilyPhoneService *_delBabyFamilyPhoneService;
    EHGetBabyFamilyPhoneListService * _getBabyFamilyPhoneListService;
    NSArray *_headImageArray;
    NSArray *_relationArray;
}


@property (nonatomic, assign) BOOL markShowing;
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) UILabel *footerViewLabel;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation EHFamilyNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _relationArray = @[@"爸爸", @"妈妈", @"爷爷", @"奶奶",@"外公",@"外婆",@"叔叔", @"阿姨",@"舅舅",@"舅妈", @"哥哥", @"姐姐",@"弟弟",@"妹妹", @"家人"];
    _headImageArray = @[@"icon_dad160",@"icon_mom160",@"icon_grandpa160",@"icon_grandma160",@"icon_grandpa_pa160",@"icon_grandma_ma160",@"icon_uncle160",@"icon_aunt160",@"icon_uncle_m160",@"icon_aunt_m160",@"icon_brother160",@"icon_sister160",@"icon_brother_y160",@"icon_sister_y160",@"icon_family160"];
    //    self.selectedArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < kLines; i++) {
//        [self.selectedArray addObject:@NO];
//    }
//    
//    NSUInteger num = MIN(self.familyNumberList.count, kLines);
//    
//    //把获得的数据按照phone_type排列
//    for (NSUInteger j = 0; j < num; j++) {
//        EHBabyFamilyPhone *data = [self.familyNumberList objectAtIndex:j];
//    [self.familyNumberListWithType replaceObjectAtIndex:[data.phone_type integerValue] withObject:data];
//    }
//    [NSNumber numberWithInteger:[self.phoneModel.phone_type integerValue]]
    
    self.tableView=[[GroupedTableView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(self.view.frame)-16, CGRectGetHeight( self.view.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;;
    self.tableView.backgroundColor=EHBgcor1;
    UINib *nib = [UINib nibWithNibName:@"EHFamilyNumbersTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EHFamilyNumberTableViewCell"];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=EHBgcor1;
    [self setRightBarItem:EHRightItemMore];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getBabyFamilyPhoneList];

    
}


- (void)setRightBarItem:(EHRightItemStyle)style
{
    UIBarButtonItem *rightItem = nil;
    if (style == EHRightItemDone) {
        UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
        rightItem = rightItem1;
    }else if (style == EHRightItemMore) {
        UIBarButtonItem *rightItem2=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_ico_tbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(popMenu:)];
        rightItem = rightItem2;
    }
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)doneAction:(UIBarButtonItem *)item
{
    EHLogInfo(@"self.markArray = %@",self.markArray);
    //如果0个被选中
    if (self.markArray.count == 0) {
        [WeAppToast toast:@"请选择您要移除的亲情号码"];
        //self.markShowing = NO;
        //[self.tableView reloadData];
        //[self setRightBarItem:EHRightItemMore];
        return;
    }
    NSString *phone = [[KSLoginComponentItem sharedInstance] user_phone];
    NSMutableArray *arr = [NSMutableArray array];
    for (EHBabyFamilyPhone *data in self.markArray) {
        //NSDictionary *phoneListDict = @{kEHAttentionPhone:data.attention_phone,kEHPhoneType:(data.phone_type != nil && data.phone_type.length > 0)?data.phone_type:@"0"};
        NSDictionary *phoneListDict = @{@"phoneNumber":data.phoneNumber,@"index":[NSNumber numberWithInteger:data.index]};
        [arr addObject:phoneListDict];
    }
    _delBabyFamilyPhoneService = [EHDelBabyFamilyPhoneService new];
    WEAKSELF
    _delBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
        STRONGSELF
        for (NSUInteger i = 0; i < strongSelf.markArray.count; i++) {
            EHBabyFamilyPhone *selectedData = [strongSelf.markArray objectAtIndex:i];
           // [strongSelf.familyNumberListWithType replaceObjectAtIndex:[selectedData.phone_type integerValue] withObject:@""];
            [strongSelf.familyNumberList removeObject:selectedData];
        }
        
        if (strongSelf.familyNumberList.count>1) {
            [strongSelf setRightBarItem:EHRightItemMore];
        }else{
            [strongSelf setRightBarItem:EHRightItemNone];
        }
//        NSInteger i = 0;
//        for (id obj in strongSelf.familyNumberListWithType) {
//            
//            if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
//                i++;
//            }
//        }
//        if (i == 5) {
//            [strongSelf setRightBarItem:EHRightItemNone];
//            strongSelf.footerViewLabel.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//
//        }
//        else{
//            [strongSelf setRightBarItem:EHRightItemMore];
//            strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//        }
        [strongSelf.markArray removeAllObjects];
        [strongSelf.tableView reloadData];
        [strongSelf.selectedArray removeAllObjects];
        for (int i = 0; i < kLines; i++) {
            [strongSelf.selectedArray addObject:@NO];
        }
        //[strongSelf.familyNumberListWithType removeObjectsInArray:strongSelf.markArray];
    };
    
    _delBabyFamilyPhoneService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [WeAppToast toast:@"删除失败！"];
        [strongSelf setRightBarItem:EHRightItemMore];
        //strongSelf.markShowing = NO;
        [strongSelf.tableView reloadData];
        [strongSelf.selectedArray removeAllObjects];
        //把选中状态变回未选中状态
        for (int i = 0; i < kLines; i++) {
            [strongSelf.selectedArray addObject:@NO];
        }
    };
    
    self.markShowing = NO;
    [_delBabyFamilyPhoneService delBabyFamilyPhone:arr andAdminPhone:phone byBabyId:self.babyId];
}

-(void)popMenu:(id)sender
{
    WEAKSELF
    [EHPopMenuLIstView showMenuViewWithTitleTextArray:@[@"移除亲情电话"] menuSelectedBlock:^(NSUInteger index, EHPopMenuModel *selectItem) {
        
        EHLogInfo(@"%@",selectItem);
        STRONGSELF
    
        [strongSelf.markArray removeAllObjects];
        
        strongSelf.markShowing = YES;
        [strongSelf.tableView reloadData];
        [strongSelf setRightBarItem:EHRightItemDone];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) showActionSheet{
    RMAction *familyNumbersMode=[RMAction actionWithTitle:@"设定亲情电话" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {

    }];
    familyNumbersMode.titleColor=EH_cor3;
    familyNumbersMode.titleFont=EH_font2;
    
    
    RMAction *familyMemberMode=[RMAction actionWithTitleAndImage:[UIImage imageNamed:@"icon_select family members"] title :@"选择家庭成员" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        
         EHSelectFamilyMembersViewController *selectfamMemberController = [[EHSelectFamilyMembersViewController alloc] init];
        selectfamMemberController.babyId = self.babyId;
        selectfamMemberController.title=@"选择家庭成员";
    //    selectfamMemberController.phone_type=[ NSString stringWithFormat:@"%ld",self.familyNumberList.count+1];
        WEAKSELF
        selectfamMemberController.selectFamilyMemberBlock=^(){
            STRONGSELF
            [strongSelf getBabyFamilyPhoneList];
        };
        [self.navigationController pushViewController:selectfamMemberController animated:YES];
        
    }];
    familyMemberMode.titleColor=EH_cor3;
    familyMemberMode.titleFont=EH_font2;
    
    
    RMAction *customStyleMode=[RMAction actionWithTitleAndImage:[UIImage imageNamed:@"icon_custom editor"] title:@"自定义编辑" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        EHFamNumberEditViewController *famNumberEditViewController = [[EHFamNumberEditViewController alloc] init];
        
        famNumberEditViewController.babyId = self.babyId;
        famNumberEditViewController.phoneModel = [[EHBabyFamilyPhone alloc]init];
        famNumberEditViewController.phoneModel.index=-1;
        famNumberEditViewController.title=@"自定义编辑";
//        if (self.familyNumberList) {
//            famNumberEditViewController.phoneModel.phone_type = [NSString stringWithFormat:@"%ld",self.familyNumberList.count+1];
//        }else{
//            famNumberEditViewController.phoneModel.phone_type = @"0";
//        }
        
        WEAKSELF
        famNumberEditViewController.editBlock = ^(EHBabyFamilyPhone *phoneModel){
            STRONGSELF
            [strongSelf getBabyFamilyPhoneList];
        };
        [self.navigationController pushViewController:famNumberEditViewController animated:YES];
    }];
    customStyleMode.titleColor=EH_cor3;
    customStyleMode.titleFont=EH_font2;
    
    
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消设定" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor=EH_cor3;
    cancelAction.titleFont=EH_font2;
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleDefault];
    actionSheet.seperatorViewColor=EH_cor8;
    
    [actionSheet addAction:customStyleMode];
    [actionSheet addAction:familyMemberMode];
    [actionSheet addAction:familyNumbersMode];

    [actionSheet addAction:cancelAction];
    actionSheet.contentView=[[UIView alloc]initWithFrame:CGRectZero];
    actionSheet.disableBlurEffects=YES;
    [self presentViewController:actionSheet animated:YES completion:nil];
}



- (void)getBabyFamilyPhoneList
{

    _getBabyFamilyPhoneListService = [EHGetBabyFamilyPhoneListService new];
    
    WEAKSELF
    _getBabyFamilyPhoneListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getBabyFamilyPhoneList完成！");
        STRONGSELF
        
        EHLogInfo(@"%@",service.dataList);
        strongSelf.familyNumberList = [NSMutableArray arrayWithArray:service.dataList];
        
//        NSSortDescriptor *phoneType=[NSSortDescriptor sortDescriptorWithKey:@"phone_type" ascending:YES];
//        NSArray *descriptor=[NSArray arrayWithObject:phoneType];
//        [strongSelf.familyNumberList sortUsingDescriptors:descriptor];
        
        if (strongSelf.familyNumberList.count>1) {
            [strongSelf setRightBarItem:EHRightItemMore];
        }else {
            [strongSelf setRightBarItem:EHRightItemNone];
        }
        for(int i=0;i<strongSelf.familyNumberList.count;i++){
            EHBabyFamilyPhone *number=[strongSelf.familyNumberList objectAtIndex:i];
            
            if ([ number.phoneNumber isEqualToString:[KSAuthenticationCenter userPhone]]) {
                [strongSelf.familyNumberList removeObject:number];
                [strongSelf.familyNumberList insertObject:number atIndex:0];
                break;
            }
        }
        
        
        strongSelf.selectedArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < kLines; i++) {
            [strongSelf.selectedArray addObject:@NO];
        }
        
     //   NSUInteger num = MIN(strongSelf.familyNumberList.count, kLines);
        
        //把获得的数据按照phone_type排列
//        for (NSUInteger j = 0; j < num; j++) {
//            EHBabyFamilyPhone *data = [strongSelf.familyNumberList objectAtIndex:j];
//            [strongSelf.familyNumberListWithType replaceObjectAtIndex:[data.phone_type integerValue] withObject:data];
//        }
//
//        NSInteger m = 0;
//        for (id obj in strongSelf.familyNumberListWithType) {
//            
//            if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
//                m++;
//            }
//        }
//        if (m == 5) {
//            [strongSelf setRightBarItem:EHRightItemNone];
//            strongSelf.footerViewLabel.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//            
//        }
//        else{
//            [strongSelf setRightBarItem:EHRightItemMore];
//            strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//        }
        

        
        [strongSelf.tableView reloadData];
        
        
    };
    _getBabyFamilyPhoneListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
    };
    
    [_getBabyFamilyPhoneListService getBabyFamilyPhoneListById:self.babyId];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.familyNumberList) {
        return 1;
    }else if(self.familyNumberList.count>=8){
        return 8;
    }else if(self.markShowing){
        return self.familyNumberList.count;
    }
    return self.familyNumberList.count+1;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.row==self.familyNumberList.count||self.familyNumberList==nil)&&!self.markShowing) {
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_family telephone_add"]];
        imageView.center=cell.contentView.center;
        
        [cell.contentView addSubview:imageView];
        
        cell.backgroundColor=EHBgcor3;

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        return cell;
    }
    
        
    EHFamilyNumbersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHFamilyNumberTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EHFamilyNumbersTableViewCell" owner:self options:nil]firstObject];

    }

    cell.rankLabel.text=[NSString stringWithFormat:@"%li",(long)indexPath.row+1];
    
    //管理员信息
    
    // id model = self.familyNumberListWithType[indexPath.row];
    id model = self.familyNumberList[indexPath.row];
    
    
    [cell SetContentToCell:model markHide:!self.markShowing];
    
    //[cell SetContentToCell:model];
    EHBabyFamilyPhone *data = [self.familyNumberList objectAtIndex:indexPath.row];
    EHLogInfo(@"isCellSelected2 = %d",cell.isCellSelected);
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSInteger index=[_relationArray indexOfObject:data.relationship];
    if (index==NSNotFound) {
        cell.relationImage.image=[UIImage imageNamed:[_headImageArray lastObject]];
    }else{
        cell.relationImage.image=[UIImage imageNamed:[_headImageArray objectAtIndex:index]];
    }
    
    if (indexPath.row==0) {
        cell.arrowImage.hidden=YES;
        cell.selectImage.hidden=NO;
        cell.selectImage.image=[UIImage imageNamed:@"ico_administrator"];;
        return cell;
    }
    
    if (self.markShowing) {
        //cell.arrowImage.hidden = YES;
        
        if ([self.selectedArray[indexPath.row] boolValue]) {
            cell.selectImage.image = [UIImage imageNamed:@"public_radiobox_set_on"];
            [self.markArray addObject:data];
            
        }
        else{
            cell.selectImage.image = [UIImage imageNamed:@"public_radiobox_set_off"];
            [self.markArray removeObject:data];
            
        }
    }
    else{
        //cell.arrowImage.hidden = NO;
      //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     //   cell.selectImage.image = [UIImage imageNamed:@"public_icon_arrow"];

    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 12;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 60;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    CGFloat spaceX = tableView.separatorInset.left;
    UIView *view=[[UIView alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, 10, self.view.frame.size.width-spaceX*2, 60)];
    self.footerViewLabel = label;
    //label.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";


//    NSInteger i = 0;
//    for (id obj in self.familyNumberListWithType) {
//        
//        if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
//            i++;
//        }
//    }
//    if (i == 5) {
//        
//        label.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//        
//
//    }
//    else{
        label.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";

  //  }

    
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:EH_siz6];
    [label sizeToFit];
    label.textColor=EH_cor4;
    [view addSubview:label];
    //label.layer.borderWidth = 1;
    //NSLog(@"x = %f,y = %f,w = %f,h = %f",label.frame.origin.x,label.frame.origin.y,label.frame.size.width,label.frame.size.height);
    view.backgroundColor = [UIColor clearColor];
    
    
    return view;
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.markShowing) {
        EHFamilyNumbersTableViewCell *cell = (EHFamilyNumbersTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        if (cell.phoneLabel.text.length<1  ) {
//            return;
//        }
        if ([EHUtils isEmptyString:cell.phoneLabel.text])
        {
            return;
        }
        
        if (indexPath.row==0) {
            return;
        }
        

        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:(![self.selectedArray[indexPath.row] boolValue])]];
        
                NSArray *pathArr = @[indexPath];
        [tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    if(indexPath.row==self.familyNumberList.count||self.familyNumberList==nil){
        [self showActionSheet];
        UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor=EHBgcor4;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if(indexPath.row==0&&self.familyNumberList.count>0){
        return;
    }
    
    EHFamNumberEditViewController *famNumberEditViewController = [[EHFamNumberEditViewController alloc] init];
    WEAKSELF
    famNumberEditViewController.editBlock = ^(EHBabyFamilyPhone *phoneModel){
        STRONGSELF
        //UI是否更新
        if (phoneModel.phoneNumber.length==0&&phoneModel.relationship.length==0) {
          //  [strongSelf.familyNumberListWithType replaceObjectAtIndex:indexPath.row withObject:@""];
           // [strongSelf.familyNumberList replaceObjectAtIndex:indexPath.row withObject:@""];
            
            [self.familyNumberList removeObjectAtIndex:indexPath.row];
            

        }
        else{
           // [strongSelf.familyNumberListWithType replaceObjectAtIndex:indexPath.row withObject:phoneModel];
            [strongSelf.familyNumberList replaceObjectAtIndex:indexPath.row withObject:phoneModel];

        }
        
//        NSInteger i = 0;
//        for (id obj in strongSelf.familyNumberListWithType) {
//            
//            if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
//                i++;
//            }
//        }
//        if (i == 5) {
//            
//            strongSelf.footerViewLabel.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//            
//        }
//        else{
//            strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
//            
//        }

        
//        strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
        
        NSArray *pathArr = @[indexPath];
        [tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
    };

    famNumberEditViewController.title = @"自定义编辑";
    EHBabyFamilyPhone* modelAtRow = self.familyNumberList[indexPath.row];
    
    famNumberEditViewController.babyId = self.babyId;
    famNumberEditViewController.phoneModel = [[EHBabyFamilyPhone alloc]init];
    if ([modelAtRow isKindOfClass:[EHBabyFamilyPhone class]]) {
        famNumberEditViewController.phoneModel = modelAtRow;
    }
    famNumberEditViewController.relationShip=modelAtRow.relationship;
    
    
    [self.navigationController pushViewController:famNumberEditViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)markArray
{
    if (!_markArray) {
        _markArray = [[NSMutableArray alloc]init];
    }
    return _markArray;
}


@end
