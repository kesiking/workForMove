//
//  MWAppItemCell.m
//  MobileWallet
//
//  Created by louzhenhua on 14-8-8.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#define kCellWidth 320
#define kMarginX 8
#define kMarginY 4
#define kStartTag 100
#define kButtonHeight 100


#import "EHCollectionItemTableViewCell.h"
#import "EHCollectionCellItemButton.h"
#import "EHCollectionCellItem.h"

@implementation EHCollectionItemTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAppItemButtons];
    }
    return self;
}

- (void)initAppItemButtons
{
    NSInteger width = kCellWidth/kCollectionItemCount;
    for (NSInteger i = 0; i < kCollectionItemCount; i++)
    {
        EHCollectionCellItemButton *btn = [[EHCollectionCellItemButton alloc] init];
        btn.frame = CGRectMake(i*width + kMarginX, kMarginY, width - 2*kMarginX, kButtonHeight - 2*kMarginY);
        btn.tag = kStartTag + i;
        [self.contentView addSubview:btn];
    }
}

- (void)setupCollectionItems:(NSArray *)CollectionItemList
{
    for (NSInteger i = 0; i < kCollectionItemCount && i < CollectionItemList.count; i++)
    {
        EHCollectionCellItemButton *btn = (EHCollectionCellItemButton *)[self.contentView viewWithTag:kStartTag + i];
        EHCollectionCellItem *item = CollectionItemList[i];
        btn.tag = item.itemTag;
        [btn setImage:[UIImage imageNamed:item.itemImageName] forState:UIControlStateNormal];
        [btn setTitle:item.itemName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonTapped:(EHCollectionCellItemButton *)sender
{
    [self.cellDelegate appItemCell:self actionWithTag:sender.tag];
}



@end
