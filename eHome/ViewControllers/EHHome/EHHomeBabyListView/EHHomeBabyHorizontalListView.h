//
//  EHHomeBabyHorizontalListView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHGetBabyListRsp.h"
#import "EHBabyHorizontalBasicListView.h"

static NSInteger EHBabyNonFoundNum = -1;

@class EHHomeBabyHorizontalListView;

typedef void (^doAddBabyClickedBlock)       (EHHomeBabyHorizontalListView* babyListView);

typedef void (^hasBabyDataBlock)            (EHHomeBabyHorizontalListView* babyListView, BOOL hasBabyData);

@interface EHHomeBabyHorizontalListView : EHBabyHorizontalBasicListView

@property (nonatomic, strong) NSArray *                   babyListArray;

@property (nonatomic, assign) BOOL                        isServiceFailed;

// 添加baby操作
@property (nonatomic, copy)   doAddBabyClickedBlock       addBabyClickedBlock;
// baby列表数据返回时触发，告知是否有宝贝绑定
@property (nonatomic, copy)   hasBabyDataBlock            hasBabyDataBlock;

/*!
 *  @brief  resetBabyHorizontailListView清除list中的宝贝数据及宝贝按钮
 *
 *  @since 1.0
 */
-(void)resetBabyHorizontailListView;

/*!
 *  @brief  switchToBabyWithBabyId用于切换宝贝
 *
 *  @param babyId 需要切换到的宝贝babyId
 *
 *  @since 1.0
 */
-(void)switchToBabyWithBabyId:(NSNumber*)babyId;
/**
 *  @brief 有新的聊天消息，通知listView添加小红点
 *  @param babyId 有新消息的BabyId
 */
-(void)hasUnselectedBabyChatMessageWithBabyId:(NSNumber *)babyId;
/**
 *  清除所有小红点标志
 */
-(void)clearListViewRedPoints;
@end
