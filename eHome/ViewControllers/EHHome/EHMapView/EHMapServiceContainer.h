//
//  EHMapServiceContainer.h
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapViewContainer.h"
#import "EHLocationService.h"
#import "EHGetBabyListRsp.h"

#define map_header_image_border (1.0)

@class EHMapServiceContainer;

typedef void (^doFinishedLoadServiceRefreshMapBlock)           (EHMapServiceContainer* mapService);

typedef BOOL (^shouldSelectAnnotationViewAfterRefreshMapBlock) (EHMapServiceContainer* mapService);

@interface EHMapServiceContainer : EHMapViewContainer{
    EHLocationService*     _listService;
    EHLocationService*     _refreshLocationService;
}

@property (nonatomic, strong) EHGetBabyListRsp      *babyUserInfo;

/*!
 *  @brief  position数据
 *
 *  @since 1.0
 */
// position足迹数据库
@property (nonatomic, strong) NSArray           *            positionArray;

/*!
 *  @brief  position数据
 *
 *  @since 1.0
 */
// 当前位置position数据index
@property (nonatomic, assign) NSUInteger                     currentPositionIndex;

@property (nonatomic, copy)   doFinishedLoadServiceRefreshMapBlock      finishedRefreshService;
@property (nonatomic, copy)   shouldSelectAnnotationViewAfterRefreshMapBlock      shouldSelectAnnotationViewAfterRefreshMap;

-(void)resetMapAnnotation;

-(void)setupMapAnnotation;

-(void)loadBabyMapListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo;

-(void)regreshLocationWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo;

-(void)loadLocationListWithBabyUserInfo:(EHGetBabyListRsp*)babyUserInfo;

/*!
 *  @brief  选中第index个annotationView
 *
 *  @param index 在原有的positionArray中选中index
 *
 *  @since 1.0
 */
-(void)selectAnnotationViewWithIndex:(NSUInteger)index;

-(void)selectAnnotationViewWithIndex:(NSUInteger)index withAnimation:(BOOL)animation;

/*!
 *  @brief  根据positionList刷新地图，而后选中第index个annotationView
 *
 *  @param positionList 新的地图点位置信息
 *  @param index        在原有的positionArray中选中index
 *
 *  @since 1.0
 */
-(void)selectAnnotationViewWithPositionList:(NSArray*)positionList withIndex:(NSUInteger)index;

@end
