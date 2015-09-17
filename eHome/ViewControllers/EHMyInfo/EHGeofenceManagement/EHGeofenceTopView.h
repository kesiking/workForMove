//
//  EHGeofenceTopView.h
//  eHome
//
//  Created by xtq on 15/9/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

typedef void(^SearchBtnClickBlock)();
typedef void(^GeofenceNameFieldChangedBlock)();


@interface EHGeofenceTopView : KSView

@property (nonatomic, strong)NSString *address;

@property (nonatomic, strong)NSString *geofenceName;

@property (nonatomic, strong)SearchBtnClickBlock searchBtnClickBlock;

@property (nonatomic, strong)GeofenceNameFieldChangedBlock geofenceNameFieldChangedBlock;

@end
