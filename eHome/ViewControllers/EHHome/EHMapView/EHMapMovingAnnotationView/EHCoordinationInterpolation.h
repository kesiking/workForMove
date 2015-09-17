//
//  EHCoordinationInterpolation.h
//  eHome
//
//  Created by 孟希羲 on 15/8/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHCoordinationInterpolation : NSObject

@property (nonatomic, assign)       CLLocationDistance              distance;

@property (nonatomic, assign)       NSUInteger                      maxCoordinationsNumber;

@property (nonatomic, assign)       NSUInteger                      minCoordinationsNumber;

-(NSArray*)getCoordinationsWithBeginCoordination:(CLLocationCoordinate2D)beginCoordination endCoordination:(CLLocationCoordinate2D)endCoordination;

-(NSArray*)getCoordinationsWithBeginCoordination:(CLLocationCoordinate2D)beginCoordination endCoordination:(CLLocationCoordinate2D)endCoordination withDistance:(CLLocationDistance)distance;

-(NSArray*)getCoordinationsWithBeginCoordinations:(NSArray*)coordinations;

-(NSArray*)getCoordinationsWithBeginCoordinations:(NSArray*)coordinations withDistance:(CLLocationDistance)distance;

@end
