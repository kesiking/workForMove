//
//  EHCoordinationInterpolation.m
//  eHome
//
//  Created by 孟希羲 on 15/8/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHCoordinationInterpolation.h"
#import <MapKit/MapKit.h>

@implementation EHCoordinationInterpolation

-(NSArray*)getCoordinationsWithBeginCoordination:(CLLocationCoordinate2D)beginCoordination endCoordination:(CLLocationCoordinate2D)endCoordination{
    return [self getCoordinationsWithBeginCoordination:beginCoordination endCoordination:endCoordination withDistance:self.distance];
}

-(NSArray*)getCoordinationsWithBeginCoordination:(CLLocationCoordinate2D)beginCoordination endCoordination:(CLLocationCoordinate2D)endCoordination withDistance:(CLLocationDistance)distance{
    
    CLLocationDistance coordinationDistance = MAMetersBetweenMapPoints(MAMapPointForCoordinate(beginCoordination), MAMapPointForCoordinate(endCoordination));
    if (coordinationDistance <= distance || distance <= 0) {
        return @[[NSValue valueWithMKCoordinate:beginCoordination],[NSValue valueWithMKCoordinate:endCoordination]];
    }
    NSUInteger coordinationsCount = (NSUInteger)(ceil(coordinationDistance / distance)) + 1;
    if (self.maxCoordinationsNumber > 0 && coordinationsCount > self.maxCoordinationsNumber) {
        coordinationsCount = self.maxCoordinationsNumber;
    }else if (self.minCoordinationsNumber > 0 && coordinationsCount < self.minCoordinationsNumber) {
        coordinationsCount = self.minCoordinationsNumber;
    }
    NSMutableArray* interpolationCoordinations = [NSMutableArray array];
    
    MKMapPoint mapBeginPoint = MKMapPointForCoordinate(beginCoordination);
    MKMapPoint mapEndPoint = MKMapPointForCoordinate(endCoordination);

    double dx = ((double)mapEndPoint.x - (double)mapBeginPoint.x ) / coordinationsCount;
    double dy = ((double)mapEndPoint.y - (double)mapBeginPoint.y) / coordinationsCount;
    
    for (NSUInteger index = 0; index < coordinationsCount; index++ ) {
        @autoreleasepool {
            MKMapPoint mapPoint = MKMapPointMake(mapBeginPoint.x + dx * index, mapBeginPoint.y + dy * index);
            CLLocationCoordinate2D coordination = MKCoordinateForMapPoint(mapPoint);
            [interpolationCoordinations addObject:[NSValue valueWithMKCoordinate:coordination]];
        }
    }
    
    return interpolationCoordinations;
}

-(NSArray*)getCoordinationsWithBeginCoordinations:(NSArray*)coordinations{
    return [self getCoordinationsWithBeginCoordinations:coordinations withDistance:self.distance];
}

-(NSArray*)getCoordinationsWithBeginCoordinations:(NSArray*)coordinations withDistance:(CLLocationDistance)distance{
    if (coordinations == nil || [coordinations count] < 2) {
        return coordinations;
    }
    NSUInteger coordinationsCount = [coordinations count];

    NSMutableArray* interpolationCoordinations = [NSMutableArray array];

    for (NSUInteger index = 0; index < coordinationsCount; index++ ) {
        @autoreleasepool {
            NSValue* beginValue = [coordinations objectAtIndex:index];
            CLLocationCoordinate2D beginCoordination = [beginValue MKCoordinateValue];
            NSUInteger endIndex = index + 1;
            if (endIndex >= coordinationsCount) {
                continue;
            }
            NSValue* endValue = [coordinations objectAtIndex:endIndex];
            CLLocationCoordinate2D endCoordination = [endValue MKCoordinateValue];
            
            NSArray* coordinationsBetweenTwoPoint = [self getCoordinationsWithBeginCoordination:beginCoordination endCoordination:endCoordination withDistance:distance];
            
            if (coordinationsBetweenTwoPoint) {
                [interpolationCoordinations addObjectsFromArray:coordinationsBetweenTwoPoint];
            }
        }
    }
    
    return interpolationCoordinations;
}

@end
