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

typedef void (^SwitchStatusChangeBlock)(BOOL isOn);

@interface EHGeofenceListTableViewCell : UITableViewCell

@property (nonatomic,strong) SwitchStatusChangeBlock switchStatusChangeBlock;

@property (nonatomic, strong) SevenSwitch *swit;

- (void)configWithGeofence:(EHGetGeofenceListRsp *)geofence;

@end
