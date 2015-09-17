//
//  EHGeofenceDetailViewController.h
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBaseGeofenceViewController.h"
#import "EHGetGeofenceListRsp.h"

@interface EHGeofenceDetailViewController : EHBaseGeofenceViewController

@property (nonatomic, strong)EHGetGeofenceListRsp *geofenceInfo;    //围栏信息

@property (nonatomic, strong)NSArray *existedNameArray;             //已经存在的围栏名字

@end
