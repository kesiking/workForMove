//
//  EHCollectionCellItem.h
//  eHome
//
//  Created by louzhenhua on 14-8-8.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHCollectionCellItem : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemImageName;
@property (assign, nonatomic) NSInteger itemTag;

@end
