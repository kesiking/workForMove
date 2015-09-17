//
//  EHUserDefaultData.m
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUserDefaultData.h"

#define CURRENT_BABY_ID  @"currentBabyId"
#define ISNotFirstLoadApplication  @"isNotFirstLoadApplication"
#define BABY_HEAD_IMAGE_KEY_FORMAT  @"BABY_HEAD_IMAGE_KEY_%@"
#define USER_HEAD_IMAGE_KEY_FORMAT  @"USER_HEAD_IMAGE_KEY_%@"

@implementation EHUserDefaultData


+(void)setCurrentSelectBabyId:(NSInteger)babyId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:babyId forKey:[self getKey:CURRENT_BABY_ID]];
    [userDefaults synchronize];
}

+(NSInteger)getCurrentSelectBabyId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:[self getKey:CURRENT_BABY_ID]];
}

+(void)setCurrentLocationCoordinator:(CLLocationCoordinate2D)locationCoordinate babyId:(NSInteger)babyId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray* array = @[[NSNumber numberWithDouble:locationCoordinate.latitude],[NSNumber numberWithDouble:locationCoordinate.longitude]];
    [userDefaults setObject:array forKey:[self getKey:[NSString stringWithFormat:@"%lu",babyId]]];
    [userDefaults synchronize];
}

+(CLLocationCoordinate2D)getCurrentLocationCoordinatorWithBabyId:(NSInteger)babyId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray* array = [userDefaults objectForKey:[self getKey:[NSString stringWithFormat:@"%lu",babyId]]];
    if (array && [array count] == 2) {
        NSNumber* latitude = [array objectAtIndex:0];
        NSNumber* longitude = [array objectAtIndex:1];

        return CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    }
    CLLocationDegrees latitude = 30.381263;
    CLLocationDegrees longitude = 120.016321;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return coordinate;
}

+(NSString*)getKey:(NSString*)basicKey{
    return [NSString stringWithFormat:@"%@_%@",[KSAuthenticationCenter userPhone],basicKey];
}

+(BOOL)getIsNotFirstLoadApplication{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:ISNotFirstLoadApplication];

}

+(void)setIsNotFirstLoadApplication:(BOOL)isNotFirstLoad{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isNotFirstLoad forKey:ISNotFirstLoadApplication];
    [userDefaults synchronize];
}


+(NSString*)getBabyHeadImagePath:(NSNumber*)babyId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:[NSString stringWithFormat:BABY_HEAD_IMAGE_KEY_FORMAT, babyId]];
    
}

+(void)setBabyHeadImagePath:(NSString*)imagePath byBabyId:(NSNumber*)babyId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:imagePath forKey:[NSString stringWithFormat:BABY_HEAD_IMAGE_KEY_FORMAT, babyId]];
    [userDefaults synchronize];
}

+(NSString*)getUserHeadImagePath:(NSNumber*)userId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:[NSString stringWithFormat:USER_HEAD_IMAGE_KEY_FORMAT, userId]];
    
}

+(void)setUserHeadImagePath:(NSString*)imagePath byUserId:(NSNumber*)userId{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:imagePath forKey:[NSString stringWithFormat:USER_HEAD_IMAGE_KEY_FORMAT, userId]];
    [userDefaults synchronize];
}

@end
