//
//  EHFeedbackMacro.h
//  eHome
//
//  Created by xtq on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#ifndef eHome_EHFeedbackMacro_h
#define eHome_EHFeedbackMacro_h

#define kHeadportrait_administrator @"headportrait_administrator"
#define kHeadportrait_me            @"headportrait_home_150"

#define kSpaceX_CellSide  20
#define kSpaceX_Image_Bubble 5
#define kSpaceX_Bubble_Content_Side 25
#define kSpaceX_Bubble_Content_Middle 15
#define kSpaceY_CellTop_SubTop 15
#define kSpaceY_Time_Content 5
#define kSpaceY_Bubble_Content 12

#define kHeadImageWidth 40
#define kSpaceX_Bubble_CellSide (kSpaceX_CellSide + kHeadImageWidth + kSpaceX_Image_Bubble)

#define kTimeWidth (SCREEN_WIDTH - kSpaceX_CellSide * 2)
#define kLabelMaxWidth (SCREEN_WIDTH - kSpaceX_Bubble_CellSide * 2 - kSpaceX_Bubble_Content_Side - kSpaceX_Bubble_Content_Middle)


#endif
