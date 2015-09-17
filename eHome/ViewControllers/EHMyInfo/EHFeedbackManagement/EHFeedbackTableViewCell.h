//
//  EHFeedbackTableViewCell.h
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHFeedbackViewModel.h"

@interface EHFeedbackTableViewCell : UITableViewCell

- (void)configWithViewModel:(EHFeedbackViewModel *)feedbackViewModel;

@end
