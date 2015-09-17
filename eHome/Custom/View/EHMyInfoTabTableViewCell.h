//
//  EHMyInfoTabTableViewCell.h
//  eHome
//
//  Created by xtq on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellNameStr @"添加宝贝"

typedef void (^AddBtnClickBlock)();
typedef void (^QRImageViewClickBlock)();


@interface EHMyInfoTabTableViewCell : UITableViewCell

@property (nonatomic,copy) AddBtnClickBlock addBtnClickBlock;
@property (nonatomic,copy) QRImageViewClickBlock qrImageViewClickBlock;

- (void)configWithParams:(NSDictionary *)params;

@end
