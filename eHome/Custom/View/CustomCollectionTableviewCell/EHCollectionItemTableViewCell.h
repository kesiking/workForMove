//
//  MWAppItemCell.h
//  MobileWallet
//
//  Created by louzhenhua on 14-8-8.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>




#define kCollectionItemCount 3
#define kEHCollectionItemTableViewCellHeight 120

@class EHCollectionItemTableViewCell;
@protocol EHCollectionItemTableViewCellDelegate <NSObject>
@optional
- (void)appItemCell:(EHCollectionItemTableViewCell *)cell actionWithTag:(NSInteger)tag;
@end

@interface EHCollectionItemTableViewCell : UITableViewCell
@property (weak, nonatomic) id<EHCollectionItemTableViewCellDelegate> cellDelegate;
- (void)setupCollectionItems:(NSArray *)CollectionItemList;
@end
