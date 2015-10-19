//
//  EHGeofenceListTableViewCell.h
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHGetGeofenceListRsp.h"
#import "SevenSwitch.h"
#import "EHSwitch.h"

typedef void (^SwitchChangedBlock)(BOOL isOn);

@interface EHGeofenceListTableViewCell : UITableViewCell

@property (nonatomic,strong) SwitchChangedBlock switchChangedBlock;

@property (nonatomic, strong) EHSwitch *swit;

- (void)configWithGeofence:(EHGetGeofenceListRsp *)geofence;

@end
