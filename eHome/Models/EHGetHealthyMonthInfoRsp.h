//
//  EHGetHealthyMonthInfoRsp.h
//  eHome
//
//  Created by 钱秀娟 on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicModel.h"

@class EHHealthyMonthDataModel;

@protocol EHHealthyMonthDataModel <NSObject>

@end

@interface EHHealthyMonthDataModel : WeAppComponentBaseItem

@property(nonatomic,assign)NSInteger everyWeekSteps;
@property(nonatomic,strong)NSString* beginTime;
@property(nonatomic,strong)NSString* endTime;

@end

@interface EHGetHealthyMonthInfoRsp : EHHealthyBasicModel
@property(strong,nonatomic)NSArray<EHHealthyMonthDataModel> *responseData;
@property(nonatomic,strong)NSString* beginTime;
@property(nonatomic,strong)NSString* endTime;
@property(nonatomic,strong)NSString* percent;
@property(nonatomic,strong)NSString* encourage;
@property(assign,nonatomic)double calorie;
@property(assign,nonatomic)double mileage;
@property(assign,nonatomic)NSInteger steps;


@end






        