//
//  UIMacro.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#ifndef basicFoundation_UIMacro_h
#define basicFoundation_UIMacro_h

#import "KSViewController.h"
#import "KSView.h"
#import "CSLinearLayoutView.h"
#import "TBDetailSystemUtil.h"
#import "TBDetailSKULayout.h"
#import "TBDetailUIStyle.h"
#import "TBDetailUITools.h"
#import "KSPaginationItem.h"
#import "EHPopMenuLIstView.h"

//#define EH_USE_NAVIGATION_NOTIFICATION

//#define USER_CUSTOM_LOADING_VIEW

#define UI_NAVIGATION_HEIGHT (IOS_VERSION<7?44:64)

#define UI_STATU_HEIGHT (IOS_VERSION<7?20:0)

#define UINAVIGATIONBAR_COLOR RGB(0xf8, 0xf8, 0xf8)
#define UINAVIGATIONBAR_TITLE_COLOR RGB(0x00, 0x00, 0x00)
#define UINAVIGATIONBAR_COMMON_COLOR EH_cor9

#define UISYSTEM_NETWORK_ERROR_TITLE   @"网络连接异常"
#define UISYSTEM_NETWORK_ERROR_MESSAGE @"当前网络异常，请检查您的网络"

#define EH_bgcor1 RGB(0xf0, 0xf0, 0xf0)
#define EH_bgcor2 RGB_A(0x00, 0x00, 0x00, 0.5)

#define EH_linecor1 RGB(0xd5, 0xd5, 0xd5)
#define EH_linecor2 RGB(0x6c, 0xbb, 0x52)

#define EH_cor1 RGB(0xff, 0xff, 0xff)
#define EH_cor2 RGB(0x6c, 0xbb, 0x52)
#define EH_cor3 RGB(0x33, 0x33, 0x33)
#define EH_cor4 RGB(0x66, 0x66, 0x66)
#define EH_cor5 RGB(0x99, 0x99, 0x99)
#define EH_cor6 RGB(0xdc, 0xdc, 0xdc)
#define EH_cor7 RGB(0xff, 0x3b, 0x30)
#define EH_cor8 RGB(0xd5, 0xd5, 0xd5)
#define EH_cor9 RGB(0x23, 0x74, 0xfa)
#define EH_cor10 RGB(0x7a, 0x81, 0xe3)
#define EH_cor11 RGB(0xff, 0xff, 0xff)
#define EH_cor12 RGB(0xcb, 0xcb, 0xcb)
#define EH_cor13 RGB(0xda, 0xda, 0xda)


#define EH_PieCor1 RGB(0xfe,0xcd,0x69)
#define EH_PieCor2 RGB(0xfa,0xfa,0xfa)
#define EH_PieCor3 RGB_A(0x94,0xdb,0xbb,0.4)
#define EH_PieCor4 RGB_A(0xfb,0xb2,0xd0,0.4)
#define EH_PieCor5 RGB_A(0xa4,0xd1,0xf0,0.4)
#define EH_PieCor6 RGB(0x94,0xdb,0xbb)
#define EH_PieCor7 RGB(0xfb,0xb2,0xd0)
#define EH_PieCor8 RGB(0xa4,0xd1,0xf0)
#define EH_barcor1 RGB(0x94, 0xdb, 0xbb)
#define EH_barcor2 RGB(0xfb, 0xb2, 0xd0)
#define EH_barcor3 RGB(0xff, 0xde, 0x9b)

#define EH_siz1 19//36px
#define EH_siz2 17//34px
#define EH_siz3 16//32px
#define EH_siz4 15//30px
#define EH_siz5 14//28px
#define EH_siz6 12//24px
#define EH_siz7 11//22px
#define EH_siz8 10//20px
#define EH_size9 24//48px

#define EH_font1 [UIFont systemFontOfSize:EH_siz1]//36px
#define EH_font2 [UIFont systemFontOfSize:EH_siz2]//34px
#define EH_font3 [UIFont systemFontOfSize:EH_siz3]//32px
#define EH_font4 [UIFont systemFontOfSize:EH_siz4]//30px
#define EH_font5 [UIFont systemFontOfSize:EH_siz5]//28px
#define EH_font6 [UIFont systemFontOfSize:EH_siz6]//24px
#define EH_font7 [UIFont systemFontOfSize:EH_siz7]//22px
#define EH_font8 [UIFont systemFontOfSize:EH_siz8]//20px
#define EH_font9 [UIFont systemFontOfSize:EH_siz9]//48px

#endif
