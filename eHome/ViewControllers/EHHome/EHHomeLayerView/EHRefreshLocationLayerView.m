//
//  EHRefreshLocationLayerView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRefreshLocationLayerView.h"

#define MAX_TIMER_BUCKET (60 * 2.0)

@interface EHRefreshLocationLayerView(){
    NSDate*         _refreshClickedTime;
}

@end

@implementation EHRefreshLocationLayerView

-(void)setupView{
    [super setupView];
    [self initLayerButton];
    [self initRefreshClickedTime];
    self.backgroundColor = [UIColor clearColor];
}

-(void)initLayerButton{
    _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"ico_location_normal"] forState:UIControlStateNormal];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"ico_location_normal"] forState:UIControlStateHighlighted];
    [_refreshBtn addTarget:self action:@selector(refreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_refreshBtn];
    
//    _addBabyBtn = [[UIButton alloc] initWithFrame:_refreshBtn.bounds];
//    [_addBabyBtn setBackgroundImage:[UIImage imageNamed:@"ico_phone-normal"] forState:UIControlStateNormal];
//    [_addBabyBtn setBackgroundImage:[UIImage imageNamed:@"ico_phone-select"] forState:UIControlStateHighlighted];
//    [_addBabyBtn addTarget:self action:@selector(phoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_addBabyBtn];
}

-(void)initRefreshClickedTime{
    _refreshClickedTime = [NSDate date];
}

-(void)setBabyUserInfo:(EHGetBabyListRsp *)babyUserInfo{
    _babyUserInfo = babyUserInfo;
    [self initRefreshClickedTime];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)refreshButtonClicked:(id)sender{
    NSDate* currentTime = [NSDate date];
    NSTimeInterval timerBucket = [currentTime timeIntervalSinceDate:_refreshClickedTime];
    if (timerBucket <= MAX_TIMER_BUCKET) {
        EHLogInfo(@"-----> refresh button clicked too quick!");
        self.refreshLocationBlock(NO);
        return;
    }
    _refreshClickedTime = currentTime;
    if (self.refreshLocationBlock) {
        self.refreshLocationBlock(YES);
    }
}

@end
