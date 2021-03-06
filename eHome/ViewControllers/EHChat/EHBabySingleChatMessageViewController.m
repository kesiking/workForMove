//
//  EHBabySingleChatMessageViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/9/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabySingleChatMessageViewController.h"
#import "EHChatMessageLIstService.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "EHSingleChatCacheManager.h"
#import "XHAudioPlayerHelper.h"
#import "XHBabyChatMessage.h"
#import "XHAudioPlayerHelper+EHAudioPlayerDownload.h"
#import "EHBabyMessageTableViewCell.h"
#import "EHChatMessageTimestampCaculater.h"

@interface EHBabySingleChatMessageViewController () <XHAudioPlayerHelperDelegate>{
    XHVoiceRecordHelper         *_voiceRecordHelper;
}

@property (nonatomic, strong) XHMessageTableViewCell   * currentSelectedCell;

@property (nonatomic, strong) EHChatMessageLIstService * chatMessageListService;

@property (nonatomic, strong) UILabel                  * headerHasNoDatalabel;

@property (nonatomic, strong) EHChatMessageTimestampCaculater                  * chatMessageTimestampCaculater;

@property (nonatomic, strong) NSNumber                 * babyId;

@property (nonatomic, strong) NSArray                  * emotionManagers;
@end

@implementation EHBabySingleChatMessageViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.babyId = [nativeParams objectForKey:@"babyId"];
    }
    return self;
}

- (void)loadSingleChatMessageListDataSource {
    NSNumber* babyId = self.babyId;;
    if (babyId == nil) {
        babyId = self.babyUserInfo.babyId;
    }
    if (babyId == nil) {
        babyId = [NSNumber numberWithInteger:[[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]];
    }
    // 方案一  如果是当前聊天宝贝才接受insert否则都不更新数据库，避免漏掉聊天数据
    [[EHBabyListDataCenter sharedCenter] setCurrentChatBabyId:[NSString stringWithFormat:@"%@",babyId]];
    if (babyId && [babyId integerValue]!= 0 && ![KSAuthenticationCenter isTestAccount]) {
        [self.chatMessageListService loadChatMessageListWithBabyId:babyId userPhone:[KSAuthenticationCenter userPhone]];
    }else{
        //清空service和messages数组所有数据
        [self.chatMessageListService.pagedList refresh];
        [self.chatMessageListService.pagedList removeAllObjects];
        [self.messages removeAllObjects];
        [self.messageTableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    [self.inputView resignFirstResponder];
    [self layoutOtherMenuViewHiden:YES];
}
- (void) reloadDataWithBabyId: (NSNumber *)babyId
{
    self.babyId = babyId;
    [self loadSingleChatMessageListDataSource];
}

- (id)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
        self.allowsSendVoice = YES;
        self.allowsSendFace = YES;
        self.allowsSendMultiMedia = NO;
        self.allowsPhoneCall = YES;
    }
    return self;
}
-(EHGetBabyListRsp *)babyUserInfo{
    return _babyUserInfo?_babyUserInfo:[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
}

-(KSLoginComponentItem *)userInfoComponentItem{
    return [KSAuthenticationCenter userComponent];
}

-(UILabel *)headerHasNoDatalabel{
    if (_headerHasNoDatalabel == nil) {
        UIView* headerContainerView = [self valueForKey:@"_headerContainerView"];
        _headerHasNoDatalabel = [[UILabel alloc] initWithFrame:headerContainerView.bounds];
        [_headerHasNoDatalabel setTextColor:EH_cor5];
        [_headerHasNoDatalabel setFont:[UIFont boldSystemFontOfSize:12]];
        [_headerHasNoDatalabel setBackgroundColor:[UIColor clearColor]];
        [_headerHasNoDatalabel setNumberOfLines:1];
        [_headerHasNoDatalabel setTextAlignment:NSTextAlignmentCenter];
        _headerHasNoDatalabel.hidden = YES;
        [_headerHasNoDatalabel setText:@"没有更多的内容了哦"];
        [headerContainerView addSubview:_headerHasNoDatalabel];
    }
    return _headerHasNoDatalabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (CURRENT_SYS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    }
    self.title = NSLocalizedStringFromTable(@"Chat", @"MessageDisplayKitString", @"聊天");
    // 设置chatMessage外框
    [self configChatMessageView];
    // Custom UI
    [self setBackgroundColor:[UIColor whiteColor]];
    // init Notification
    [self initNotification];
    // init ChatMessageTimestampCaculater
    [self initChatMessageTimestampCaculater];

    // 设置自身用户名
    self.messageSender = [KSAuthenticationCenter userPhone];
    
    // 表情配置
    [self configEmotionsData];
    
    [self loadSingleChatMessageListDataSource];
}

- (void) configEmotionsData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EHChatEmotionUI" ofType:@"plist"];
    NSDictionary *emotionsDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSMutableArray *emotionManagers = [NSMutableArray array];
    XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
    emotionManager.emotionName = @"表情";
    NSMutableArray *emotions = [NSMutableArray array];
    //说明 由于UICollectionView目录顺序和编码不相同，维护两个plist文件，一个用于布局UI，一个用于编码查询
    for (NSInteger i = 1; i <= 16; i++) {
        XHEmotion *emotion = [[XHEmotion alloc] init];
        NSDictionary *modelDic = [emotionsDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
        NSString *imageName = [modelDic objectForKey:@"imageName"];
        emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", imageName] ofType:@"png"];
        emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
        emotion.text = [modelDic objectForKey:@"textName"];
        [emotions addObject:emotion];
    }
    emotionManager.emotions = emotions;
    [emotionManagers addObject:emotionManager];
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
}

- (void)configChatMessageView{
    [[XHConfigurationHelper appearance] setupPopMenuTitles:@[NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息")]] ;
    [[XHConfigurationHelper appearance] setupMessageTableStyle:@{kXHMessageTableAvatarPalceholderImageNameKey:@"tabitem_info_normal"}];
    _voiceRecordHelper = [self valueForKey:@"voiceRecordHelper"];
    _voiceRecordHelper.maxRecordTime = 10;
    _voiceRecordHelper.recordProgress = ^(float progress){
        
    };
    XHStopRecorderCompletion maxTimeStopRecorderCompletion = _voiceRecordHelper.maxTimeStopRecorderCompletion;
    WEAKSELF
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
        STRONGSELF
        if (maxTimeStopRecorderCompletion) {
            maxTimeStopRecorderCompletion();
        }
        if (strongSelf.babyUserInfo.babyId && ![KSAuthenticationCenter isTestAccount]) {
            [WeAppToast toast:@"录音时间到"];
        }else if (strongSelf.babyUserInfo.babyId && [KSAuthenticationCenter isTestAccount]){
            [WeAppToast toast:@"请先登录"];
        }else{
            [WeAppToast toast:@"当前用户暂无宝贝，请绑定宝贝！"];
        }
    };
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveBabyChatMessage:) name:EHRecieveSelectedBabyChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasXiaoxiHistoryChatMessage:) name:EHXiaoXiHistoryChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
}

-(void)initChatMessageTimestampCaculater{
    _chatMessageTimestampCaculater = [EHChatMessageTimestampCaculater new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    // 方案一  如果是当前聊天宝贝才接受insert否则都不更新数据库，避免漏掉聊天数据
    [[EHBabyListDataCenter sharedCenter] setCurrentChatBabyId:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(EHChatMessageLIstService *)chatMessageListService{
    if (_chatMessageListService == nil) {
        _chatMessageListService = [EHChatMessageLIstService new];
        WEAKSELF
        _chatMessageListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            if (service.pagedList) {
                [strongSelf.messages removeAllObjects];
                [strongSelf.messages addObjectsFromArray:[service.pagedList getItemList]];
                [strongSelf configChatMessageTimestampWithPagelist:service.pagedList];
            }
            [strongSelf.messageTableView reloadData];
            if ([strongSelf isMessageDataListHistoryWithPagelist:service.pagedList]) {
                [strongSelf showMessageTableViewHistoryDataListSmoothlyWithPagelist:service.pagedList];
                strongSelf.loadingMoreMessage = NO;
            }else{
                [strongSelf showMessageTableViewNewDataListSmoothlyWithPagelist:service.pagedList];
            }
        };
        _chatMessageListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            strongSelf.loadingMoreMessage = NO;
        };
    }
    return _chatMessageListService;
}

-(void)showMessageTableViewHistoryDataListSmoothlyWithPagelist:(WeAppBasicPagedList*)pagelist{
    if (pagelist == nil || ![pagelist isKindOfClass:[EHChatMessagePageList class]]) {
        return;
    }
    EHChatMessagePageList* chatMessagePageList = (EHChatMessagePageList*)pagelist;
    if (chatMessagePageList.insertListType != KSInsertListTypeBeforPagelist) {
        return;
    }
    NSInteger index = [chatMessagePageList.insertDataList count];
    if (index > 0 && index < [chatMessagePageList count]) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        UIView* headerContainerView = [self valueForKey:@"_headerContainerView"];
        [self.messageTableView setContentOffset:CGPointMake(self.messageTableView.contentOffset.x, self.messageTableView.contentOffset.y - headerContainerView.height) animated:NO];
    }
}

-(void)showMessageTableViewNewDataListSmoothlyWithPagelist:(WeAppBasicPagedList*)pagelist{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToBottomAnimated:NO];
    });
}

-(BOOL)isMessageDataListHistoryWithPagelist:(WeAppBasicPagedList*)pagelist{
    if (pagelist == nil || ![pagelist isKindOfClass:[EHChatMessagePageList class]]) {
        return NO;
    }
    EHChatMessagePageList* chatMessagePageList = (EHChatMessagePageList*)pagelist;
    if (chatMessagePageList.isRefresh) {
        return NO;
    }
    if (chatMessagePageList.insertDataList && chatMessagePageList.insertDataList.count > 0) {
        if (chatMessagePageList.insertListType == KSInsertListTypeAfterPagelist) {
            return NO;
        }
        if (chatMessagePageList.insertListType == KSInsertListTypeBeforPagelist) {
            return YES;
        }
    }
    return YES;
}

-(void)configChatMessageTimestampWithPagelist:(WeAppBasicPagedList*)pagelist{
    if (pagelist == nil || ![pagelist isKindOfClass:[EHChatMessagePageList class]]) {
        return;
    }
    EHChatMessagePageList* chatMessagePageList = (EHChatMessagePageList*)pagelist;
    if (chatMessagePageList.insertDataList == nil) {
        return;
    }
    if (chatMessagePageList.insertListType == KSInsertListTypeBeforPagelist) {
        [self.chatMessageTimestampCaculater configChatMessageTimestampBeforChatlist:chatMessagePageList.insertDataList];
    }else if (chatMessagePageList.insertListType == KSInsertListTypeAfterPagelist){
        [self.chatMessageTimestampCaculater configChatMessageTimestampAfterChatlist:chatMessagePageList.insertDataList];
    }
    [self configChatMessageEarliestTimestampWithMessageIfNeed];
}

-(void)configChatMessageEarliestTimestampWithMessageIfNeed{
    if (![self.chatMessageListService hasMoreData]) {
        XHBabyChatMessage* chatMessage = [self safeGetChatMessageWithMessageInfoObj:[[self.chatMessageListService.pagedList getItemList] firstObject]];
        [self.chatMessageTimestampCaculater configChatMessageEarliestTimestampWithMessage:chatMessage];
    }
}

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            
            id messageObj = [self.messages objectAtIndex:[indexPath row]];
            EHChatMessageinfoModel* chatMessageModel = nil;
            if (messageObj && [messageObj isKindOfClass:[EHChatMessageinfoModel class]]) {
                chatMessageModel = (EHChatMessageinfoModel*)messageObj;
            }else if(messageObj && [messageObj isKindOfClass:[XHBabyChatMessage class]]){
                chatMessageModel = [EHChatMessageinfoModel makeMessage:(XHBabyChatMessage*)messageObj];
            }
            // Mark the voice as read and hide the red dot.
            if (chatMessageModel && [chatMessageModel isKindOfClass:[EHChatMessageinfoModel class]]) {
                message.isRead = YES;
                [[EHSingleChatCacheManager sharedCenter] updateBabyChatMessage:chatMessageModel writeSuccess:^(BOOL success) {
                    EHLogInfo(@"-----> message 是否已读 设置成功");
                }];
            }
            
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                if (message.voicePath) {
                    [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
                }else if (message.voiceUrl){
                    [[XHAudioPlayerHelper shareInstance] managerAudioWithUrl:message.voiceUrl toPlay:YES];
                }
            }
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    EHLogInfo(@"indexPath : %@", message);
    if (![message isKindOfClass:[XHBabyChatMessage class]]) {
        return;
    }
    XHBabyChatMessage* chatMessage = (XHBabyChatMessage*)message;
    // 如果是宝贝发送的，则跳转到宝贝详情
    if (chatMessage.messageIsFromBaby && chatMessage.bubbleMessageType == XHBubbleMessageTypeReceiving && self.babyUserInfo) {
        TBOpenURLFromSourceAndParams(internalURL(@"EHBabyUserDetailViewController"), self, @{@"babyUser":self.babyUserInfo});
    }
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    BOOL hasMoreData = [self.chatMessageListService hasMoreData];
    
    if (hasMoreData) {
        self.headerHasNoDatalabel.hidden = YES;
    }else{
        self.headerHasNoDatalabel.hidden = NO;
    }
    
    if (!self.loadingMoreMessage && hasMoreData) {
        self.loadingMoreMessage = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatMessageListService nextPage];
        });
    }else{
        self.loadingMoreMessage = NO;
    }
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    text = [self trimTextWithText:text];;
    if (![self checkTextValid:text]) {
        return;
    }
    XHBabyChatMessage *textMessage = [[XHBabyChatMessage alloc] initWithText:text sender:sender timestamp:date];
    if (self.babyUserInfo.babyId && ![KSAuthenticationCenter isTestAccount]) {
        [self configMessage:textMessage];
        [self sendMessage:textMessage];
    }else if (self.babyUserInfo.babyId && [KSAuthenticationCenter isTestAccount]){
        [WeAppToast toast:@"请先登录"];
    }else{
        [WeAppToast toast:@"当前用户暂无宝贝，请绑定宝贝！"];
    }
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    if ([voiceDuration doubleValue] < 1.0) {
        [WeAppToast toast:@"录音时间太短"];
        return;
    }
    XHBabyChatMessage *voiceMessage = [[XHBabyChatMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    if (self.babyUserInfo.babyId && ![KSAuthenticationCenter isTestAccount]) {
        [self configMessage:voiceMessage];
        [self sendMessage:voiceMessage];
    }else if (self.babyUserInfo.babyId && [KSAuthenticationCenter isTestAccount]){
        [WeAppToast toast:@"请先登录"];
    }else{
        [WeAppToast toast:@"当前用户暂无宝贝，请绑定宝贝！"];
    }}
/**
 *  发送表情的回调方法
 *
 *  @param emotionPath         目标表情本地路径
 *  @param indexPath           目标表情所在的位置
 *  @param sender              发送者的名字
 *  @param date                发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath indexPath:(NSIndexPath *)indexPath fromSender:(NSString *)sender onDate:(NSDate *)date
{
    //由于表情使用的是PNG图片格式，这里用Image来做
    XHBabyChatMessage *emotionMessage = [[XHBabyChatMessage alloc] initWithPhoto:nil thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    emotionMessage.text = [self getEmotionEncodingFromIndexPath:indexPath];
    if (self.babyUserInfo.babyId && ![KSAuthenticationCenter isTestAccount]) {
        [self configMessage:emotionMessage];
        [self sendMessage:emotionMessage];
    }else if (self.babyUserInfo.babyId && [KSAuthenticationCenter isTestAccount]){
        [WeAppToast toast:@"请先登录"];
    }else{
        [WeAppToast toast:@"当前用户暂无宝贝，请绑定宝贝！"];
    }

}
- (NSString *)getEmotionEncodingFromIndexPath:(NSIndexPath *)indexPath
{
    //说明 由于UICollectionView目录是先纵向再横向，需要的编码是先横向再纵向 作一次转换 key为index位置，value为对应表情编码
    NSString *indexString = [NSString stringWithFormat:@"%03ld" , (indexPath.row + 1)];
    NSMutableArray *keysArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= 16; i++) {
        NSString *keyString = [NSString stringWithFormat:@"%03ld",(long)i];
        [keysArray addObject:keyString];
    }
    //    NSArray *valuesArray = @[@"/bq001",@"/bq005",@"/bq002",@"/bq006",@"/bq003",@"/bq007",@"/bq004",@"/bq008",@"/bq009",@"/bq013",@"/bq010",@"/bq014",@"/bq011",@"/bq015",@"/bq012",@"/bq016",];
    //手表硬件对接，对应的表情编码
    NSArray *valuesArray = @[@"1",@"7",@"8",@"10",@"12",@"14",@"3",@"9",@"16",@"5",@"2",@"6",@"4",@"13",@"15",@"11",];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    return [dic valueForKey:indexString];
}
/**
 *  拨打电话回调方法
 */
- (void) didPhoneCall
{
    if (self.babyUserInfo.babyId == nil) {
        [WeAppToast toast:@"当前用户暂无宝贝，请绑定宝贝！"];
    }else if ([KSAuthenticationCenter isTestAccount]){
        [WeAppToast toast:@"请先登录"];
    }
    else if (self.babyUserInfo
        && self.babyUserInfo.devicePhoneNumber
        && [self.babyUserInfo.devicePhoneNumber isKindOfClass:[NSString class]]
        && [EHUtils isValidMobile:self.babyUserInfo.devicePhoneNumber]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.babyUserInfo.devicePhoneNumber]]];
    }else{
        [WeAppToast toast:@"宝贝手表不在线，请检查手表或sim卡"];
    }
}
/**
 *  单击tableView的回调方法
 */
- (void)didRecognizertapGesture
{
    [self layoutOtherMenuViewHiden:YES];
    [self.messageInputView.inputTextView resignFirstResponder];
}
-(void)sendMessage:(XHBabyChatMessage*)message{
    WEAKSELF
    [[EHSingleChatCacheManager sharedCenter] sendBabyChatMessage:message writeSuccess:^(BOOL success, XHBabyChatMessage *chatMessage) {
        if (success) {
            EHLogInfo(@"-------> insert into database is success");
        }else{
            EHLogInfo(@"-------> insert into database is failed");
        }
    } sendSuccess:^(BOOL success, XHBabyChatMessage *chatMessage) {
        if (success) {
            message.msgStatus = EHBabyChatMessageStatusSent;
        }else{
            message.msgStatus = EHBabyChatMessageStatusFailed;
        }
        NSUInteger rowIndex = [weakSelf.messages indexOfObject:message];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
//        [weakSelf.messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
        EHBabyMessageTableViewCell *cell = (EHBabyMessageTableViewCell *)[weakSelf.messageTableView cellForRowAtIndexPath:indexPath];
        [cell configureActivityIndicatorView:message];
    }];
}
- (void)reSendMessage:(XHBabyChatMessage*)message atIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    [[EHSingleChatCacheManager sharedCenter] sendBabyChatMessage:message writeSuccess:^(BOOL success, XHBabyChatMessage *chatMessage) {
        if (success) {
            EHLogInfo(@"-------> insert into database is success");
        }else{
            EHLogInfo(@"-------> insert into database is failed");
        }
    } sendSuccess:^(BOOL success, XHBabyChatMessage *chatMessage) {
        if (success) {
            message.msgStatus = EHBabyChatMessageStatusSent;
        }else{
            message.msgStatus = EHBabyChatMessageStatusFailed;
        }
        EHBabyMessageTableViewCell *cell = (EHBabyMessageTableViewCell *)[weakSelf.messageTableView cellForRowAtIndexPath:indexPath];
        [cell configureActivityIndicatorView:message];
    }];
}
-(void)configMessage:(XHBabyChatMessage*)message{
    message.avatarUrl = self.userInfoComponentItem.user_head_img;
    message.recieverBabyID = self.babyUserInfo.babyId;
    message.msgStatus = EHBabyChatMessageStatusSending;
    message.user_nick_name = [KSAuthenticationCenter userComponent].nick_name;
    [message configMessageID];
    //只要是自己发送的消息，shouldShowUserName都为NO
    message.shouldShowUserName = NO;
    [self addMessage:message];
    [self finishSendMessageWithBubbleMessageType:message.messageMediaType];
}

-(void)addMessage:(XHMessage *)addedMessage{
    [self.chatMessageListService.pagedList addObject:addedMessage];
    [self configChatMessageTimestampWithPagelist:self.chatMessageListService.pagedList];
    [super addMessage:addedMessage];
}

-(BOOL)checkTextValid:(NSString*)text{
    if (text == nil || text.length == 0) {
        [WeAppToast toast:@"请输入合法字符"];
        return NO;
    }
    if (text.length > 50) {
        [WeAppToast toast:@"输入字数超出限制(50字)"];
        return NO;
    }
    
//    BOOL stringContainsEmoji = [EHUtils stringContainsEmoji:text];
//    if (stringContainsEmoji) {
//        [WeAppToast toast:@"暂时不支持表情符号哦"];
//        return NO;
//    }
    
    return YES;
}

-(NSString*)trimTextWithText:(NSString*)text{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <XHMessageModel> messageModel = [self messageForRowAtIndexPath:indexPath];
    if (![messageModel isKindOfClass:[XHBabyChatMessage class]]) {
        return NO;
    }
    return ((XHBabyChatMessage*)messageModel).needShowTimestamp;
}

#pragma mark - XHMessageTableViewController DataSource

- (id <XHMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!self.babyUserInfo.babyId || [KSAuthenticationCenter isTestAccount]) {
//        return nil;
//    }
    if (indexPath.row > self.messages.count) {
        return [[XHBabyChatMessage alloc] init];
    }
    id messageInfoObj = self.messages[indexPath.row];
    XHBabyChatMessage* chatMessage = [self safeGetChatMessageWithMessageInfoObj:messageInfoObj];
    return chatMessage;
}

-(XHBabyChatMessage*)safeGetChatMessageWithMessageInfoObj:(id)messageInfoObj{
    if (messageInfoObj == nil) {
        return [[XHBabyChatMessage alloc] init];
    }
    if ([messageInfoObj isKindOfClass:[EHChatMessageinfoModel class]]) {
        EHChatMessageinfoModel* messageInfoModel = messageInfoObj;
        return messageInfoModel.babyChatMessage;
    }else if([messageInfoObj isKindOfClass:[XHBabyChatMessage class]]){
        return ((XHBabyChatMessage*)messageInfoObj);
    }
    return [[XHBabyChatMessage alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message{
    
    BOOL displayTimestamp = YES;
    
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    
    static NSString *cellIdentifier = @"EHBabyMessageTableViewCell";
    
    EHBabyMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!messageTableViewCell) {
        messageTableViewCell = [[EHBabyMessageTableViewCell alloc] initWithMessage:message displaysTimestamp:displayTimestamp reuseIdentifier:cellIdentifier];
        messageTableViewCell.delegate = self;
    }
    
    messageTableViewCell.indexPath = indexPath;
    [messageTableViewCell configureCellWithMessage:message displaysTimestamp:displayTimestamp];
    [messageTableViewCell setBackgroundColor:tableView.backgroundColor];
    
    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:)]) {
        [self.delegate configureCell:messageTableViewCell atIndexPath:indexPath];
    }
    
    return messageTableViewCell;
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

- (void)didSelectedReSendBtnOnChatMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath{
    XHBabyChatMessage* chatMessage =  [self safeGetChatMessageWithMessageInfoObj:message];
//    [self sendMessage:chatMessage];
    [self reSendMessage:chatMessage atIndexPath:indexPath];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 添加或是接触宝贝消息响应

-(void)recieveBabyChatMessage:(NSNotification*)notification{
    EHChatMessageinfoModel* chatMessageModel = [notification.userInfo objectForKey:EHBabyChatMessageModel_DATA];
    if ([chatMessageModel.baby_id integerValue] != [self.babyUserInfo.babyId integerValue]) {
        return;
    }
    [self addMessage:chatMessageModel.babyChatMessage];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - 私有方法
/**
 *  用于APP从后台->前台，登录小溪这个时间段，新消息无法及时刷新的消息补充
 *
 */
-(void)hasXiaoxiHistoryChatMessage:(NSNotification*)notification{
    NSDictionary *historyMessage = [notification.userInfo objectForKey:@"historyMessage"];
    NSNumber *historyMessageBabyId = [historyMessage objectForKey:@"baby_id"];
    if (self.babyId && [self.babyId isEqualToNumber:historyMessageBabyId]) {
    [self.chatMessageListService getLastChatMessageWithBabyId:self.babyId readSuccess:^(NSMutableArray *componentItems) {
        if (componentItems && [componentItems count] > 0) {
            NSString *historyMessageCreateTime = [historyMessage objectForKey:@"createTime"];
            NSString *lastMessageCreateTime = ((EHChatMessageinfoModel*)componentItems[0]).create_time;
            
            NSDate *historyMsgDate = [self convertDateFromString:historyMessageCreateTime];
            NSDate *lastCacheMsgDate = [self convertDateFromString:lastMessageCreateTime];
            if ([historyMsgDate isLaterThan:lastCacheMsgDate]) {
                [self loadSingleChatMessageListDataSource];
            }
        }
            }];
    }

}
- (NSDate*) convertDateFromString:(NSString*)dateString
{
    static NSDateFormatter *myDateFormatter = nil;
    if (myDateFormatter == nil) {
        myDateFormatter = [[NSDateFormatter alloc]init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *date=[myDateFormatter dateFromString:dateString];
    return date;
}
- (void)userDidLogoutNotification:(NSNotification *)notification
{
    //清空service和messages数组所有数据
    [self.chatMessageListService.pagedList refresh];
    [self.chatMessageListService.pagedList removeAllObjects];
    self.chatMessageListService = nil;
    [self.messages removeAllObjects];
}
@end
