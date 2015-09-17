//
//  EHMapHistoryTraceViewCell.h
//  eHome
//
//  Created by 孟希羲 on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewCell.h"

@interface EHMapHistoryTraceViewCell : KSViewCell

@property (nonatomic,strong)  IBOutlet  UILabel * timelabel;
@property (nonatomic,strong)  IBOutlet  UILabel * positionLocationDesInfolabel;
@property (nonatomic,strong)  IBOutlet  UIImageView * positionBubbleImageView;
@property (nonatomic,strong)  IBOutlet  UIImageView * positionArrowImageView;

@property (nonatomic,strong)            UILabel * sosMessageInfolabel;

@property (nonatomic,assign)  BOOL      positionArrorImageViewShouldShow;

@end
