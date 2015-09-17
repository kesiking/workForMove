//
//  EHFeedbackModel.h
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EHContentType) {
    EHContentTypeSuggestion = 1,
    EHContentTypeFeedback,
};

@interface EHFeedbackModel : WeAppComponentBaseItem

@property (nonatomic, strong)NSString *tid;

@property (nonatomic, assign)NSInteger user_id;

@property (nonatomic, strong)NSString *content;

@property (nonatomic, strong)NSString *time;

@property (nonatomic, assign)NSInteger type;

@end
