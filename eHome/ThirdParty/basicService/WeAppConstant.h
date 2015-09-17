//
//  TBCAContanst.h
//  Taobao2013
//
//  Created by 淘云 on 14-1-2.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

// scale
//#define CA_SCALE    (0.5)
#define CA_BASE_SCALE (0.5)
#define CA_SCALE      ([WeAppEnviroment getScreenAdapterScale])

#define SCREEN_BASE     375
#define IPHON5_SCREEN_BASE     320
#define SCREEN_HEIGHT_BASE     667

#define SCREEN_SCALE    ([UIScreen mainScreen].bounds.size.width / SCREEN_BASE)
#define SCREEN_HEIGHT_SCALE    ([UIScreen mainScreen].bounds.size.height / SCREEN_HEIGHT_BASE)
#define SCREEN_HOR_BASE     325
#define SCREEN_HOR_SCALE    (([UIScreen mainScreen].bounds.size.width-50) / (SCREEN_HOR_BASE+50))

#define caculateNumber(x) (ceil(ceil((x) * SCREEN_SCALE)))
#define caculateHeightNumber(x) (ceil(ceil((x) * SCREEN_HEIGHT_SCALE)))

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

CG_INLINE CGSize
KSCGSizeMake(CGFloat width, CGFloat height)
{
    CGSize size;
    size.width = width * SCREEN_SCALE;
    size.height = height * SCREEN_SCALE;
    return size;
}

CG_INLINE CGRect
KSCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * SCREEN_SCALE;
    rect.origin.y = y * SCREEN_SCALE;
    rect.size.width = width * SCREEN_SCALE;
    rect.size.height = height * SCREEN_SCALE;
    return rect;
}

CG_INLINE CGPoint
KSCGPointMake(CGFloat x, CGFloat y)
{
    CGPoint p;
    p.x = x * SCREEN_SCALE;
    p.y = y * SCREEN_SCALE;
    return p;
}

#define SCREEN_WITHOUT_STATUS_HEIGHT (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

#if OS_OBJECT_USE_OBJC
#undef  WeAppDispatchQueueRelease
#undef  WeAppDispatchQueueSetterSementics
#define WeAppDispatchQueueRelease(q)
#define WeAppDispatchQueueSetterSementics strong
#else
#undef  WeAppDispatchQueueRelease
#undef  WeAppDispatchQueueSetterSementics
#define WeAppDispatchQueueRelease(q) (dispatch_release(q))
#define WeAppDispatchQueueSetterSementics assign
#endif
