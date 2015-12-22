//
//  EHFeedbackViewController.m
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFeedbackViewController.h"
#import "EHFeedbackTableViewCell.h"
#import "EHFeedbackTextView.h"
#import "EHInsertSuggestionService.h"
#import "EHGetQueryForFeedbackService.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"

#define kDefaultRows 20
#define kCacheRows   20
#define kEHFeedbackDate @"feedbackDate"
#define kEHFeedbackAutoReply @"感谢您提供的宝贵意见，我们会尽快进行反馈！"

@interface EHFeedbackViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)EHFeedbackTextView *textView;

@property (nonatomic, copy)NSString *content;

@property (nonatomic, assign)int pageNum;

@end

@implementation EHFeedbackViewController
{
    NSMutableArray *_modelArray;        //Model数组
    NSMutableArray *_dataArray;         //ViewModel数组，数据源
    CGFloat _textViewOffset;            //textView偏移量
    NSInteger _sendCount;               //在当前页面已发送的数量
    
    EHInsertSuggestionService *_insertSuggestionService;
    EHGetQueryForFeedbackService *_getQueryForFeedbackService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = EHBgcor1;
    _modelArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _textViewOffset = 0;
    _pageNum = 1;
    _sendCount = 0;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    manager.enableAutoToolbar = NO;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textView];
    [self configInsertSuggestionService];
    [self configGetQueryForFeedbackService];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self.textView];
    [self.view endEditing:YES];
}

#pragma mark - Events Response
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)tableViewTap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}


- (void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [self animationWithUserInfo:notification.userInfo bloack:^{
        //若列表内容高度大于差值，就平移列表，否则不平移。
        CGFloat spaceY = CGRectGetHeight(self.tableView.frame) - keyboardSize.height - CGRectGetHeight(self.textView.frame);
        if (self.tableView.contentSize.height > spaceY) {
            self.tableView.layer.transform = CATransform3DMakeTranslation(0, - keyboardSize.height, 0);
        }
        
        self.textView.layer.transform = CATransform3DTranslate(self.view.layer.transform, 0, - keyboardSize.height, 0);
    }];
}

- (void)keyBoardWillHidden:(NSNotification *)notification{
    [self animationWithUserInfo:notification.userInfo bloack:^{
        self.tableView.layer.transform = CATransform3DIdentity;
        self.textView.layer.transform=CATransform3DIdentity;
    }];
}

#pragma mark 键盘动画
- (void)animationWithUserInfo:(NSDictionary *)userInfo bloack:(void (^)(void))block
{
    // 取出键盘弹出的时间
    CGFloat duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    // 取出键盘弹出动画曲线
    NSInteger curve=[userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue];
    //开始动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    //调用bock
    block();
    [UIView commitAnimations];
}

#pragma mark - Common Methods
- (void)loadNewData{
    [self getQueryWithPage:_pageNum];
    
}

//发送内容
- (void)sendContent:(NSString *)content{
//    BOOL stringContainsEmoji = [EHUtils stringContainsEmoji:content];
//    if (stringContainsEmoji) {
//        [WeAppToast toast:@"暂时不支持表情符号哦"];
//        return;
//    }
    
    [_insertSuggestionService insertSuggestionWithUserID:[[KSLoginComponentItem sharedInstance].userId intValue] sugContent:content];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.content = content;
}

//更新发送内容到tableView界面上,并加入到首页缓存中
- (void)sendSuccessWithContent:(NSString *)content{
    EHLogInfo(@"sendSuccessWithContent:%@",content);
    _sendCount++;
    if(_sendCount >= kDefaultRows) {
        _sendCount = _sendCount - kDefaultRows;
        self.pageNum++;
    }
    [self addToTableViewWithContent:content Type:EHContentTypeSuggestion];
    
    [self autoReply];
}

- (void)autoReply{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *feedbackDateStr = [userDefaults objectForKey:kEHFeedbackDate];
    NSString *dateStr = [EHUtils stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    EHLogInfo(@"dateStr = %@",dateStr);
    
    if ([EHUtils isEmptyString:feedbackDateStr] || ([feedbackDateStr compare:dateStr] != NSOrderedSame)) {
        [self addToTableViewWithContent:kEHFeedbackAutoReply Type:EHContentTypeFeedback];
        [userDefaults setObject:dateStr forKey:kEHFeedbackDate];
        [userDefaults synchronize];
    }
}

- (void)addToTableViewWithContent:(NSString *)content Type:(NSInteger)type{
    NSString *dateStr = [EHUtils stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    EHFeedbackModel *model = [[EHFeedbackModel alloc]init];
    model.content = content;
    model.time = dateStr;
    model.type = type;
    
    EHFeedbackModel *lastModel = [_modelArray lastObject];
    EHFeedbackViewModel *viewModel = [[EHFeedbackViewModel alloc]initWithModel:model PreviousTime:lastModel.time UserHeadImageName:[KSLoginComponentItem sharedInstance].user_head_img];
    [_dataArray addObject:viewModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_dataArray.count - 1) inSection:0];
    NSArray *array = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self.textView finishSend];
    [_modelArray addObject:model];
    
    [self updateCachceWithArray:_modelArray];
}

- (void)updateCachceWithArray:(NSMutableArray *)modelArray{
    NSMutableArray *array = [NSMutableArray arrayWithArray:modelArray];
    for (EHFeedbackModel *model in array) {
        if (model.type == EHContentTypeFeedback) {
            [array removeObject:model];
            break;
        }
    }
    if (array.count > kCacheRows) {
        CGFloat location = array.count - kCacheRows;
        NSRange range = NSMakeRange(location, kCacheRows);
        array = (NSMutableArray *)[(NSArray *)array subarrayWithRange:range];
    }
    [_getQueryForFeedbackService.cacheService writeCacheWithApiName:_getQueryForFeedbackService.apiName withParam:_getQueryForFeedbackService.requestModel.params componentItemArray:array writeSuccess:nil];
    for (EHFeedbackModel *model in array) {
        NSLog(@"updatecacheDatacontent = %@",model.content);
    }
}



//滑动到上次位置
- (void)scrollTableViewToLastPosition{
    EHLogInfo(@"scrollTableViewToNewContent");
    if (_dataArray.count != 0) {
        int row = (_dataArray.count - _sendCount%kDefaultRows - 1) % kDefaultRows + 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

//滑动到最底部
- (void)scrollTableViewToEnd{
    EHLogInfo(@"scrollTableViewToEnd");
    if (_dataArray.count != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_dataArray.count - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EHFeedbackViewModel *viewModel = _dataArray[indexPath.row];
    CGFloat height = !(indexPath.row == (_dataArray.count-1))?viewModel.cellHeight:(viewModel.cellHeight + 15);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    EHFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EHFeedbackTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EHFeedbackViewModel *viewModel = _dataArray[indexPath.row];
    [cell configWithViewModel:viewModel];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Getters And Setters
- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kTextViewHeight);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.backgroundColor = EHBgcor1;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTap:)];
        [_tableView addGestureRecognizer:tap];
        
        [self setRefreshHeaderOnTableView:_tableView];  //首页加载后再懒加载->下拉刷新控件
    }
    return _tableView;
}

- (EHFeedbackTextView *)textView{
    if (!_textView) {
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - kTextViewHeight, CGRectGetWidth(self.view.frame), kTextViewHeight);
        WEAKSELF
        typeof(NSArray *) __weak weakArray = _dataArray;

        _textView = [[EHFeedbackTextView alloc]initWithFrame:frame];
        
        _textView.sendBlock = ^(NSString *content){
            NSString *sendContent = [EHUtils trimmingHeadAndTailSpaceInstring:content]; //去除空格
            [weakSelf sendContent:sendContent];
        };
        
        _textView.frameChangedBlock = ^(CGFloat offset){
            STRONGSELF
            CGRect frame = strongSelf.tableView.frame;
            frame.size.height -= offset;
            strongSelf.tableView.frame = frame;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(weakArray.count - 1) inSection:0];
            [strongSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        };
    }
    return _textView;
}

- (void)setRefreshHeaderOnTableView:(UITableView *)tableview{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载数据中 ..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    tableview.header = header;
}

//Model数组转化为ViewModel数组，当数据源
- (NSMutableArray *)dataArrayWithModelArray:(NSMutableArray *)modelArray{
    [_dataArray removeAllObjects];
    NSString *timeString = nil;
    for (EHFeedbackModel *model in modelArray) {
        EHFeedbackViewModel *viewModel = [[EHFeedbackViewModel alloc]initWithModel:model PreviousTime:timeString UserHeadImageName:[KSLoginComponentItem sharedInstance].user_head_img];
        [_dataArray addObject:viewModel];
        timeString = model.time;
    }
    return _dataArray;
}

//配置提交建议请求
- (void)configInsertSuggestionService{
    _insertSuggestionService = [EHInsertSuggestionService new];
    WEAKSELF
    _insertSuggestionService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        NSLog(@"提交成功");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [strongSelf sendSuccessWithContent:strongSelf.content];
    };
    _insertSuggestionService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        NSLog(@"提交失败");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
}

//配置获取意见反馈列表请求
- (void)configGetQueryForFeedbackService{
    _getQueryForFeedbackService = [EHGetQueryForFeedbackService new];
    _getQueryForFeedbackService.needCache = YES;
//    _getQueryForFeedbackService.onlyUserCache = YES;
    WEAKSELF
    typeof(_modelArray) __weak weakArray = _modelArray;
    typeof(_getQueryForFeedbackService) __weak weakService = _getQueryForFeedbackService;
    
    _getQueryForFeedbackService.serviceCacheDidLoadBlock = ^(WeAppBasicService* service, NSArray* cacheData){
        STRONGSELF
        EHLogInfo(@"serviceCacheDidLoadBlock");

        //加载缓存
        _dataArray = [self dataArrayWithModelArray:(NSMutableArray *)cacheData];
        [strongSelf.tableView reloadData];
        [strongSelf scrollTableViewToEnd];
    };
    
    _getQueryForFeedbackService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        EHLogInfo(@"serviceDidFinishLoadBlock");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //刷新列表
        for (int i = 0; i < service.dataList.count - _sendCount; i++) {
            EHFeedbackModel *model = service.dataList[i];
            [weakArray insertObject:model atIndex:i];
        }
        _sendCount = 0;
        _dataArray = [self dataArrayWithModelArray:weakArray];
        [strongSelf.tableView reloadData];
        
        if (self.pageNum == 1) {
            [strongSelf scrollTableViewToEnd];
        }
        else {
            if (self.pageNum == (kCacheRows / kDefaultRows)) {
                for (EHFeedbackModel *model in weakArray) {
                    NSLog(@"modelcontent = %@",model.content);
                }
                [strongSelf updateCachceWithArray:weakArray];
            }
            
            if (service.dataList.count != 0) {
                [strongSelf scrollTableViewToLastPosition];
            }
        }
        [strongSelf.tableView.header endRefreshing];
        weakService.needCache = NO;         //只缓存首页一次就取消缓存
        strongSelf.pageNum++;
        if (service.dataList.count != kDefaultRows) {
            strongSelf.tableView.header = nil;
        }
    };
    
    _getQueryForFeedbackService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        NSLog(@"serviceDidFailLoadBlock");
        STRONGSELF
        [strongSelf.tableView.header endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [WeAppToast toast:UISYSTEM_NETWORK_ERROR_TITLE];
    };
}

- (void)getQueryWithPage:(int)pageNum{
    [_getQueryForFeedbackService getQueryForFeedbackWithUserID:[[KSLoginComponentItem sharedInstance].userId intValue] Page:pageNum Rows:kDefaultRows];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
