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
#define kChatMe                     @"chat_me"
#define kChatOther                  @"chat_other"

#define kSpaceX_CellSide  12
#define kSpaceX_Image_Bubble 6
#define kSpaceX_Bubble_Content_Side 17
#define kSpaceX_Bubble_Content_Middle 12
#define kSpaceY_CellTop_SubTop 12
#define kSpaceY_Time_Content 15.5
#define kSpaceY_Bubble_Content 13

#define kHeadImageWidth 40
#define kSpaceX_Bubble_CellSide (kSpaceX_CellSide + kHeadImageWidth + kSpaceX_Image_Bubble)

#define kTimeWidth (SCREEN_WIDTH - kSpaceX_CellSide * 2)
#define kTimeHeight (40 - 31)
#define kLabelMaxWidth (SCREEN_WIDTH - kSpaceX_Bubble_CellSide * 2 - kSpaceX_Bubble_Content_Side - kSpaceX_Bubble_Content_Middle)


#endif
