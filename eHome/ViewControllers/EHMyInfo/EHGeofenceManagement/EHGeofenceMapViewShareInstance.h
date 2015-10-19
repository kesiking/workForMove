//
//  EHGeofenceMapViewShareInstance.h
//  eHome
//
//  Created by louzhenhua on 15/10/16.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHGeofenceMapViewShareInstance : NSObject

+ (instancetype)sharedCenter;
- (MAMapView*)getMapViewWithFrame:(CGRect)frame;
@end
