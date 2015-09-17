//
//  EHMapHistoryTraceBottomView.h
//  eHome
//
//  Created by 孟希羲 on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHUserDevicePosition.h"

@interface EHMapHistoryTraceBottomView : KSView

@property (nonatomic,strong) EHUserDevicePosition      *position;

@property (nonatomic,strong) UILabel     * historyTraceEndLocationNameLabel;
@property (nonatomic,strong) UILabel     * historyTraceEndLocationTimeLabel;

@end
