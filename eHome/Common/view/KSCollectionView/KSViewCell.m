//
//  KSViewCell.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-24.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSViewCell.h"

@implementation KSViewCell

// 对于girdCell等不能变高的重定向为WeAppRefreshDataModelType_All
- (BOOL)checkCellLegalWithWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem{
    if (cell == nil || ![cell isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    if (![cell conformsToProtocol:@protocol(KSViewCellProtocol)]) {
        return NO;
    }
    return YES;
}

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if ([extroParams isKindOfClass:[KSCellModelInfoItem class]]) {
        self.indexPath = extroParams.cellIndexPath;
    }
}

- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

- (void)configDeleteCellWithCellView:(id<KSViewCellProtocol>)cell atIndexPath:(NSIndexPath*)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

-(void)dealloc{

}

@end
