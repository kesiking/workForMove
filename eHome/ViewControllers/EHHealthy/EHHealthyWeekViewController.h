//
//  EHHealthyWeekViewController2.h
//  eHome
//
//  Created by 钱秀娟 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHHealthyBasicViewController.h"
#import "EHGetHealthyWeekInfoService.h"

@interface EHHealthyWeekViewController : EHHealthyBasicViewController
@property (assign,nonatomic)NSInteger currentWeek;
@property(strong,nonatomic)EHGetHealthyWeekInfoService* queryWeekInfoListService;
@property (strong, nonatomic) EHGetHealthyWeekInfoRsp *weekVCmodel;
@property (strong, nonatomic) NSString *selectedWeek;

@end
