//
//  EHUserDefaultData.h
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHUserDefaultData : NSObject

/*!
 *  @brief  存储宝贝id
 *
 *  @param babyId 宝贝id
 *
 *  @since 1.0
 */
+(void)setCurrentSelectBabyId:(NSInteger)babyId;

/*!
 *  @brief  获取存储宝贝id
 *
 *  @return 宝贝id
 *
 *  @since 1.0
 */
+(NSInteger)getCurrentSelectBabyId;

+(void)setCurrentLocationCoordinator:(CLLocationCoordinate2D)locationCoordinate babyId:(NSInteger)babyId;

+(CLLocationCoordinate2D)getCurrentLocationCoordinatorWithBabyId:(NSInteger)babyId;

+(BOOL)getIsNotFirstLoadApplication;

+(void)setIsNotFirstLoadApplication:(BOOL)isNotFirstLoad;


+(NSString*)getBabyHeadImagePath:(NSNumber*)babyId;
+(void)setBabyHeadImagePath:(NSString*)imagePath byBabyId:(NSNumber*)babyId;

+(NSString*)getUserHeadImagePath:(NSNumber*)userId;
+(void)setUserHeadImagePath:(NSString*)imagePath byUserId:(NSNumber*)userId;

@end
