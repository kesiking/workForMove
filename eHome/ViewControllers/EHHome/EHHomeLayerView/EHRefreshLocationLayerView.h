//
//  EHRefreshLocationLayerView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

typedef void (^doRefreshLocationClickedBlock)       (BOOL needRefreshLocation);

@interface EHRefreshLocationLayerView : KSView

@property (nonatomic, strong) UIButton                  *refreshBtn;

@property (nonatomic, strong) UIButton                  *addBabyBtn;

@property (nonatomic, strong) EHGetBabyListRsp          *babyUserInfo;  

@property (nonatomic, copy) doRefreshLocationClickedBlock refreshLocationBlock;

@end
