//
//  EHMapHistoryTraceCellModelInfoItem.m
//  eHome
//
//  Created by 孟希羲 on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTraceCellModelInfoItem.h"
#import "EHUserDevicePosition.h"

@implementation EHMapHistoryTraceCellModelInfoItem

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupCellModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem{
    if (![componentItem isKindOfClass:[EHUserDevicePosition class]]) {
        self.frame = CGRectMake(0, 0, 320, 50);
        return;
    }
    EHUserDevicePosition* positionInfoItem = (EHUserDevicePosition*)componentItem;
    CGSize positionLocationDesInfoSize = [positionInfoItem.location_Des boundingRectWithSize:CGSizeMake(caculateNumber(235), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil].size;
    
    CGSize sosMessageInfoSize = [@"发出SOS警报" boundingRectWithSize:CGSizeMake(caculateNumber(200), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil].size;

    self.positionLocationDesInfoSize = CGSizeMake(caculateNumber(235), ceil(positionLocationDesInfoSize.height));
    
    if ([positionInfoItem.locationType isEqualToString:SOS_LocationType]) {
        
    }
    
    self.frame = CGRectMake(0, 0, 320, ceil(positionLocationDesInfoSize.height) + 35 + (CGFloat)([positionInfoItem.locationType isEqualToString:SOS_LocationType]?ceil(sosMessageInfoSize.height) + 2:0));
    
    if (!positionInfoItem.location_time) {
        return;
    }
    
    static NSDateFormatter *inputFormatter = nil;
    static NSDateFormatter *outputFormatter = nil;

    if (inputFormatter == nil) {
        inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (outputFormatter == nil) {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
    }
    
    NSDate* inputDate = [inputFormatter dateFromString:positionInfoItem.location_time];
    NSString* timer = [outputFormatter stringFromDate:inputDate];
    
    self.positionLocationTime = timer;
}

@end
