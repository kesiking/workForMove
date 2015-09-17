//
//  EHGetHealthyWeekInfoRsp.h
//  eHome
//
//  Created by 钱秀娟 on 15/7/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicModel.h"
#import "EHHealthWeekInfoModel.h"



@interface EHGetHealthyWeekInfoRsp : EHHealthyBasicModel
@property(strong,nonatomic)EHHealthWeekInfoModel* responseData;
@property(nonatomic,strong)NSString* monday;
@property(nonatomic,strong)NSString* sunday;
@property(assign,nonatomic)NSInteger targetSteps;

@property(nonatomic,strong)NSString* percent;
@property(nonatomic,strong)NSString* encourage;
@property(assign,nonatomic)double calorie;
@property(assign,nonatomic)double mileage;
@property(assign,nonatomic)NSInteger steps;

@end





