//
//  EHHealthyDayModel.h
//  eHome
//
//  Created by jweigang on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicModel.h"

@protocol EHHealthyDayHourModel <NSObject>

@end

@interface EHHealthyDayModel : EHHealthyBasicModel
@property(strong,nonatomic)NSArray<EHHealthyDayHourModel> *responseData;
@property(assign,nonatomic)NSInteger calorie;
@property(assign,nonatomic)NSInteger mileage;
@property(assign,nonatomic)NSInteger steps;
@property(strong,nonatomic)NSString *runTime;
@property(assign,nonatomic)NSInteger targetSteps;
@property(strong,nonatomic)NSString *percent;
@property(strong,nonatomic)NSString *encourage;
@end



@interface EHHealthyDayHourModel : WeAppComponentBaseItem

@property(assign,nonatomic)NSInteger dayNum;

@end
