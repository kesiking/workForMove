//
//  TBSNSBannerView.m
//  Taobao2013
//
//  Created by 逸行 on 13-1-18.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppBasicBannerView.h"
#import "WeAppBannerItem.h"
#import <QuartzCore/QuartzCore.h>

#define BannerViewTag  1001

@interface WeAppBasicBannerView ()

@property (nonatomic, assign) BOOL                      isLoadFailed;

@end

#define SNSBannerBackground                           @"gz_image_loading.png"
#define SNSBannerDefaultImage                         @"gz_image_loading.png"


@implementation WeAppBasicBannerView
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public
-(void) reloadData
{
}

-(void)loadData {
    [_dataArray removeAllObjects];
    if ([_dataArray count]>0) {
        [self bannerScrollViewRelaod];
    }
}

-(void)setLocalData:(NSArray*)array{
    if (array && [array count] > 0) {
        if ([self needReload:array]){
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:array];
            if ([_dataArray count]>0) {
                [self bannerScrollViewRelaod];
            }
        }
    }
}

-(void)bannerScrollViewRelaod{
    //cycleScroll
    [self.bannerCycleScrollView reloadData];
    if (!self.isPageControlCenter) {
        self.bannerCycleScrollView.isPageControlCenter = self.isPageControlCenter;
        self.bannerCycleScrollView.pageControl.frame = CGRectMake((self.bannerCycleScrollView.frame.size.width - _bannerCycleScrollView.pageControl.frame.size.width)/2, self.bannerCycleScrollView.pageControl.origin.y, self.bannerCycleScrollView.pageControl.frame.size.width,  self.bannerCycleScrollView.pageControl.frame.size.height);
    }
}

-(BOOL)needReload:(NSArray*)newData {
    if (_dataArray == nil || _dataArray.count != newData.count) {
        return YES;
    }
    
    if (_dataArray && [_dataArray count] > 0 && newData && [newData count] > 0) {
        id oldItem = [_dataArray objectAtIndex:0];
        id newItem = [newData objectAtIndex:0];
        if (![[oldItem class] isSubclassOfClass:[newItem class]]) {
            return YES;
        }
    }
    
    for (int i = 0; i<newData.count; i++) {
        WeAppBannerItem *newItem = [newData objectAtIndex:i];
        
        int j = 0;
        for (; j<_dataArray.count; j++) {
            id oldItem = [_dataArray objectAtIndex:j];
            if (![oldItem isKindOfClass:[WeAppBannerItem class]]) {
                continue;
            }
            
            if ([((WeAppBannerItem *)oldItem).url isEqualToString:newItem.url]) {
                break;
            }
        }
        
        if (j == _dataArray.count) {
            return YES;
        }
    }
    
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Life Circle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:SNSBannerDefaultImage];
        if (image != nil) {
            _dataArray = [NSMutableArray arrayWithObject:image];
        }
        
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] initWithCapacity:5];
        }
        //默认pageController是居中的
        self.isPageControlCenter = YES;
        
        //cycleScroll
        _bannerCycleScrollView = [[WeAppCycleScrollView alloc]initWithFrame:frame];
        [_bannerCycleScrollView setBackgroundColor:[UIColor clearColor]];
        _bannerCycleScrollView.opaque = YES;
        _bannerCycleScrollView.delegate = self;
        _bannerCycleScrollView.datasource = self;
        _bannerCycleScrollView.autoScrollEnabled = NO;
        _bannerCycleScrollView.scrollView.scrollsToTop = NO;
        _bannerCycleScrollView.isPageControlCenter = self.isPageControlCenter;
        _bannerCycleScrollView.disablePageClick = YES;
        
        _bannerCycleScrollView.pageControl.frame = CGRectMake(frame.size.width - _bannerCycleScrollView.pageControl.frame.size.width - 50, frame.size.height - _bannerCycleScrollView.pageControl.height - 8, 8, 8);
        
        _bannerCycleScrollView.pageControl.normalPageColor = [UIColor colorWithWhite:185/255.0 alpha:0.4];
        
        _bannerCycleScrollView.pageControl.width = 7;
        _bannerCycleScrollView.pageControl.height = 7;
        _bannerCycleScrollView.pageControl.gap = 8;
        
        [_bannerCycleScrollView reloadData];
        [self addSubview:_bannerCycleScrollView];
        
        self.isRounded = YES;//默认有圆角
        self.bannerBoundWidth = 0;//默认banner之间没有间隔
        
    }
    return self;
}

-(UIImageView *)bannerBackgroundImage{
    if (_bannerBackgroundImage == nil) {
        _bannerBackgroundImage = [[UIImageView alloc] initWithFrame:self.bannerCycleScrollView.bounds];
        [self insertSubview:_bannerBackgroundImage belowSubview:self.bannerCycleScrollView];
    }
    return _bannerBackgroundImage;
}

-(UIButton *)bannerCloseButton{
    if (_bannerCloseButton == nil) {
        _bannerCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 8, 8, 20, 20)];
        [_bannerCloseButton setBackgroundImage:[[UIImage imageNamed:@"feedStream_dynamic_banner_close.png"] stretchableImageWithLeftCapWidth: 12 topCapHeight: 12] forState:UIControlStateNormal];
        _bannerCloseButton.exclusiveTouch = YES;
        _bannerCloseButton.hidden = YES;
        [self addSubview:_bannerCloseButton];
    }
    return _bannerCloseButton;
}

-(void)setBannerViewFrame:(CGRect)frame{
    //cycleScroll
    _bannerCycleScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    [_bannerCloseButton setOrigin:CGPointMake(frame.size.width - 16, frame.origin.y + 4)];
    _bannerCycleScrollView.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [_bannerCycleScrollView.scrollView setContentSize:CGSizeMake(_bannerCycleScrollView.scrollView.contentSize.width, _bannerCycleScrollView.scrollView.frame.size.height)];
    if (self.isPageControlCenter) {
        [_bannerCycleScrollView.pageControl setFrame:CGRectMake(_bannerCycleScrollView.pageControl.frame.origin.x, frame.size.height - _bannerCycleScrollView.pageControl.height-8, _bannerCycleScrollView.pageControl.frame.size.width, _bannerCycleScrollView.pageControl.frame.size.height)];
    }else{
        _bannerCycleScrollView.isPageControlCenter = self.isPageControlCenter;
        _bannerCycleScrollView.pageControl.frame = CGRectMake((frame.size.width - _bannerCycleScrollView.pageControl.frame.size.width)/2, frame.size.height - _bannerCycleScrollView.pageControl.height-8, _bannerCycleScrollView.pageControl.frame.size.width, _bannerCycleScrollView.pageControl.frame.size.height);
    }
}

-(void)setIsRounded:(BOOL)isRounded{
    _isRounded = isRounded;
    if (isRounded) {
        _bannerPageControll.layer.cornerRadius = 4;
        _bannerPageControll.layer.masksToBounds = YES;
        //cycleScroll
        _bannerCycleScrollView.layer.cornerRadius = 4;
        _bannerCycleScrollView.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }else{
        _bannerPageControll.layer.cornerRadius = 0;
        _bannerPageControll.layer.masksToBounds = YES;
        //cycleScroll
        _bannerCycleScrollView.layer.cornerRadius = 0;
        _bannerCycleScrollView.layer.masksToBounds = YES;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
    }
}

-(void)setStopScroll:(BOOL)stopScroll{
    //cycleScroll
    [_bannerCycleScrollView setStopScroll:stopScroll];
}


- (void)dealloc{
    //cycleScroll
    _bannerCycleScrollView.delegate = nil;
    _bannerCycleScrollView.datasource = nil;
    _bannerCycleScrollView = nil;
    self.delegate = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Accessors

- (void)bannerClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BannerView:didSelectPageWithURL:)]) {
        if (self.itemView == nil) {
            [self.delegate BannerView:self didSelectPageWithURL:[NSURL URLWithString:((WeAppBannerItem *)[_dataArray objectAtIndex:self.bannerCycleScrollView.pageControl.currentPage]).url]];
        }
    }
}

-(void)setHidden:(BOOL)hidden{
    self.bannerCloseButton.hidden = hidden;
    self.bannerCycleScrollView.hidden = hidden;
    [super setHidden:hidden];
}

#pragma mark -
#pragma mark TBCycleScrollViewDelegate

-(void)didClickPage:(WeAppCycleScrollView *)csView atIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BannerView:didSelectPageWithURL:)] && index < [_dataArray count]) {
        id obj = [_dataArray objectAtIndex:index];
        if (obj && [obj isKindOfClass:[WeAppBannerItem class]]) {
            [self.delegate BannerView:self didSelectPageWithURL:[NSURL URLWithString:((WeAppBannerItem *)obj).url]];
        }
        
    }
}

#pragma mark -
#pragma mark TBCycleScrollViewDatasource

-(NSInteger)numberOfPages:(WeAppCycleScrollView *)csView {
    return [_dataArray count];
}

- (UIView *)csView:(WeAppCycleScrollView *)csView pageAtIndex:(NSInteger)pageIndex {
    if (pageIndex >= _dataArray.count)
        return nil;
    id obj = [_dataArray objectAtIndex:pageIndex];
    
    if (obj == nil) {
        return nil;
    }
    
    if ([obj isKindOfClass:[UIImage class]]) {
        UIImageView* bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bannerCycleScrollView.scrollView.frame.size.width - 2*self.bannerBoundWidth, self.bannerCycleScrollView.scrollView.frame.size.height)];
        [bannerImageView setImage:obj];
        return bannerImageView;
    }
    
    if (![obj isKindOfClass:[WeAppBannerItem class]]) {
        return nil;
    }
    
    WeAppBannerItem* bannerItem = (WeAppBannerItem*)obj;
    
    if (bannerItem.picture == nil || bannerItem.picture.length == 0){
        return nil;
    }
    
    UIImageView* bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bannerCycleScrollView.scrollView.frame.size.width - 2*self.bannerBoundWidth, self.bannerCycleScrollView.scrollView.frame.size.height)];
    //图片居中显示，不拉伸
    [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [bannerImageView setClipsToBounds:YES];
    [bannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerItem.picture] placeholderImage:[UIImage imageNamed:SNSBannerBackground]];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:self.bannerCycleScrollView.scrollView.frame];
    btn.tag = BannerViewTag;
    [btn addTarget:self action:@selector(bannerClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:bannerImageView];
    
    return btn;
    
}

@end
