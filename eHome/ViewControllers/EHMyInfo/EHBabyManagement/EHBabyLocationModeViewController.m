//
//  EHBabySafeModeViewController.m
//  eHome
//
//  Created by jss on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyLocationModeViewController.h"
#import "Masonry.h"
#import "RMActionController.h"
#import "EHSetLocationModeService.h"


@interface EHBabyLocationModeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIButton *locationModeBtn;
@property (nonatomic,strong) UILabel *locationModeLabel;
@property (nonatomic,strong) UILabel *babyLocationModeLabel;
@property (nonatomic,strong) EHSetLocationModeService *setLocationModeService;

@property(nonatomic,strong)GroupedTableView *tableView;
@property(nonatomic,strong)UIButton *busyBtn;
@property(nonatomic,strong)UIButton *normalBtn;
@property(nonatomic,strong)UIButton *lazyBtn;
@property(nonatomic,strong)UIButton *currentSelectBtn;
@end

@implementation EHBabyLocationModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"定位模式";
    self.view.backgroundColor=EH_bgcor1;
    [self configTableView];
}
- (void)configTableView
{
    self.tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(12, 20, SCREEN_WIDTH-20, SCREEN_HEIGHT)];
    self.tableView.backgroundColor = EH_bgcor1;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.tableFooterView = [[UIView alloc] init];
}
//actionSheetUI配置
- (void)configUI
{
    _locationModeBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    _locationModeBtn.backgroundColor=[UIColor whiteColor];
    [_locationModeBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:EH_font3 forKey:NSFontAttributeName];
    CGSize sizeForLabel=[self.locationModeLabel.text boundingRectWithSize:CGSizeMake(80, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _locationModeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _locationModeLabel.text=@"定位模式";
    _locationModeLabel.textColor=EH_cor4;
    _locationModeLabel.font=EH_font3;
    _locationModeLabel.size=sizeForLabel;
    
    _babyLocationModeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    _babyLocationModeLabel.text = [self getBabyLocationMode:self.locationMode];
    _babyLocationModeLabel.textColor=EH_cor5;
    _babyLocationModeLabel.font=EH_font3;
    _babyLocationModeLabel.size=sizeForLabel;
    
    [self.view addSubview:_locationModeBtn];
    [self.locationModeBtn addSubview:_locationModeLabel];
    [self.locationModeBtn addSubview:_babyLocationModeLabel];
    
    [self.locationModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [self.locationModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20*SCREEN_SCALE);
        make.centerY.equalTo(_locationModeBtn.mas_centerY);
    }];
    [self.babyLocationModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20*SCREEN_SCALE);
        make.centerY.equalTo(_locationModeBtn.mas_centerY);
    }];
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

-(void) showActionSheet:(id)sender{
    RMAction *precisionMode=[RMAction actionWithTitle:@"追踪模式  2min" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self changLocationMode:@"1"];
    }];
    
    
//    RMAction *test=[RMAction actionWithTitle:<#(NSString *)#> style:<#(RMActionStyle)#> andHandler:<#^(RMActionController *controller)handler#>];
    
    precisionMode.titleColor=EH_cor3;
    precisionMode.titleFont=EH_font2;
    RMAction *normalMode=[RMAction actionWithTitle:@"普通模式  10min" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self changLocationMode:@"2"];
    }];
    normalMode.titleColor=EH_cor3;
    normalMode.titleFont=EH_font2;
    RMAction *powerSavingMode=[RMAction actionWithTitle:@"省电模式  20min" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        [self changLocationMode:@"3"];
    }];
    powerSavingMode.titleColor=EH_cor3;
    powerSavingMode.titleFont=EH_font2;
    RMAction *cancelAction=[RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
    }];
    cancelAction.titleColor=EH_cor3;
    cancelAction.titleFont=EH_font2;
    RMActionController *actionSheet=[RMActionController actionControllerWithStyle:RMActionControllerStyleDefault];
    actionSheet.seperatorViewColor=EH_cor8;
    [actionSheet addAction:powerSavingMode];
    [actionSheet addAction:normalMode];
    [actionSheet addAction:precisionMode];
    [actionSheet addAction:cancelAction];
    actionSheet.contentView=[[UIView alloc]initWithFrame:CGRectZero];
    actionSheet.disableBlurEffects=YES;
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)changLocationMode:(NSString *)locationMode
{
    _setLocationModeService= [EHSetLocationModeService new];
    
    WEAKSELF
    _setLocationModeService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"设置完成！");
        [WeAppToast toast:@"定位模式设置成功"];
        STRONGSELF
        dispatch_async( dispatch_get_main_queue(), ^{
//            strongSelf.babyLocationModeLabel.text=mode;
            [strongSelf.tableView reloadData];
        });
        
        if (strongSelf.modifyLocationModeSuccess)
        {
            strongSelf.modifyLocationModeSuccess(locationMode);
        }
    };
    _setLocationModeService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"定位模式设置失败"];
    };
    
//    EHGetBabyListRsp* currentBabyUserInfo=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    NSString *baby_Id=[NSString stringWithFormat:@"%@",self.babyId];
    self.locationMode = locationMode;
    [_setLocationModeService setLocationMode:baby_Id babyLocationMode:locationMode];
}
- (UIButton *)busyBtn
{
    if (!_busyBtn) {
        _busyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 44, 0, 44, 44)];
        _busyBtn.tag = 1000;
        _busyBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        [_busyBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _busyBtn;
}
- (UIButton *)normalBtn
{
    if (!_normalBtn) {
        _normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 44, 0, 44, 44)];
        _normalBtn.tag = 1001;
        _normalBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        [_normalBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _normalBtn;
}
- (UIButton *)lazyBtn
{
    if (!_lazyBtn) {
        _lazyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 44, 0, 44, 44)];
        _lazyBtn.tag = 1002;
        _lazyBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        [_lazyBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lazyBtn;
}
- (void)buttonSelected:(UIButton *)sender
{
    if ((self.currentSelectBtn == self.busyBtn&&sender.tag == 1000)||(self.currentSelectBtn == self.normalBtn&&sender.tag == 1001)||(self.currentSelectBtn == self.lazyBtn&&sender.tag == 1002)) {
        return;
    }
    switch (sender.tag) {
        case 1000:{
            [self changLocationMode:@"1"];
            break;
        }
        case 1001:{
            [self changLocationMode:@"2"];
            break;
        }
        case 1002:{
            [self changLocationMode:@"3"];
            break;
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView DataSource &Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kEHHealehySetCellID = @"kEHHealehySettingCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEHHealehySetCellID];
    UILabel *modelLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    modelLabel.textColor = EHCor5;
    modelLabel.font = EH_font4;
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kEHHealehySetCellID];
        [cell addSubview:modelLabel];
        [modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(12);
            make.centerY.equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100*SCREEN_SCALE, 20));
        }];
    }
    switch (indexPath.row) {
        case 0:{
            modelLabel.text = @"追踪模式";
            [cell addSubview:self.busyBtn];
            if([_locationMode isEqualToString:@"1"]){
                [_busyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
                self.currentSelectBtn = _busyBtn;
            }else
            {
                [_busyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
            }
            break;
        }
        case 1:{
            modelLabel.text = @"普通模式";
            [cell addSubview:self.normalBtn];
            if([_locationMode isEqualToString:@"2"]){
                [_normalBtn setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
                self.currentSelectBtn = _normalBtn;
            }else
            {
                [_normalBtn setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
            }
            break;
        }
        case 2:{
            modelLabel.text = @"省电模式";
            [cell addSubview:self.lazyBtn];
            if([_locationMode isEqualToString:@"3"]){
                [_lazyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
                self.currentSelectBtn = _lazyBtn;
            }else
            {
                [_lazyBtn setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
            }
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 0) {
        return nil;
    }
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), [self tableView: _tableView heightForFooterInSection:section])];
    CGFloat spaceX = tableView.separatorInset.left;
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, 10, CGRectGetWidth(_tableView.frame) - spaceX * 2, 50)];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    textLabel.font = EHFont4;
    textLabel.textColor = EHCor3;
    [footerView addSubview:textLabel];
    if (self.currentSelectBtn == _busyBtn) {
        textLabel.text = @"追踪模式采用gps+基站混合定位，采用追踪模式会减少手表待机时间";
    }else if (self.currentSelectBtn == _normalBtn){
        textLabel.text = @"普通模式采用基站定位，每隔1分钟定位一次";
    }else{
        textLabel.text = @"省电模式采用基站定位，每隔20分钟定位一次";
    }
    [textLabel sizeToFit];
    return footerView;
}
@end
