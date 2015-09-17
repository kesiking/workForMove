//
//  EHRemindDateTableViewCell.h
//  eHome
//
//  Created by xtq on 15/9/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRemindDataCellHeight 100

typedef void(^DateBtnClickBlock)(NSString *);

@interface EHRemindDateTableViewCell : UITableViewCell

@property (nonatomic, strong)DateBtnClickBlock dateBtnClickBlock;

- (void)selectWorkDate:(NSString *)work_date;

@end
