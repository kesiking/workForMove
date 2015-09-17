//
//  EHHomeNavBarRightView.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHomeNavBarRightView.h"
#import "EHUpdateMessageNumberService.h"

#define BTN_IMAGE_WIDTH_HEIGHT   (24.0)
#define POINT_IMAGE_WIDTH_HEIGHT (6.0)

@interface EHHomeNavBarRightView()

@property (nonatomic, strong) EHUpdateMessageNumberService *messageNumberService;

@property (nonatomic, assign) NSUInteger                    messageNumber;

@end

@implementation EHHomeNavBarRightView

-(void)setupView{
    [super setupView];
    [self initCommonInfo];
    [self initTitleButton];
    [self initPointImage];
    [self initNotification];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initCommonInfo{
    
    self.messageNumber = 0;
    
}

-(void)initTitleButton{
    _btn = [[UIButton alloc] initWithFrame:self.bounds];
    [_btn setImage:[UIImage imageNamed:@"public_ico_tbar_message"] forState:UIControlStateNormal];
    [_btn setImageEdgeInsets:UIEdgeInsetsMake((_btn.height - BTN_IMAGE_WIDTH_HEIGHT)/2, (_btn.width - BTN_IMAGE_WIDTH_HEIGHT) - 5, (_btn.height - BTN_IMAGE_WIDTH_HEIGHT)/2, 5)];
    
    [_btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
}

-(void)initPointImage{
    _pointImage = [[UIImageView alloc] initWithFrame:CGRectMake(_btn.width - POINT_IMAGE_WIDTH_HEIGHT/2 - 2 - 5, (self.height - BTN_IMAGE_WIDTH_HEIGHT)/2 - POINT_IMAGE_WIDTH_HEIGHT/2 + 2 , POINT_IMAGE_WIDTH_HEIGHT, POINT_IMAGE_WIDTH_HEIGHT)];
    [_pointImage setImage:[UIImage imageNamed:@"public_ico_tbar_message_propmpt"]];
    _pointImage.hidden = YES;
    [self addSubview:_pointImage];
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(remoteMessageAction:)
                                                 name:EHRemoteMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearRemoteMessageAction:)
                                                 name:EHClearRemoteMessageAttentionNotification
                                               object:nil];
}

-(void)buttonClicked:(id)sender{
    // 小红点展示时才发请求通知清除，否则不发送，减少请求次数
    if (!self.pointImage.hidden) {
        [self.messageNumberService updateMessageNumberWithUserPhone:[KSAuthenticationCenter userPhone]];
    }
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock(self);
    }
}

-(void)setupPointImageStatusWithNumber:(NSNumber*)number{
    NSUInteger numberInt = [number integerValue];
    self.messageNumber = numberInt;
    if (numberInt > 0) {
        self.pointImage.hidden = NO;
    }else{
        self.pointImage.hidden = YES;
    }
}

-(EHUpdateMessageNumberService *)messageNumberService{
    if (_messageNumberService == nil) {
        _messageNumberService = [EHUpdateMessageNumberService new];
        WEAKSELF
        _messageNumberService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            EHLogInfo(@"----> update message number service success");
            strongSelf.pointImage.hidden = YES;
            strongSelf.messageNumber = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:EHClearRemoteMessageAttentionNotification object:nil userInfo:nil];
        };
    }
    return _messageNumberService;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)remoteMessageAction:(NSNotification*)notification{
    [self setupPointImageStatusWithNumber:[NSNumber numberWithUnsignedInteger:self.messageNumber + 1]];
}

-(void)clearRemoteMessageAction:(NSNotification*)notification{
    [self setupPointImageStatusWithNumber:@(0)];
}

@end
