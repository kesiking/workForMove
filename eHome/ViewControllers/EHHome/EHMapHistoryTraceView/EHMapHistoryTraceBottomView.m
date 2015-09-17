//
//  EHMapHistoryTraceBottomView.m
//  eHome
//
//  Created by 孟希羲 on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTraceBottomView.h"

@implementation EHMapHistoryTraceBottomView

-(void)setupView{
    [super setupView];
    self.backgroundColor = [UIColor whiteColor];
    [self initLabel];
}

-(void)initLabel{
    _historyTraceEndLocationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.height - 30 - 15)/2, self.width - 2 * 10, 30)];
    _historyTraceEndLocationNameLabel.textAlignment = NSTextAlignmentCenter;
    _historyTraceEndLocationNameLabel.textColor = EH_cor3;
    _historyTraceEndLocationNameLabel.font = [UIFont boldSystemFontOfSize:15];
    _historyTraceEndLocationNameLabel.numberOfLines = 2;
    
    [self addSubview:_historyTraceEndLocationNameLabel];
    
    _historyTraceEndLocationTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _historyTraceEndLocationNameLabel.bottom, self.width, 15)];
    _historyTraceEndLocationTimeLabel.textAlignment = NSTextAlignmentCenter;
    _historyTraceEndLocationTimeLabel.textColor = EH_cor5;
    _historyTraceEndLocationTimeLabel.font = EH_font7;
    
    [self addSubview:_historyTraceEndLocationTimeLabel];
}

-(void)setPosition:(EHUserDevicePosition *)position{
    _position = position;
    [self reloadData];
}

-(void)reloadData{
    if (!self.position) {
        return;
    }
    [_historyTraceEndLocationNameLabel setText:self.position.location_Des];
    [_historyTraceEndLocationTimeLabel setText:self.position.location_time];
    
    [_historyTraceEndLocationNameLabel sizeToFit];
    
    [_historyTraceEndLocationNameLabel setFrame:CGRectMake(10, (self.height - _historyTraceEndLocationNameLabel.height - _historyTraceEndLocationTimeLabel.height - 5)/2, self.width - 2 * 10, _historyTraceEndLocationNameLabel.height)];
    [_historyTraceEndLocationTimeLabel setFrame:CGRectMake(0, _historyTraceEndLocationNameLabel.bottom + 5, self.width, _historyTraceEndLocationTimeLabel.height)];
}

@end
