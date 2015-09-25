//
//  EHRemindListTableViewCell.h
//  eHome
//
//  Created by xtq on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHRemindViewModel.h"
#import "EHSwitch.h"

/**
 *  提醒类型
 */
typedef NS_ENUM(NSInteger, EHRemindType){
    /**
     *  围栏提醒
     */
    EHRemindTypeGeofence = 0,
    /**
     *  宝贝提醒
     */
    EHRemindTypeBaby,
};

#define kCellHeight     70

typedef void (^ActiveStatusChangeBlock)(BOOL isOn);

@interface EHRemindListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *isActiveButton;

@property (nonatomic, strong)EHSwitch *isActiveSwitch;

@property(nonatomic,strong)ActiveStatusChangeBlock activeStatusChangeBlock;

- (void)configWithRemindModel:(EHRemindViewModel *)remindModel RemindType:(EHRemindType)remindType;

@end
