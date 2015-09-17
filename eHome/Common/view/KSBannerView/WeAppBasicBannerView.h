//
//  TBSNSBannerView.h
//  Taobao2013
//
//  Created by 逸行 on 13-1-18.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppCycleScrollView.h"
#import "WeAppBannerItem.h"

@protocol TBSNSBannerViewProtocol <NSObject>

-(void)setViewModel:(id)model;
@optional
-(void)setViewModel:(id)model withIndex:(NSNumber*)index;

@end


@class WeAppBasicBannerView;
@protocol TBSNSBannerViewDelegate <NSObject>

- (void) BannerView:(UIView*)aBannerView didSelectPageWithURL:(NSURL*) url;

@end

struct CGRectOffsetXY {
    CGFloat xOffset;
    CGFloat yOffset;
};
typedef struct CGRectOffsetXY CGRectOffsetXY;

@interface WeAppBasicBannerView : UIView<WeAppCycleScrollViewDatasource,WeAppCycleScrollViewDelegate,UIScrollViewDelegate>{
    WeAppCycleScrollView*                                                                                       _bannerCycleScrollView;
    UIPageControl*                                                                                      _bannerPageControll;
    NSMutableArray*                                                                                     _dataArray;
}

@property(nonatomic,weak)id<TBSNSBannerViewDelegate> delegate;
@property(nonatomic,strong)WeAppCycleScrollView*    bannerCycleScrollView;
@property(nonatomic,strong)UIImageView*             bannerBackgroundImage;
@property(nonatomic,strong)UIButton*                bannerCloseButton;
@property(nonatomic,assign)BOOL                     isRounded;//默认有圆角
@property(nonatomic,assign)BOOL                     isPageControlCenter;//默认有圆角
/*********************
 new property
 *********************/
@property(nonatomic,assign)NSUInteger bannerBoundWidth;//两个banner之间的间隔距离，默认为没有间距
@property(nonatomic,retain)Class itemModel;
@property(nonatomic,retain)Class itemView;
//更新bannerView数据
-(void) setStopScroll:(BOOL)stopScroll;
-(void) reloadData;
-(void) loadData;
-(void) setLocalData:(NSArray*)array;
-(void) setBannerViewFrame:(CGRect)frame;//设置bannerview的长宽及位置

@end
