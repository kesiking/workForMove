//
//  EHMessageCellModelInfoItem.h
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSDataSource.h"

@interface EHMessageCellModelInfoItem : KSCellModelInfoItem

@property (nonatomic, strong) NSString*          messageTime;
@property (nonatomic, strong) NSString*          messageDate;
@property (nonatomic, strong) NSString*          timeStamp;
@property (nonatomic, assign) BOOL               needTimeStamp;
@property (nonatomic, assign) CGSize             messageInfoSize;

@end
