//
//  EHGeofenceAddressSearchViewController.m
//  eHome
//
//  Created by xtq on 15/7/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//  围栏中心点搜索

#import "EHGeofenceAddressSearchViewController.h"
#import "EHAddressSearchResultTableViewCell.h"
#import "MJRefresh.h"

#define kCellHeight     49
#define kResultOffset   20
#define kTimeDuration   1       //自动搜索的停止时间间隔

@interface EHGeofenceAddressSearchViewController ()<AMapSearchDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation EHGeofenceAddressSearchViewController
{
    AMapSearchAPI *_search;
    UITextField * _searchField;
    NSTimer *_timer;
    NSMutableArray *_dataArray;         //数据源
    int _resultPageNo;                  //获取返回数据的页数
    NSString *_searchCity;              //要搜索的城市
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [self searchView];
    self.view.backgroundColor = EH_bgcor1;
    
    _dataArray = [[NSMutableArray alloc]init];
    _resultPageNo = 1;
    _searchCity = nil;
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:kMAMapAPIKey Delegate:self];
    
    [self.view addSubview:self.tableView];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer.hidden = YES;
}

#pragma mark - Events Response
/**
 *  输入框值改变时，若停止操作超过X秒就自动进行搜索
 */
- (void)searchFieldValueChanged:(id)sender{
    UITextField *textField = (UITextField *)sender;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if ([textField.text isEqualToString:@""]) {
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeDuration target:self selector:@selector(doSearch:) userInfo:nil repeats:NO];
}

/**
 *  进行搜索
 */
- (void)doSearch:(NSTimer *)timer{
    //先还原数据
    _resultPageNo = 1;
    _searchCity = nil;

    [self loadMoreData];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData{
    [_search AMapPlaceSearch: [self searchRequestWithKeyWord:_searchField.text City:_searchCity PageNo:_resultPageNo]];
}

#pragma mark - Delegate
#pragma mark - AMapSearchDelegate
/**
 *  实现POI搜索对应的回调函数
 */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSLog(@"response.count = %ld",response.count);
    NSLog(@"response.suggestion = %@",response.suggestion);
    if(response.pois.count == 0)
    {
        if (response.suggestion) {
            AMapCity *city = [response.suggestion.cities firstObject];
            _searchCity = city.city;
            [_search AMapPlaceSearch: [self searchRequestWithKeyWord:_searchField.text City:_searchCity PageNo:_resultPageNo]];
        }
        return;
    }
    if (_resultPageNo == 1) {
        [_dataArray removeAllObjects];

    }
    for (AMapPOI *p in response.pois) {
        [_dataArray addObject:p];
        NSLog(@"p = %@\n",p);
    }
    [_tableView reloadData];
    self.tableView.footer.hidden = NO;
    
    if (_dataArray.count == response.count) {
        [self.tableView.footer noticeNoMoreData];
    }
    else{
        [self.tableView.footer endRefreshing];
    }
    _resultPageNo++;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    EHAddressSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EHAddressSearchResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    AMapPOI *poi = _dataArray[indexPath.row];
    cell.nameLabel.text = poi.name;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",poi.city,poi.district];
    if ([cell.addressLabel.text isEqualToString:@""]) {
        cell.addressLabel.text = _searchCity;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *poi = _dataArray[indexPath.row];
    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    NSLog(@"1address = %@",poi.name);
    NSLog(@"1coordinate: %f,%f",poi.location.latitude,poi.location.longitude);
    !self.searchFinishedBlock?:self.searchFinishedBlock(poi.name,coordinate2D);
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark - UIView
#pragma mark - Getters And Setters
-(UIView *)searchView{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame) - 102/2.0 - 40/2.0, 44 - 20)];
    [searchView addSubview:[self searchField]];
    [searchView addSubview:[self searchBottomView]];
    
    return searchView;
}

- (UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 102/2.0 - 40/2.0, 44 - 20 - 5 - 1)];
        _searchField.layer.masksToBounds = YES;
        _searchField.layer.cornerRadius = 3;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.delegate = self;
        _searchField.font = EH_font3;
        _searchField.textColor = [UIColor whiteColor];
        UIColor *color = [UIColor whiteColor];
        _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入围栏中心关键字" attributes:@{NSForegroundColorAttributeName: color}];
        _searchField.returnKeyType = UIReturnKeyDone;
        _searchField.tintColor = [UIColor whiteColor];
        [_searchField addTarget:self action:@selector(searchFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        UIButton *searchIconView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetHeight(_searchField.frame) + 5, CGRectGetHeight(_searchField.frame))];
        [searchIconView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [searchIconView setImage:[UIImage imageNamed:@"ico_tbar_search"] forState:UIControlStateNormal];
        _searchField.leftView = searchIconView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
    }
    return  _searchField;
}

- (UIImageView *)searchBottomView{
    UIImageView *searchBottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"input_tbar"]];
    searchBottomView.frame = CGRectMake(0, 19, CGRectGetWidth(self.view.frame) - 102/2.0 - 40/2.0, 5);

    return searchBottomView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
   
    return _tableView;
}

/**
 *  配置搜索参数
 *
 *  @param keyWord 关键字
 *  @param city    城市
 *  @param pageNo  结果当前页数（默认1，加载更多时进行操作）
 */
- (AMapPlaceSearchRequest *)searchRequestWithKeyWord:(NSString *)keyWord City:(NSString *)city PageNo:(int)pageNo{
    //初始化检索对象
    
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
        poiRequest.requireExtension = YES;
    poiRequest.keywords = keyWord;
    if (city == nil) {
        poiRequest.city = nil;
    }
    else {
        poiRequest.city = @[city];
    }
    poiRequest.offset = kResultOffset;
    poiRequest.page = pageNo;
    return poiRequest;
}

- (void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
