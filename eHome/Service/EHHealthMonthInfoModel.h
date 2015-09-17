//
//  EHHealthMonthInfoModel.h
//  eHome
//
//  Created by 钱秀娟 on 15/8/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHHealthMonthInfoModel : WeAppComponentBaseItem
@property(nonatomic,assign)NSInteger everyWeekSteps;
@property(nonatomic,strong)NSString* beginTime;
@property(nonatomic,strong)NSString* endTime;

@end
