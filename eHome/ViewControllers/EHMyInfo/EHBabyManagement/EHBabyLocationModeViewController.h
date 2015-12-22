//
//  EHBabySafeModeViewController.h
//  eHome
//
//  Created by jss on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ModifyLocationModeSuccess)(NSString* modifiedLocationMode);
@interface EHBabyLocationModeViewController : KSViewController<UIActionSheetDelegate>

@property(nonatomic, strong)NSNumber * babyId;
@property(nonatomic, strong)NSString * locationMode;

@property(nonatomic,copy)ModifyLocationModeSuccess modifyLocationModeSuccess;

@end
