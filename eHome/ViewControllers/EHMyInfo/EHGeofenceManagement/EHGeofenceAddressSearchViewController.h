//
//  EHGeofenceAddressSearchViewController.h
//  eHome
//
//  Created by xtq on 15/7/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"

typedef void (^SearchFinishedBlock)(NSString *address,CLLocationCoordinate2D coordinate);

@interface EHGeofenceAddressSearchViewController : KSViewController

@property (nonatomic, strong)SearchFinishedBlock searchFinishedBlock;

@end
