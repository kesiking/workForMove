//
//  EHMapOverLayWithOutLineServiceContainer.m
//  eHome
//
//  Created by 孟希羲 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapOverLayWithOutLineServiceContainer.h"
#import "EHUserDevicePosition.h"
#import "EHPositionAnnotation.h"
#import "EHMessageManager.h"
#import "EHDeviceStatusMessageModel.h"

@implementation EHMapOverLayWithOutLineServiceContainer

-(void)setupView{
    [super setupView];
    [self initNotification];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyOutLineNotification:) name:EHBabyOutLineNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyOnLineNotification:) name:EHBabyOnLineNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyLowBatteryNotification:) name:EHBabyLowBatteryNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babySOSMessageNotification:) name:EHBabySOSMessageNotification object:nil];
}

-(void)reloadData{
    [super reloadData];
    //EHPositionAnnotation* positionAnnotation = [self getCurrentPositionAnnotation];
    // 根据当前位置设定设备状态
//    [self setupDeviceStatusWithPosition:positionAnnotation.position];
}

-(void)setupDeviceStatusWithPosition:(EHUserDevicePosition*)position{
    if ([position.device_status integerValue] == EHDeviceStatus_OutLine) {
        // 离线状态
        EHDeviceStatusMessageModel* messageModel = [EHDeviceStatusMessageModel new];
        messageModel.deviceStatusModel = [EHDeviceStatusModel new];
        messageModel.deviceStatusModel.device_status = [NSNumber numberWithInteger:EHDeviceStatus_OutLine];
        [[EHMessageManager sharedManager] sendMessage:messageModel];
    }else if ([position.device_kwh floatValue] <= EHDeviceMiddleLowKwhNumber){
        // 低调量状态
        EHDeviceStatusMessageModel* messageModel = [EHDeviceStatusMessageModel new];
        messageModel.deviceStatusModel = [EHDeviceStatusModel new];
        messageModel.deviceStatusModel.device_kwh = [NSNumber numberWithInteger:EHDeviceMiddleLowKwhNumber];
        [[EHMessageManager sharedManager] sendMessage:messageModel];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)babyOutLineNotification:(NSNotification*)notification{
    EHBabyLocationAnnotationView* annotationView = [self getCurrentPositionAnnotationView];
    if (annotationView.alpha == 1) {
        annotationView.alpha = 0.5;
    }
}

-(void)babyOnLineNotification:(NSNotification*)notification{
    EHBabyLocationAnnotationView* annotationView = [self getCurrentPositionAnnotationView];
    if (annotationView.alpha != 1) {
        annotationView.alpha = 1;
    }
}

-(void)babyLowBatteryNotification:(NSNotification*)notification{
    EHGetBabyListRsp* currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    [self loadBabyMapListWithBabyUserInfo:currentBabyUserInfo];
}

-(void)babySOSMessageNotification:(NSNotification*)notification{
    EHGetBabyListRsp* currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    NSNumber* messageBabyId = [notification.userInfo objectForKey:EHMESSAGE_BABY_ID_DATA];
    if (messageBabyId && [currentBabyUserInfo.babyId integerValue] == [messageBabyId integerValue]) {
        [self loadBabyMapListWithBabyUserInfo:currentBabyUserInfo];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method
-(EHBabyLocationAnnotationView*)getCurrentPositionAnnotationView{
    EHPositionAnnotation* pointAnnotation = [self getCurrentPositionAnnotation];
    if (pointAnnotation == nil) {
        return nil;
    }
    MAAnnotationView* annotationView = [self.mapView viewForAnnotation:pointAnnotation];
    if ([annotationView isKindOfClass:[EHBabyLocationAnnotationView class]]) {
        return (EHBabyLocationAnnotationView*)annotationView;
    }
    return nil;
}

-(EHPositionAnnotation*)getCurrentPositionAnnotation{
    if (self.annotationArray == nil || [self.annotationArray count] == 0) {
        return nil;
    }
    if ([self.annotationArray count] <= self.currentPositionIndex) {
        return [self.annotationArray lastObject];
    }
    EHPositionAnnotation* pointAnnotation = [self.annotationArray objectAtIndex:self.currentPositionIndex];
    if ([pointAnnotation isKindOfClass:[EHPositionAnnotation class]]) {
        return pointAnnotation;
    }
    return nil;
}

@end
