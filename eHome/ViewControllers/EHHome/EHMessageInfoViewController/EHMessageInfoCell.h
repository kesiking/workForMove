//
//  EHMessageInfoCell.h
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewCell.h"

@interface EHMessageInfoCell : KSViewCell

@property (nonatomic,strong)  IBOutlet  UILabel * timelabel;
@property (nonatomic,strong)  IBOutlet  UILabel * messageNamelabel;
@property (nonatomic,strong)  IBOutlet  UILabel * messageInfolabel;
@property (nonatomic,strong)  IBOutlet  UILabel * personNamelabel;
@property (nonatomic,strong)  IBOutlet  UIImageView * messageImageView;


@end
