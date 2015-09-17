//
//  EHMessageCellModelInfoItem.m
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageCellModelInfoItem.h"
#import "EHMessageInfoModel.h"

@implementation EHMessageCellModelInfoItem

static NSDateFormatter *inputFormatter = nil;
static NSDateFormatter *outputFormatter = nil;
static NSDateFormatter *outputHHAndMMFormatter = nil;
static NSDateFormatter *outputYYYYAndHHAndMMFormatter = nil;

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupCellModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem{
    if (![componentItem isKindOfClass:[EHMessageInfoModel class]]) {
        self.frame = CGRectMake(0, 0, 320, 50);
        return;
    }
    EHMessageInfoModel* messageInfoItem = (EHMessageInfoModel*)componentItem;
    CGSize messageInfoSize = [messageInfoItem.info boundingRectWithSize:CGSizeMake(caculateNumber(275), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil].size;
    
    if (inputFormatter == nil) {
        inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (outputFormatter == nil) {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MM.dd"];
    }
    if (outputHHAndMMFormatter == nil) {
        outputHHAndMMFormatter = [[NSDateFormatter alloc] init];
        [outputHHAndMMFormatter setDateFormat:@"HH:mm"];
    }
    if (outputYYYYAndHHAndMMFormatter == nil) {
        outputYYYYAndHHAndMMFormatter = [[NSDateFormatter alloc] init];
        [outputYYYYAndHHAndMMFormatter setDateFormat:@"yyyy.MM.dd"];
    }
    _needTimeStamp = NO;
    if (messageInfoItem.message_time) {
        NSDate* currentDate = [NSDate date];
        NSDate* inputDate = [inputFormatter dateFromString:messageInfoItem.message_time];
        NSInteger daysAgo = inputDate.daysAgo;
        NSInteger earlyDay = inputDate.day - currentDate.day;
        // 同一天或是更晚
        if (daysAgo == 0 && earlyDay == 0) {
            self.messageDate = @"今天";
            self.timeStamp = @"今天";
        }else{
            self.messageDate = [outputFormatter stringFromDate:inputDate];
            self.timeStamp = [outputYYYYAndHHAndMMFormatter stringFromDate:inputDate];
        }
        self.messageTime = [outputHHAndMMFormatter stringFromDate:inputDate];
        if (self.dataSource) {
            NSUInteger index = self.cellIndex;
//            EHMessageInfoModel* nextMessageInfoModel = (EHMessageInfoModel*)[self.dataSource getComponentItemWithIndex:index + 1];
//            if (nextMessageInfoModel) {
//                NSDate* nextInputDate = [inputFormatter dateFromString:nextMessageInfoModel.message_time];
//                NSInteger earlyDay = inputDate.day - nextInputDate.day;
//                if (earlyDay > 0) {
//                    _needTimeStamp = YES;
//                }
//            }
            if (index == 0) {
                _needTimeStamp = YES;
            }
            else{
            EHMessageInfoModel* previousMessageInfoModel = (EHMessageInfoModel*)[self.dataSource getComponentItemWithIndex:index - 1];
            if (previousMessageInfoModel) {
                NSDate* previousInputDate = [inputFormatter dateFromString:previousMessageInfoModel.message_time];
                if (inputDate.day!=previousInputDate.day) {
                    _needTimeStamp = YES;
                }
            }
            }
        }
    }
    BOOL isSOSMsg = NO;
    if ([messageInfoItem.category integerValue]==EHMessageInfoCatergoryType_SOS) {
        isSOSMsg = YES;
    }
    self.messageInfoSize = CGSizeMake(caculateNumber(275), ceil(messageInfoSize.height));

    self.frame = CGRectMake(0, 0, 320, ceil(messageInfoSize.height) + 60 +(CGFloat)(_needTimeStamp?30:0) +(CGFloat)(isSOSMsg?28:0));
}

@end
