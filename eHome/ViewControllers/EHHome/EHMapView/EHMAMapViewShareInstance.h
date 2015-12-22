//
//  EHMAMapViewShareInstance.h
//  eHome
//
//  Created by louzhenhua on 15/10/16.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHMAMapViewShareInstance : NSObject

+ (instancetype)sharedCenter;
- (MAMapView*)getMapViewWithFrame:(CGRect)frame;
- (void)resetMapWithMapView:(MAMapView*)mapView;
@end
