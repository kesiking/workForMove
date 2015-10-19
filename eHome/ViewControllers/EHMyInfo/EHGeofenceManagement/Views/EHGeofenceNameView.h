//
//  EHGeofenceNameView.h
//  eHome
//
//  Created by xtq on 15/9/30.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GeofenceNameFieldChangedBlock)();


@interface EHGeofenceNameView : UITextField

@property (nonatomic, strong)NSString *geofenceName;

@property (nonatomic, strong)GeofenceNameFieldChangedBlock geofenceNameFieldChangedBlock;

@end
