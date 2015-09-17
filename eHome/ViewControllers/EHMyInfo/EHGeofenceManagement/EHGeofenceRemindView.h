//
//  EHGeofenceRemindView.h
//  eHome
//
//  Created by xtq on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHGeofenceRemindListViewController.h"

typedef void(^ClickedBlock)(void);


@interface EHGeofenceRemindView : UIButton

@property (nonatomic, strong)ClickedBlock         clickedBlock;

- (void)showCountWithGeofenceID:(NSNumber *)geofenceID;

- (void)setCount:(NSInteger)count;

@end
