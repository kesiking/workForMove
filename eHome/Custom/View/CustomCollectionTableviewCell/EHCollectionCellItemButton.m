//
//  MWAppItemButton.m
//  MobileWallet
//
//  Created by louzhenhua on 14-8-8.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#define kImageHeightPercent 0.65

#import "EHCollectionCellItemButton.h"
#import "UIColor+Ext.h"

@implementation EHCollectionCellItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * kImageHeightPercent;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * kImageHeightPercent;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * (1 - kImageHeightPercent);
    
    return CGRectMake(x, y, width, height);
}

@end
