//
//  EHBabyLocationCalloutView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyLocationCalloutView.h"
#import "EHGetBabyListRsp.h"
#import "EHMapManagerActionSheet.h"
#import <QuartzCore/QuartzCore.h>

#define device_kwh_int (100)

#define kArrorHeight        0

#define kTimerMargin        5
#define kTimerMarginTop     10.0
#define kTimerWidth         10
#define kTimerHeight        15.5

#define kTimerLabelMargin   8.0
#define kTimerLabelWidth    50
#define kTimerLabelHeight   15

#define kBatteryLabelMargin 15.0
#define kBatteryLabelWidth  40
#define kBatteryLabelHeight 15

#define kBatteryImageMargin (10.0)

#define kStatusImageWidth   (12.0)
#define kStatusImageHeight  (kStatusImageWidth)

#define KHeadImageMargin 18
#define KHeadImageMarginTop 4.0

#define kBgImageMarginLeft 18

@interface EHBabyLocationCalloutView()

@property (nonatomic, strong) EHMapManagerActionSheet        *mapManagerActionSheet;


@end

@implementation EHBabyLocationCalloutView

-(void)setupView{
    [super setupView];
    self.bgImageView.hidden = NO;
    self.babyHeadImageView.hidden=NO;
    self.timerLabel.hidden = NO;
    self.batteryImageView.hidden = NO;
    self.batteryLabel.hidden = NO;
    self.locationLabel.hidden = NO;
    self.navigationBtn.hidden = NO;
}

-(void)setPosition:(EHUserDevicePosition *)position{
    _position = position;
    [self reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 刷新reload
-(void)reloadData{
    [self reloadTimeLabel];
    [self reloadBatterView];
    [self reloadLocationView];
    [self reloadBabyHeadImage];
    [self reloadBackgroundView];
    [self sizeToFit];
    [self layoutIfNeeded];
}

-(void)reloadBabyHeadImage{
    EHGetBabyListRsp* currentBabyUserInfo=[[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    
    /*if ([KSAuthenticationCenter isTestAccount]) {
        [self.babyHeadImageView setImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]];
    }else */if ([currentBabyUserInfo.babySex integerValue] == EHBabySexType_girl) {
        [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:currentBabyUserInfo.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:currentBabyUserInfo.babyId newPlaceHolderImagePath:currentBabyUserInfo.babyHeadImage defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]]];
    }else{
        [self.babyHeadImageView sd_setImageWithURL:[NSURL URLWithString:currentBabyUserInfo.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:currentBabyUserInfo.babyId newPlaceHolderImagePath:currentBabyUserInfo.babyHeadImage defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]]];
    }
}

-(void)reloadTimeLabel{
    static NSDateFormatter *inputFormatter = nil;
    static NSDateFormatter *outputFormatter = nil;
    if (!self.position.location_time) {
        return;
    }
    if (inputFormatter == nil) {
        inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (outputFormatter == nil) {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
    }
    
    NSDate* inputDate = [inputFormatter dateFromString:self.position.location_time];
    NSInteger daysAgo = inputDate.daysAgo;
    NSString* timer = [outputFormatter stringFromDate:inputDate];
    // 同一天或是更晚
    if (daysAgo == 0) {
        // 只展示时、分
        self.timerLabel.text = timer;
    }else{
        // 展示昨天、时、分
        self.timerLabel.text = [NSString stringWithFormat:@"昨天 %@",timer];
    }
    [self.timerLabel sizeToFit];
}

-(void)reloadBatterView{
    self.batteryLabel.text = [NSString stringWithFormat:@"%.0f%%",[self.position.device_kwh floatValue] * (100 / device_kwh_int)];
    [self.batteryLabel sizeToFit];
    
    float batteryNumber = [self.position.device_kwh floatValue];
    [_batteryImageView.layer removeAllAnimations];
     if (batteryNumber > 0.75 * device_kwh_int) {
        [self.batteryImageView setImage:[UIImage imageNamed:@"ico_address_battery_100"]];
    }else if (batteryNumber > 0.5 * device_kwh_int){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ico_address_battery_75"]];
    }else if (batteryNumber > 0.20 * device_kwh_int){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ico_address_battery_50"]];
    }else if (batteryNumber > 0.05 * device_kwh_int){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ico_address_battery_25"]];
    }else if (batteryNumber >= 0){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ico_address_battery_20"]];
        [_batteryImageView.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    }
}

-(void)reloadLocationView{
    self.locationLabel.text = self.position.location_Des;
    
    self.statusImageView.hidden = ![self.position.locationType isEqualToString:SOS_LocationType];
    
    if (_statusImageView == nil || _statusImageView.hidden) {
        CGSize locationLabelSize = [self.locationLabel.text boundingRectWithSize:CGSizeMake(self.width - _timerLabel.left, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.locationLabel.font,NSFontAttributeName, nil] context:nil].size;
        [self.locationLabel setSize:CGSizeMake(locationLabelSize.width, ceil(locationLabelSize.height))];
        
    }else{
        CGSize locationLabelSize = [self.locationLabel.text boundingRectWithSize:CGSizeMake(self.width - _timerLabel.left - 2 * kBatteryLabelMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.locationLabel.font,NSFontAttributeName, nil] context:nil].size;
        [self.locationLabel setSize:CGSizeMake(locationLabelSize.width, ceil(locationLabelSize.height))];
    }
}

-(void)reloadBackgroundView{
    if ([self needChangeAnnotationImageViewAnimation]) {
        _bgImageView.image = [UIImage imageNamed:@"bg_map_address"];//[[UIImage imageNamed:@"bg_map_address"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 40,30)];
    }else{
        _bgImageView.image = [UIImage imageNamed:@"bg2_map_address"];//[[UIImage imageNamed:@"bg2_map_address"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 40,30)];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 电池动画
-(CABasicAnimation *)opacityForever_Animation:( float )time{
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"opacity" ]; // 必须写 opacity 才行。
    animation. fromValue = [ NSNumber numberWithFloat : 1.0f ];
    animation. toValue = [ NSNumber numberWithFloat : 0.0f ]; // 这是透明度。
    animation. autoreverses = YES ;
    animation. duration = time;
    animation. repeatCount = MAXFLOAT ;
    animation. removedOnCompletion = NO ;
    animation. fillMode = kCAFillModeForwards ;
    animation. timingFunction =[ CAMediaTimingFunction functionWithName : kCAMediaTimingFunctionEaseIn ]; /// 没有的话是均匀的动画。
    return animation;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 响应函数 action
-(void)navigationBtnClicked:(UIButton*)sender{
    [self.mapManagerActionSheet showMapManagerActionSheet];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有函数
-(BOOL)needChangeAnnotationImageViewAnimation{
    if (_position && [_position.locationType isEqualToString:current_LocationType]) {
        return YES;
    }
    return NO;
}

-(void)hideNavigationComponent{
    self.navigationBtn.hidden = YES;
}

-(void)showNavigationComponent{
    [self.navigationBtn setFrame:CGRectMake(self.width - kCalloutNavBtnWidth, 0, kCalloutNavBtnWidth,self.height)];
//    UIView* imageView = [self.navigationBtn viewWithTag:1015];
//    UIView* labelView = [self.navigationBtn viewWithTag:1016];
//    [imageView setOrigin:CGPointMake(imageView.origin.x, (self.navigationBtn.height - imageView.height - labelView.height + 5)/2)];
//    [labelView setOrigin:CGPointMake(labelView.origin.x, imageView.bottom - 5)];
    UIView* lineView = [self.navigationBtn viewWithTag:1017];
    [lineView setOrigin:CGPointMake(lineView.origin.x, (self.navigationBtn.height - lineView.height)/2)];
    self.navigationBtn.hidden = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBgImageMarginLeft, 0, self.width-kBgImageMarginLeft, self.height)];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}

//-(UIImageView *)timerImageView{
//    if (!_timerImageView) {
//        _timerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kTimerMargin, kTimerMargin, kTimerWidth, kTimerHeight)];
//        _timerImageView.backgroundColor = [UIColor greenColor];
//        [self addSubview:_timerImageView];
//    }
//    return _timerImageView;
//}

-(UILabel *)timerLabel{
    if (!_timerLabel) {
//        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(_babyHeadImageView.left+_babyHeadImageView.width+kTimerMargin, kTimerMarginTop, kTimerLabelWidth, kTimerLabelHeight)];
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.left+30,_bgImageView.top+15,kTimerLabelWidth,kTimerLabelHeight)];
        _timerLabel.font = EH_font7;
        _timerLabel.textColor = EH_cor4;
        _timerLabel.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_timerLabel];
    }
    return _timerLabel;
}

-(UIImageView *)batteryImageView{
    if (!_batteryImageView) {
        _batteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.batteryLabel.left - kBatteryImageMargin, 17, 24, 9)];
        _batteryImageView.image = [UIImage imageNamed:@"public_ico_address_map_battery_100"];
        [self addSubview:_batteryImageView];
    }
    return _batteryImageView;
}

-(UILabel *)batteryLabel{
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.right - kBatteryLabelMargin - kBatteryLabelWidth, _timerLabel.top, kBatteryLabelWidth, kBatteryLabelHeight)];
        _batteryLabel.font = EH_font7;
        //_batteryLabel.textColor = EH_cor3;
        _batteryLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_batteryLabel];
    }
    return _batteryLabel;
}

-(UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_timerLabel.left, _timerLabel.bottom + 11, kStatusImageWidth, kStatusImageHeight)];
        _statusImageView.image = [UIImage imageNamed:@"public_ico_address_map_cautionpoint"];
        _statusImageView.opaque = YES;
        [self addSubview:_statusImageView];
    }
    return _statusImageView;
}

-(UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timerLabel.left, _timerLabel.bottom + 5, self.width - _timerLabel.left-kBatteryLabelMargin, kBatteryLabelHeight * 2)];
        _locationLabel.font = EH_font6;
        _locationLabel.textColor = EH_cor9;
        _locationLabel.numberOfLines = 2;
        _locationLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_locationLabel];
    }
    return _locationLabel;
}

-(UIImageView *) babyHeadImageView{
    if (!_babyHeadImageView) {
        _babyHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12,self.height/2-12, 30,30)];
        _babyHeadImageView.image = [UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"];
        _babyHeadImageView.layer.cornerRadius = _babyHeadImageView.height/2;
        _babyHeadImageView.layer.masksToBounds = YES;
        [self addSubview:_babyHeadImageView];
    }
    return _babyHeadImageView;
}

-(UIButton *)navigationBtn{
    if (!_navigationBtn) {
        _navigationBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.right - kCalloutNavBtnWidth, 0, kCalloutNavBtnWidth,self.height)];
        _navigationBtn.backgroundColor = [UIColor clearColor];
        [_navigationBtn addTarget:self action:@selector(navigationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_navigationBtn];
        
        UIImageView *naviImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_navigation_map_address"]];
        naviImageView.frame=CGRectMake(10, self.batteryLabel.top + 3, 10, 10);
        naviImageView.tag = 1015;
        [_navigationBtn addSubview:naviImageView];
        
        UILabel *naviLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, self.locationLabel.top, 30, 15)];
        naviLabel.text      = @"导航";
        naviLabel.textColor = EH_cor9;
        naviLabel.font      = EH_font6;
        naviLabel.tag       = 1016;
        [naviLabel sizeToFit];
        
        UIImageView *lineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_map_address"]];
        lineImageView.frame=CGRectMake(-10, 30, 1, 30);
        lineImageView.tag = 1017;
        
        [_navigationBtn addSubview:lineImageView];
        
        [_navigationBtn addSubview:naviLabel];
    }
    return _navigationBtn;
}

-(EHMapManagerActionSheet *)mapManagerActionSheet{
    if (_mapManagerActionSheet == nil) {
        _mapManagerActionSheet = [EHMapManagerActionSheet new];
        _mapManagerActionSheet.popViewController = self.viewController;
    }
    return _mapManagerActionSheet;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 系统函数
-(void)layoutSubviews{
    [super layoutSubviews];
    self.babyHeadImageView.center = CGPointMake(_babyHeadImageView.center.x, self.height/2-3);
    [self.bgImageView setFrame:CGRectMake(0, 0, self.width, self.height)];
    CGFloat navigationBtnRightMargin = 0;
    if ([self needChangeAnnotationImageViewAnimation]) {
        [self showNavigationComponent];
        navigationBtnRightMargin = kCalloutNavBtnWidth;
    }else{
        [self hideNavigationComponent];
    }
    /*
    [self.batteryLabel setFrame:CGRectMake(self.width - kBatteryLabelMargin - self.batteryLabel.width - navigationBtnRightMargin, _timerLabel.top + (_timerLabel.height - self.batteryLabel.height)/2 , self.batteryLabel.width, self.batteryLabel.height)];
    [self.batteryImageView setFrame:CGRectMake(self.batteryLabel.left - kBatteryImageMargin - self.batteryImageView.width, 11, self.batteryImageView.width, self.batteryImageView.height)];
     */
    [self.batteryImageView setFrame:CGRectMake(self.width - kBatteryLabelMargin - self.batteryImageView.width - navigationBtnRightMargin - 10, self.batteryImageView.origin.y, self.batteryImageView.width, self.batteryImageView.height)];
    [self.batteryLabel setFrame:CGRectMake(self.batteryImageView.left - self.batteryLabel.width - 1, _timerLabel.top + (_timerLabel.height - self.batteryLabel.height)/2 , self.batteryLabel.width, self.batteryLabel.height)];
    if (_statusImageView == nil || _statusImageView.hidden) {
        [self.locationLabel setFrame:CGRectMake(_timerLabel.left, _timerLabel.bottom + 5, self.width - _timerLabel.left-kBatteryLabelMargin - navigationBtnRightMargin, self.locationLabel.height)];
    }else{
        [self.locationLabel setFrame:CGRectMake(_statusImageView.right + 5, _timerLabel.bottom + 5, self.width - _timerLabel.left - 2 *kBatteryLabelMargin - navigationBtnRightMargin, self.locationLabel.height)];
        [self.statusImageView setOrigin:CGPointMake(self.statusImageView.left, _locationLabel.origin.y + (_locationLabel.height - self.statusImageView.height)/2)];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize newSize = size;
    
    newSize.height = 70 + self.locationLabel.height - kBatteryLabelHeight;
    
    if ([self needChangeAnnotationImageViewAnimation]) {
        newSize.width = kCalloutWidthWithNavBtn;
    }else{
        newSize.width = kCalloutWidth;
    }
    
    return newSize;
}

@end
