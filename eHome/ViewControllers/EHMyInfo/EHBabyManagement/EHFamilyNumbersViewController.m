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

#define kLines 5


typedef enum : NSUInteger {
    EHRightItemNone = 0,
    EHRightItemMore = 1,
    EHRightItemDone = 2,
} EHRightItemStyle;

@interface EHFamilyNumbersViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    EHDelBabyFamilyPhoneService *_delBabyFamilyPhoneService;
    EHGetBabyFamilyPhoneListService * _getBabyFamilyPhoneListService;
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
    
    self.selectedArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < kLines; i++) {
        [self.selectedArray addObject:@NO];
    }
    
    NSUInteger num = MIN(self.familyNumberList.count, kLines);
    
    //把获得的数据按照phone_type排列
    for (NSUInteger j = 0; j < num; j++) {
        EHBabyFamilyPhone *data = [self.familyNumberList objectAtIndex:j];
    [self.familyNumberListWithType replaceObjectAtIndex:[data.phone_type integerValue] withObject:data];
    }
//    [NSNumber numberWithInteger:[self.phoneModel.phone_type integerValue]]
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UINib *nib = [UINib nibWithNibName:@"EHFamilyNumbersTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EHFamilyNumberTableViewCell"];
    [self.view addSubview:self.tableView];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self setRightBarItem:EHRightItemMore];
    [self getBabyFamilyPhoneList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger i = 0;
    for (id obj in self.familyNumberListWithType) {
        
        if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
            i++;
        }
    }
    if (i == 5) {
        [self setRightBarItem:EHRightItemNone];
        self.footerViewLabel.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";

    }
    else{
        [self setRightBarItem:EHRightItemMore];
        self.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
    }


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
        self.markShowing = NO;
        //
        [self.tableView reloadData];
        //
        [self setRightBarItem:EHRightItemMore];
        //self.
        return;
    }
    NSString *phone = [[KSLoginComponentItem sharedInstance] user_phone];
    NSMutableArray *arr = [NSMutableArray array];
    for (EHBabyFamilyPhone *data in self.markArray) {
        //NSDictionary *phoneListDict = @{kEHAttentionPhone:data.attention_phone,kEHPhoneType:(data.phone_type != nil && data.phone_type.length > 0)?data.phone_type:@"0"};
        NSDictionary *phoneListDict = @{kEHAttentionPhone:data.attention_phone,kEHPhoneType:[NSNumber numberWithInteger:[data.phone_type integerValue]]};
        [arr addObject:phoneListDict];
    }
    _delBabyFamilyPhoneService = [EHDelBabyFamilyPhoneService new];
    WEAKSELF
    _delBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
        STRONGSELF
        for (NSUInteger i = 0; i < strongSelf.markArray.count; i++) {
            EHBabyFamilyPhone *selectedData = [strongSelf.markArray objectAtIndex:i];
            [strongSelf.familyNumberListWithType replaceObjectAtIndex:[selectedData.phone_type integerValue] withObject:@""];            
        }
        NSInteger i = 0;
        for (id obj in strongSelf.familyNumberListWithType) {
            
            if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
                i++;
            }
        }
        if (i == 5) {
            [strongSelf setRightBarItem:EHRightItemNone];
            strongSelf.footerViewLabel.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";

        }
        else{
            [strongSelf setRightBarItem:EHRightItemMore];
            strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
        }
        //strongSelf.markShowing = NO;
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


- (void)getBabyFamilyPhoneList
{

    _getBabyFamilyPhoneListService = [EHGetBabyFamilyPhoneListService new];
    
    WEAKSELF
    _getBabyFamilyPhoneListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getBabyFamilyPhoneList完成！");
        STRONGSELF
        
        EHLogInfo(@"%@",service.dataList);
        strongSelf.familyNumberList = [NSMutableArray arrayWithArray:service.dataList];
        
        strongSelf.selectedArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < kLines; i++) {
            [strongSelf.selectedArray addObject:@NO];
        }
        
        NSUInteger num = MIN(strongSelf.familyNumberList.count, kLines);
        
        //把获得的数据按照phone_type排列
        for (NSUInteger j = 0; j < num; j++) {
            EHBabyFamilyPhone *data = [strongSelf.familyNumberList objectAtIndex:j];
            [strongSelf.familyNumberListWithType replaceObjectAtIndex:[data.phone_type integerValue] withObject:data];
        }
        
        [strongSelf.tableView reloadData];
        
        
    };
    _getBabyFamilyPhoneListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
    };
    
    [_getBabyFamilyPhoneListService getBabyFamilyPhoneListById:self.babyId];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kLines;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EHFamilyNumbersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHFamilyNumberTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EHFamilyNumbersTableViewCell" owner:self options:nil]firstObject];
    }
//    if (!self.markShowing) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    }
    
    cell.rankLabel.text=[NSString stringWithFormat:@"%li",(long)indexPath.row+1];
    
    //管理员信息
    
    id model = self.familyNumberListWithType[indexPath.row];
    
    [cell SetContentToCell:model markHide:!self.markShowing];
    //[cell SetContentToCell:model];
    EHBabyFamilyPhone *data = [self.familyNumberListWithType objectAtIndex:indexPath.row];
    EHLogInfo(@"isCellSelected2 = %d",cell.isCellSelected);

    if (self.markShowing) {
        //cell.arrowImage.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;

        
        if ([self.selectedArray[indexPath.row] boolValue]) {
            cell.selectImage.image = [UIImage imageNamed:@"btn_checkbox_press"];
            [self.markArray addObject:data];
            
        }
        else{
            cell.selectImage.image = [UIImage imageNamed:@"btn_checkbox_normal"];
            [self.markArray removeObject:data];
            
        }
    }
    else{
        //cell.arrowImage.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
    }
    //cell.separatorInset
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

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


    NSInteger i = 0;
    for (id obj in self.familyNumberListWithType) {
        
        if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
            i++;
        }
    }
    if (i == 5) {
        
        label.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";
        

    }
    else{
        label.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";

    }

    
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
        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:(![self.selectedArray[indexPath.row] boolValue])]];
        
                NSArray *pathArr = @[indexPath];
        [tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    EHFamNumberEditViewController *famNumberEditViewController = [[EHFamNumberEditViewController alloc] init];
    WEAKSELF
    famNumberEditViewController.editBlock = ^(EHBabyFamilyPhone *phoneModel){
        STRONGSELF
        //UI是否更新
        if (phoneModel.attention_phone.length==0&&phoneModel.phone_name.length==0) {
            [strongSelf.familyNumberListWithType replaceObjectAtIndex:indexPath.row withObject:@""];
        }
        else{
            [strongSelf.familyNumberListWithType replaceObjectAtIndex:indexPath.row withObject:phoneModel];
            
        }
        
        NSInteger i = 0;
        for (id obj in strongSelf.familyNumberListWithType) {
            
            if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) {
                i++;
            }
        }
        if (i == 5) {
            
            strongSelf.footerViewLabel.text = @"您一共可以添加5个宝贝亲情电话，宝贝的亲情电话可以与宝贝的手表进行双向通话。";
            
        }
        else{
            strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
            
        }

        
//        strongSelf.footerViewLabel.text = @"宝贝的亲情电话可以与宝贝的手表进行双向通话。";
        
        NSArray *pathArr = @[indexPath];
        [tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
    };

    famNumberEditViewController.title = [NSString stringWithFormat:@"号码%d编辑",indexPath.row+1];
    //self.tableView.c
//    - (IBAction)selectAction:(id)sender
//    {
//        UIButton *btn = (UIButton *)sender;
//        btn.selected = !btn.selected;
//        self.selectedComplete(btn.selected);
//    }

    
    id modelAtRow = self.familyNumberListWithType[indexPath.row];
    
    famNumberEditViewController.babyId = self.babyId;
    
    famNumberEditViewController.phoneModel = [[EHBabyFamilyPhone alloc]init];
    if ([modelAtRow isKindOfClass:[EHBabyFamilyPhone class]]) {
        famNumberEditViewController.phoneModel = modelAtRow;
    }else {
        famNumberEditViewController.phoneModel.phone_type = [NSString stringWithFormat:@"%d",indexPath.row];
    }
    
    
    
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

- (NSMutableArray *)familyNumberListWithType
{
    if (!_familyNumberListWithType) {
        _familyNumberListWithType = [[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@""]];
    }
    return _familyNumberListWithType;
}

@end
