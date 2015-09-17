//
//  EHBabyMsgInfoCell.h
//  eHome
//
//  Created by 姜伟刚 on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewCell.h"

@interface EHBabyMsgInfoCell : KSViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sosPointImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sosMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgMsgImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

//日期标签距离sos圆点的约束，默认priority=750(高)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToSosConstraint;

//日期标签距离父视图顶端的约束，默认priority=250(低)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToSuperConstraint;

//消息名称标签距离sos标签的约束，默认priority=750(高)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgNameToSosMsgConstraint;

//消息名称标签距离父视图顶端的约束，默认priority=250(低)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgNameToBgConstraint;

//消息气泡距离时间戳的约束，默认priority=750(高)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageToTimeStamp;

//消息气泡距离父视图顶端的约束，默认priority=250(低)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageTosuper;

@end
