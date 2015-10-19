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
        self.backgroundColor = EHBgcor3;
        
        [self addSubview:self.remindLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.rightArrowView];
        [self addSubview:self.actiView];
        EHLogInfo(@"self.countLabel.text = %@",self.countLabel.text);
        
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *topLineLayer = [CALayer layer];
        topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.5);
        topLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:topLineLayer];
        
        CALayer *bottomLineLayer = [CALayer layer];
        bottomLineLayer.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.5, CGRectGetWidth(frame), 0.5);
        bottomLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:bottomLineLayer];
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
        _remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 75, CGRectGetHeight(self.frame))];
        _remindLabel.font = EHFont2;
        _remindLabel.textColor = EHCor5;
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.text = @"主动提醒：";
    }
    return _remindLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 12 - 10 - 12 - 100, 0, 100, CGRectGetHeight(self.frame))];
        _countLabel.font = EHFont5;
        _countLabel.textColor = EHCor3;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UIImageView *)rightArrowView {
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 12 - 15, 15, 10, 15)];
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
