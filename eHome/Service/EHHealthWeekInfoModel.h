//
//  EHHealthWeekInfoModel.h
//  eHome
//
//  Created by 钱秀娟 on 15/8/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface EHHealthWeekInfoModel : WeAppComponentBaseItem

@property(nonatomic,strong)NSString* monday;
@property(nonatomic,strong)NSString* sunday;
@property(nonatomic,strong)NSArray* data;

@end
