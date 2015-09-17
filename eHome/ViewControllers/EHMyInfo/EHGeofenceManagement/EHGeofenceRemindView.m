//
//  EHGeofenceRemindView.m
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceRemindView.h"
#import "EHGetGeofenceRemindService.h"

@interface EHGeofenceRemindView()

@property (nonatomic, strong)UILabel *remindLabel;

@property (nonatomic, strong)UILabel *countLabel;

@property (nonatomic, strong)UIImageView *rightArrowView;

@property (nonatomic, strong)UIActivityIndicatorView *actiView;

@property (nonatomic, assign)NSNumber *geofenceID;

@end

@implementation EHGeofenceRemindView
{
    EHGetGeofenceRemindService *_getGeofenceRemindService;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        [self addSubview:self.remindLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.rightArrowView];
        [self addSubview:self.actiView];
        EHLogInfo(@"self.countLabel.text = %@",self.countLabel.text);
        
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Events Response
- (void)click:(id)sender {
    !self.clickedBlock?:self.clickedBlock();
}

#pragma mark - Private Methods
- (void)showCountWithGeofenceID:(NSNumber *)geofenceID {
    self.geofenceID = geofenceID;
    self.countLabel.text = nil;
    [self.actiView startAnimating];
    //请求列表
    [self configGetRemindService];
    [_getGeofenceRemindService getGeofenceRemindWithGeofenceID:geofenceID];
}

- (void)setCount:(NSInteger)count {
    if (count == 0) {
        self.countLabel.text = nil;
    }
    else {
        self.countLabel.text = [NSString stringWithFormat:@"%ld个",count];
    }
}

#pragma mark - Getters And Setters
- (void)configGetRemindService {
    if (!_getGeofenceRemindService) {
        _getGeofenceRemindService = [EHGetGeofenceRemindService new];
        
        WEAKSELF
        _getGeofenceRemindService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            //请求完后
            [strongSelf.actiView stopAnimating];
            NSInteger count = 0;
            for (EHGeofenceRemindModel *model in service.dataList) {
                if ([model.is_active boolValue]) {
                    count++;
                }
            }
            [strongSelf setCount:count];
            EHLogInfo(@"success - count = %ld",count);
            
        };
        
        _getGeofenceRemindService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [weakSelf.actiView stopAnimating];
            
            EHLogInfo(@"error = %@",error);
        };
    }
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 75, 15)];
        _remindLabel.font = EH_font5;
        _remindLabel.textColor = EH_cor3;
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.text = @"主动提醒：";
        [_remindLabel sizeToFit];
    }
    return _remindLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20 - 20 - 100, 15, 100, 15)];
        _countLabel.font = EH_font5;
        _countLabel.textColor = EH_cor3;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UIImageView *)rightArrowView {
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20 - 15, 15, 10, 15)];
        [_rightArrowView setImage:[UIImage imageNamed:@"public_arrow_list"]];
    }
    return _rightArrowView;
}

- (UIActivityIndicatorView *)actiView {
    if (!_actiView) {
        _actiView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20 - 20 - 20, 15, 20, 20)];
        _actiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_actiView stopAnimating];
    }
    return _actiView;
}

@end
