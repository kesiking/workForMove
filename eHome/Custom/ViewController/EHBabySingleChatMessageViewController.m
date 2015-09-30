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


@end

@implementation EHBabySingleChatMessageViewController

- (void)loadSingleChatMessageListDataSource {
    NSNumber* babyId = self.babyUserInfo.babyId;
    if (babyId == nil) {
        babyId = [NSNumber numberWithInteger:[[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue]];
    }
    [self.chatMessageListService loadChatMessageListWithBabyId:babyId userPhone:[KSAuthenticationCenter userPhone]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
}

- (id)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
        self.allowsSendVoice = YES;
        self.allowsSendFace = NO;
        self.allowsSendMultiMedia = NO;
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
    
    [self loadSingleChatMessageListDataSource];
}

- (void)configChatMessageView{
    [[XHConfigurationHelper appearance] setupPopMenuTitles:@[NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息")]] ;
    _voiceRecordHelper = [self valueForKey:@"voiceRecordHelper"];
    _voiceRecordHelper.maxRecordTime = 10;
    _voiceRecordHelper.recordProgress = ^(float progress){
        
    };
    XHStopRecorderCompletion maxTimeStopRecorderCompletion = _voiceRecordHelper.maxTimeStopRecorderCompletion;
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
        if (maxTimeStopRecorderCompletion) {
            maxTimeStopRecorderCompletion();
        }
        [WeAppToast toast:@"录音时间到"];
    };
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveBabyChatMessage:) name:EHRecieveBabyChatMessageNotification object:nil];
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
    if (chatMessagePageList.insertListType == KSInsertListTypeBeforPagelist) {
        return YES;
    }
    if (chatMessagePageList.isRefresh) {
        return NO;
    }
    return NO;
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
            
            // Mark the voice as read and hide the red dot.
            if ([message isKindOfClass:[XHBabyChatMessage class]]) {
                message.isRead = YES;
                [[EHSingleChatCacheManager sharedCenter] updateBabyChatMessage:(XHBabyChatMessage*)message writeSuccess:^(BOOL success) {
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
    [self configMessage:textMessage];
    [self sendMessage:textMessage];
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
    XHBabyChatMessage *voiceMessage = [[XHBabyChatMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    [self configMessage:voiceMessage];
    [self sendMessage:voiceMessage];
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
        [weakSelf.messageTableView reloadData];
    }];
}

-(void)configMessage:(XHBabyChatMessage*)message{
    message.avatarUrl = self.userInfoComponentItem.user_head_img;
    message.recieverBabyID = self.babyUserInfo.babyId;
    message.msgStatus = EHBabyChatMessageStatusSending;
    message.user_nick_name = [KSAuthenticationCenter userComponent].nick_name;
    [message configMessageID];
    [self addMessage:message];
    [self finishSendMessageWithBubbleMessageType:message.messageMediaType];
}

-(void)addMessage:(XHMessage *)addedMessage{
    [super addMessage:addedMessage];
    [self.chatMessageListService.pagedList addObject:addedMessage];
    [self configChatMessageTimestampWithPagelist:self.chatMessageListService.pagedList];
}

-(BOOL)checkTextValid:(NSString*)text{
    if (text.length > 50) {
        [WeAppToast toast:@"输入字数超出限制"];
        return NO;
    }
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
    [self sendMessage:chatMessage];
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

@end
