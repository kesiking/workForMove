//
//  EHFeedbackViewModel.h
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EHFeedbackModel.h"
#import "EHFeedbackMacro.h"

@interface EHFeedbackViewModel : NSObject

@property (nonatomic, strong)NSString   *showedContent;

@property (nonatomic, strong)NSString   *showedTime;

@property (nonatomic, assign)NSInteger  showedType;

@property (nonatomic, strong)NSString   *bubbleImageName;

@property (nonatomic, strong)NSString   *userHeadImageName;
@property (nonatomic, assign)NSInteger  userId;

@property (nonatomic, strong)UIColor    *contentColor;

@property (nonatomic, assign)CGFloat    cellHeight;

@property (nonatomic, assign)CGRect     timeLabelFrame;

@property (nonatomic, assign)CGRect     headImageFrame;

@property (nonatomic, assign)CGRect     bubbleImageFrame;

@property (nonatomic, assign)CGRect     contentLabelFrame;

- (instancetype)initWithModel:(EHFeedbackModel *)feedbackModel PreviousTime:(NSString *)previosTime UserHeadImageName:(NSString *)userHeadImageName;

@end
