//
//  EHMessageInfoListView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageInfoListView.h"
#import "EHMessageInfoCell.h"
#import "EHBabyMsgInfoCell.h"
#import "EHMessageCellModelInfoItem.h"
#import "EHMessageInfoListService.h"

@interface EHMessageInfoListView()

@property (nonatomic,strong) EHMessageInfoListService*      messageInfoService;

@property (nonatomic,strong) KSDataSource*                  dataSourceRead;

@property (nonatomic,strong) KSDataSource*                  dataSourceWrite;

@end

@implementation EHMessageInfoListView

-(void)setupView{
    [super setupView];
//    UILabel *timeStamp=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    timeStamp.text=@"今天";
//    timeStamp.textColor=EH_cor5;
//    [timeStamp setFont:[UIFont boldSystemFontOfSize:15]];
//    timeStamp.textAlignment = NSTextAlignmentCenter;
//    self.tableViewCtl.tableHeaderView=timeStamp;
    [self addSubview:self.tableViewCtl.scrollView];
}
- (void)setMessage_type:(NSInteger)message_type
{
    _message_type=message_type;
    [self refreshDataRequestWithType:message_type];
}
-(void)refreshDataRequestWithType:(NSInteger)type{
    [self refreshDataRequestWithBabyId:nil andMsgType:type];
}

-(void)refreshDataRequestWithBabyId:(NSString*)babyId andMsgType:(NSInteger)type{
    [self.messageInfoService loadMessageInfoListWithBabyId:babyId userPhone:[KSAuthenticationCenter userPhone] Type:self.message_type];
    [self.tableViewCtl.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)dealloc{
    _tableViewCtl = nil;
    _dataSourceRead = nil;
    _dataSourceWrite = nil;
}

-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [_tableViewCtl setErrorViewTitle:@"宝贝暂无消息"];
        [_tableViewCtl setHasNoDataFootViewTitle:@"已无宝贝信息可同步"];
        [_tableViewCtl setNextFootViewTitle:@""];
//        [_tableViewCtl registerClass:[EHMessageInfoCell class]];
        [_tableViewCtl registerClass:[EHBabyMsgInfoCell class]];
        [_tableViewCtl setService:self.messageInfoService];
        [_tableViewCtl setDataSourceRead:self.dataSourceRead];
        [_tableViewCtl setDataSourceWrite:self.dataSourceWrite];
    }
    return _tableViewCtl;
}

-(EHMessageInfoListService *)messageInfoService{
    if (_messageInfoService == nil) {
        _messageInfoService = [EHMessageInfoListService new];
        WEAKSELF
        _messageInfoService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _messageInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            
        };
        _messageInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
    }
    return _messageInfoService;
}

-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc] init];
        _dataSourceRead.modelInfoItemClass = [EHMessageCellModelInfoItem class];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc] init];
        _dataSourceWrite.modelInfoItemClass = [EHMessageCellModelInfoItem class];
    }
    return _dataSourceWrite;
}

@end
