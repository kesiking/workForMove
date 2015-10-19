//
//  EHFeedbackViewModel.m
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFeedbackViewModel.h"
#import "NSString+StringSize.h"

@implementation EHFeedbackViewModel

- (instancetype)initWithModel:(EHFeedbackModel *)feedbackModel PreviousTime:(NSString *)previosTime UserHeadImageName:(NSString *)userHeadImageName{
    self = [super init];
    if (self) {
        self.cellHeight = kSpaceY_CellTop_SubTop;
        
        self.showedContent = feedbackModel.content;
        
        if (feedbackModel.type == EHContentTypeSuggestion) {
            self.showedTime = [self showedTimeWithModelTime:feedbackModel.time PreviousTime:previosTime];
        }
        else {
            self.showedTime = nil;
        }
        
        self.showedType = feedbackModel.type;
        
        self.userId = feedbackModel.user_id;
        [self configUIParamsWithImage:userHeadImageName];
    }
    return self;
}

- (void)configUIParamsWithImage:(NSString *)userHeadImageName{
    //self.timeLabelFrame
    if (!self.showedTime) {
        self.timeLabelFrame = CGRectZero;
    }
    else {
        CGRect frame = CGRectMake(kSpaceX_CellSide, kSpaceY_CellTop_SubTop, kTimeWidth, kTimeHeight);
        self.cellHeight = kSpaceY_Time_Content * 2 + kTimeHeight;
        self.timeLabelFrame = frame;
    }
    
    //self.headImageFrame、self.contentLabelFrame、self.bubbleImageFrame、self.bubbleImage
    CGSize contentSize = [self.showedContent sizeWithFontSize:EHSiz2 Width:kLabelMaxWidth];
    CGFloat contentLabelWidth = MIN(contentSize.width,kLabelMaxWidth);
    
    if (self.showedType == EHContentTypeSuggestion){
        self.headImageFrame = CGRectMake(SCREEN_WIDTH - kSpaceX_CellSide - kHeadImageWidth, self.cellHeight, kHeadImageWidth, kHeadImageWidth);
        
        self.contentLabelFrame = CGRectMake(SCREEN_WIDTH - (kSpaceX_Bubble_CellSide + kSpaceX_Bubble_Content_Side + contentLabelWidth), self.cellHeight + kSpaceY_Bubble_Content, contentLabelWidth, contentSize.height);
        
        self.bubbleImageFrame = CGRectMake(SCREEN_WIDTH - (kSpaceX_Bubble_CellSide + kSpaceX_Bubble_Content_Side + kSpaceX_Bubble_Content_Middle + contentLabelWidth), self.cellHeight, contentLabelWidth + kSpaceX_Bubble_Content_Side + kSpaceX_Bubble_Content_Middle, contentSize.height + kSpaceY_Bubble_Content * 2);
        self.bubbleImageName = kChatMe;
        self.userHeadImageName = userHeadImageName;
        self.contentColor = [UIColor whiteColor];
    }
    else {
        self.headImageFrame = CGRectMake(kSpaceX_CellSide, self.cellHeight, kHeadImageWidth, kHeadImageWidth);
        
        self.contentLabelFrame = CGRectMake(kSpaceX_Bubble_CellSide + kSpaceX_Bubble_Content_Side, self.cellHeight + kSpaceY_Bubble_Content, contentLabelWidth, contentSize.height);
        
        self.bubbleImageFrame = CGRectMake(kSpaceX_Bubble_CellSide, self.cellHeight, contentLabelWidth + kSpaceX_Bubble_Content_Side + kSpaceX_Bubble_Content_Middle, contentSize.height + kSpaceY_Bubble_Content * 2);
        self.bubbleImageName = kChatOther;
        self.userHeadImageName = kHeadportrait_administrator;
        self.contentColor = EH_cor3;
    }
    self.cellHeight += contentSize.height + kSpaceY_Bubble_Content * 2;
}

- (NSString *)showedTimeWithModelTime:(NSString *)modelTime PreviousTime:(NSString *)previousTime{
    NSString *subModelTime = modelTime.length > 10?[modelTime substringToIndex:10]:modelTime;
    
    if (!previousTime) {
        return [self compareTime:subModelTime];
    }
    else {
        NSString *subPreviousTime = previousTime.length > 10?[previousTime substringToIndex:10]:previousTime;
        if ([subModelTime compare:subPreviousTime] == NSOrderedSame) {
            return nil;
        }
        else {
            return [self compareTime:subModelTime];
        }
    }
}

//判断日期今天、昨天
-(NSString *)compareTime:(NSString *)timeString{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: today];
    
    today = [today dateByAddingTimeInterval:interval];    //时差转换
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    if ([timeString isEqualToString:todayString]){
        return @"今天";
    } else if ([timeString isEqualToString:yesterdayString]){
        return @"昨天";
    } else{
        return timeString;
    }
}

@end
