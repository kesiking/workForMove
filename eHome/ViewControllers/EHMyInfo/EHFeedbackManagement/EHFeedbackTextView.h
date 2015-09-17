//
//  EHFeedbackTextView.h
//  eHome
//
//  Created by xtq on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHFeedbackMacro.h"

#define kTextViewHeight 51

typedef void (^FrameChangedBlock) (CGFloat offset);
typedef void (^SendBlock) (NSString *content);

@interface EHFeedbackTextView : UIImageView

@property (nonatomic, strong)FrameChangedBlock frameChangedBlock;

@property (nonatomic, strong)SendBlock sendBlock;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)finishSend;

@end
